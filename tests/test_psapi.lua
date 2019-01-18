package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor

local psapi = require("win32.psapi")
require("win32.processthreadsapi")
require("win32.handleapi")

local function handleNumber(handle)
    return tonumber(ffi.cast("intptr_t", handle))
end

local function PrintModules(processID)
    -- Get a handle to the process.
    local hProcess = ffi.C.OpenProcess( bor(ffi.C.PROCESS_QUERY_INFORMATION,ffi.C.PROCESS_VM_READ), 0, processID );
    if (nil == hProcess) then
        return false, "OpenProcess FAILED";
    end
    
    -- Print the process identifier.
    print(string.format("\nProcess ID: %u\n", processID ));

   -- Get a list of all the modules in this process.
    local  hMods = ffi.new("HMODULE[1024]");
    local cbNeeded = ffi.new("DWORD[1]")
    if( ffi.C.K32EnumProcessModules(hProcess, hMods, ffi.sizeof(hMods), cbNeeded) ~= 0) then
        local nmodules = cbNeeded[0] / ffi.sizeof("HMODULE")
        for i = 0, nmodules-1 do
            local szModName = ffi.new("char[?]", ffi.C.MAX_PATH);

            -- Get the full path to the module's file.
            local success = ffi.C.K32GetModuleFileNameExA( hProcess, hMods[i], szModName, ffi.sizeof(szModName) / ffi.sizeof("char")) ~= 0
            if success then
                print(string.format("\t0x%8x\t%s", handleNumber(hMods[i]), ffi.string(szModName)))
            end
        end
    end

    -- Release the handle to the process.
    ffi.C.CloseHandle(hProcess);

    return true;
end


--[[
local function printModules(mHandle)
    print(mHandle)
end
--]]

local function processids()


    local function visit()
        local nprocesses = 1024
        local aProcesses = ffi.new("DWORD[?]", nprocesses); 
        local cbNeeded = ffi.new("DWORD[1]"); 

        -- Get the list of process identifiers.

        local success = ffi.C.K32EnumProcesses( aProcesses, ffi.sizeof(aProcesses), cbNeeded ) ~= 0

        if not success then
            --print("K32EnumProcesses FAILED")
            return nil;
        end

        -- Calculate how many process identifiers were returned.
        local cProcesses = cbNeeded[0] / ffi.sizeof("DWORD");

        for i = 0, cProcesses-1 do
            coroutine.yield( aProcesses[i] );
        end

        return nil;
    end

    local co = coroutine.create(visit)

    return function()
        local status, value = coroutine.resume(co)
        if status then
            return value
        else
            return nil
        end
    end
end


local function main()
    for procid in processids() do
        PrintModules(procid)
    end
end

main()