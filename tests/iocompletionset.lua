
local ffi = require("ffi");

local core_io = require("win32.ioapiset");
local errorhandling = require("win32.errhandlingapi");


ffi.cdef[[
typedef struct _IOCompletionHandle {
	HANDLE	Handle;
} IOCompletionHandle;
]]
local IOCompletionHandle = ffi.typeof("IOCompletionHandle")
local IOCompletionHandle_mt = {
	__index = {},
}
ffi.metatype("IOCompletionHandle", IOCompletionHandle_mt)


local iocompletionset = {}
setmetatable(iocompletionset, {
	__call = function(self, ...)
		return self:create(...);
	end,
});

local iocompletionset_mt = {
	__index = iocompletionset,
}

function iocompletionset.init(self, rawhandle)

	local obj = {
		Handle = IOCompletionHandle(rawhandle);
	};
	setmetatable(obj, iocompletionset_mt);

	return obj;
end

function iocompletionset.create(self, ExistingCompletionPort, FileHandle, NumberOfConcurrentThreads)
	FileHandle = FileHandle or INVALID_HANDLE_VALUE;
	NumberOfConcurrentThreads = NumberOfConcurrentThreads or 0
	local CompletionKey = 0;

	local rawhandle = ffi.C.Createiocompletionset(FileHandle,
		ExistingCompletionPort,
		CompletionKey,
		NumberOfConcurrentThreads);

	if rawhandle == nil then
		return false, ffi.C.GetLastError();
	end

	return self:init(rawhandle);
end

function iocompletionset.getNativeHandle(self)
	return self.Handle.Handle;
end

function iocompletionset.HasOverlappedIoCompleted(self, lpOverlapped) 
	return ffi.cast("DWORD",lpOverlapped.Internal) ~= ffi.C.STATUS_PENDING;
end

--[[
	Add another handle to the completion set so that we can
	watch for IO completion on that handle
--]]
function iocompletionset.add(self, otherhandle, Key)
	--Key = Key or ffi.cast("ULONG_PTR", 0);
	Key = ffi.cast("ULONG_PTR", ffi.cast("void *",Key));

	local rawhandle = ffi.C.CreateIOCompletionPort(otherhandle, self:getNativeHandle(), Key, 0);

	if rawhandle == nil then
		return false, errorhandling.GetLastError();
	end

	return iocompletionset(rawhandle);
end

function iocompletionset.enqueue(self, dwCompletionKey, dwNumberOfBytesTransferred, lpOverlapped)
	if not dwCompletionKey then
		print("iocompletionset.enqueue(), NO KEY SPECIFIED")
		return false, "no data specified"
	end

	dwNumberOfBytesTransferred = dwNumberOfBytesTransferred or 0;

	local status = ffi.C.PostQueuedCompletionStatus(self:getNativeHandle(),
		dwNumberOfBytesTransferred,
		ffi.cast("ULONG_PTR",ffi.cast("void *", dwCompletionKey)),
		lpOverlapped);
	
	if status == 0 then
		return false, errorhandling.GetLastError();
	end

	return self;
end

function iocompletionset.wait(self, timeout)
	timeout = timeout or ffi.C.INFINITE;


	local lpNumberOfBytesTransferred = ffi.new("DWORD[1]");
	local lpCompletionKey = ffi.new("ULONG_PTR[1]");	-- PULONG_PTR
	local lpOverlapped = ffi.new("LPOVERLAPPED[1]");
    
--[[
	local status = ffi.C.GetQueuedCompletionStatusEx(self:getNativeHandle(),
    	LPOVERLAPPED_ENTRY lpCompletionPortEntries,
    	ULONG ulCount,
    	PULONG ulNumEntriesRemoved,
    	timeout,
    	BOOL fAlertable
    );
--]]
	local status = core_io.GetQueuedCompletionStatus(self:getNativeHandle(),
    	lpNumberOfBytesTransferred,
    	lpCompletionKey,
    	lpOverlapped,
    	timeout);

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

	-- For the remaining cases, where success is indicated
	return true, {
		completionKey = lpCompletionKey[0],
		bytesTransferred = lpNumberOfBytesTransferred[0],
		overlapped = lpOverlapped[0]
	}
	--return lpCompletionKey[0], lpNumberOfBytesTransferred[0], lpOverlapped[0];
end


return iocompletionset;
