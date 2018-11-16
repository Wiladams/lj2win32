package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local bit = require("bit")
local band, bor = bit.band, bit.bor

local psapi = require("win32.psapi")
require("win32.processthreadsapi")
require("win32.handleapi")

local function PrintModules(processID)
--[[

    DWORD cbNeeded;
    unsigned int i;
--]]
    -- Print the process identifier.

    print(string.format("\nProcess ID: %u\n", processID ));

    -- Get a handle to the process.
    local hProcess = ffi.C.OpenProcess( bor(ffi.C.PROCESS_QUERY_INFORMATION,ffi.C.PROCESS_VM_READ), 0, processID );
    if (nil == hProcess) then
        print("OpenProcess FAILED")
        return false;
    end

   -- Get a list of all the modules in this process.
    local  hMods = ffi.new("HMODULE[1024]");
    local cbNeeded = ffi.new("DWORD[1]")
    if( ffi.C.K32EnumProcessModules(hProcess, hMods, ffi.sizeof(hMods), cbNeeded) ~= 0) then
        local nmodules = cbNeeded[0] / ffi.sizeof("HMODULE")
        for i = 0, nmodules-1 do
--[[        
            TCHAR szModName[MAX_PATH];

            -- Get the full path to the module's file.

            if ( GetModuleFileNameEx( hProcess, hMods[i], szModName,
                                      sizeof(szModName) / sizeof(TCHAR))) then
            
                -- Print the module name and handle value.

                _tprintf( TEXT("\t%s (0x%08X)\n"), szModName, hMods[i] );
            end
--]]
        end
    end

    -- Release the handle to the process.

    ffi.C.CloseHandle( hProcess );

    return true;
end


--[[
local function printModules(mHandle)
    print(mHandle)
end
--]]

local function  main( )

    local nprocesses = 1024
    local aProcesses = ffi.new("DWORD[?]", nprocesses); 
    local cbNeeded = ffi.new("DWORD[1]"); 


    -- Get the list of process identifiers.

    local success = ffi.C.K32EnumProcesses( aProcesses, ffi.sizeof(aProcesses), cbNeeded ) ~= 0
    
    if not success then
        print("K32EnumProcesses FAILED")
        return false;
    end

    -- Calculate how many process identifiers were returned.

    local cProcesses = cbNeeded[0] / ffi.sizeof("DWORD");

    -- Print the names of the modules for each process.

    for i = 0, cProcesses-1 do
        PrintModules( aProcesses[i] );
    end

    return true;
end

main()