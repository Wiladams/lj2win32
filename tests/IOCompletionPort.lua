
local ffi = require("ffi")

local core_io = require("win32.core.io_l1_1_1");
local errorhandling = require("win32.core.errhandlingapi");
local WinBase = require("win32.winbase");

ffi.cdef[[
typedef struct {
	HANDLE	Handle;
} IOCompletionHandle;
]]


local IOCompletionHandle = ffi.typeof("IOCompletionHandle")
local IOCompletionHandle_mt = {
	__index = {},
}
ffi.metatype(IOCompletionHandle, IOCompletionHandle_mt)


local IOCompletionPort = {}
setmetatable(IOCompletionPort, {
	__call = function(self, ...)
		return self:create(...);
	end,
});

local IOCompletionPort_mt = {
	__index = IOCompletionPort,
}

function IOCompletionPort.init(self, rawhandle)

	local obj = {
		Handle = IOCompletionHandle(rawhandle);
	};
	setmetatable(obj, IOCompletionPort_mt);

	return obj;
end

function IOCompletionPort.create(self, ExistingCompletionPort, FileHandle, NumberOfConcurrentThreads)
	FileHandle = FileHandle or INVALID_HANDLE_VALUE;
	NumberOfConcurrentThreads = NumberOfConcurrentThreads or 0
	local CompletionKey = 0;

	local rawhandle = core_io.CreateIoCompletionPort(FileHandle,
		ExistingCompletionPort,
		CompletionKey,
		NumberOfConcurrentThreads);

	if rawhandle == nil then
		return false, errorhandling.GetLastError();
	end

	return self:init(rawhandle);
end

--[[
IOCompletionPort.__toEssence = function(self)
	return string.format("IOCompletionPort:init(TINNThread:StringToPointer(%s))",
				TINNThread:PointerToString(self:getNativeHandle()));
end
--]]

function IOCompletionPort.getNativeHandle(self)
	return self.Handle.Handle;
end

function IOCompletionPort.addIoHandle(self, otherhandle, Key)
	Key = Key or ffi.cast("ULONG_PTR", 0);
	Key = ffi.cast("ULONG_PTR", ffi.cast("void *",Key));

	local rawhandle = core_io.CreateIoCompletionPort(otherhandle, self:getNativeHandle(), Key, 0);

	if rawhandle == nil then
		return false, errorhandling.GetLastError();
	end

	return IOCompletionPort(rawhandle);
end

function IOCompletionPort.HasOverlappedIoCompleted(self, lpOverlapped) 
	return ffi.cast("DWORD",lpOverlapped.Internal) ~= ffi.C.STATUS_PENDING;
end

function IOCompletionPort.enqueue(self, dwCompletionKey, dwNumberOfBytesTransferred, lpOverlapped)
	if not dwCompletionKey then
		print("IOCompletionPort.enqueue(), NO KEY SPECIFIED")
		return false, "no data specified"
	end

	dwNumberOfBytesTransferred = dwNumberOfBytesTransferred or 0;

	local status = core_io.PostQueuedCompletionStatus(self:getNativeHandle(),
		dwNumberOfBytesTransferred,
		ffi.cast("ULONG_PTR",ffi.cast("void *", dwCompletionKey)),
		lpOverlapped);
	
	if status == 0 then
		return false, errorhandling.GetLastError();
	end

	return self;
end

function IOCompletionPort.dequeue(self, dwMilliseconds)
	dwMilliseconds = dwMilliseconds or ffi.C.INFINITE;

	local lpNumberOfBytesTransferred = ffi.new("DWORD[1]");
	local lpCompletionKey = ffi.new("ULONG_PTR[1]");	-- PULONG_PTR
	local lpOverlapped = ffi.new("LPOVERLAPPED[1]");
	local status = core_io.GetQueuedCompletionStatus(self:getNativeHandle(),
    	lpNumberOfBytesTransferred,
    	lpCompletionKey,
    	lpOverlapped,
    	dwMilliseconds);

	if status == 0 then
		local err = errorhandling.GetLastError();
		
		-- If the dequeue failed, there can be two cases
		-- In the first case, the lpOverlapped is nil,
		-- in this case, nothing was dequeued, 
		-- so just return whatever the reported error was.
		if lpOverlapped[0] == nil then
			return false, err;
		end

		-- if lpOverlapped[0] ~= nil, then 
		-- data was transferred, but there is an error
		-- indicated in the underlying connection
		return false, err, lpCompletionKey[0], lpNumberOfBytesTransferred[0], lpOverlapped[0];
	end

	-- For the remaining cases
	return lpCompletionKey[0], lpNumberOfBytesTransferred[0], lpOverlapped[0];
end

return IOCompletionPort;
