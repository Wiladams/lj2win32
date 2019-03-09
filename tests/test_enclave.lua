package.path = "../?.lua;"..package.path;

local ffi = require("ffi")

require("win32.sdkddkver")
local enclave = require("win32.enclaveapi")
require("win32.winnt")
require("win32.processthreadsapi")
require("win32.errhandlingapi")

local function test_enclavesupport()
    local result = ffi.C.IsEnclaveTypeSupported(ffi.C.ENCLAVE_TYPE_SGX);
    print("supported: ENCLAVE_TYPE_SGX, ", result)

    local result = ffi.C.IsEnclaveTypeSupported(ffi.C.ENCLAVE_TYPE_VBS)
    print("supported: ENCLAVE_TYPE_VBS, ", result)

end

local function test_createenclave_SGX()
    local hProcess = ffi.C.GetCurrentProcess();
    local lpAddress = nil;
    local dwSize = 1024 * 4096  -- 4 MB
    local dwInitialCommitment = 1024 * 4096
    local flEnclaveType = ffi.C.ENCLAVE_TYPE_SGX
    local lpEnclaveInformation = ffi.new("ENCLAVE_CREATE_INFO_SGX")
    local dwInfoLength = 4096
    local lpEnclaveError = nil; -- ffi.new("DWORD[1]")

    local result = ffi.C.CreateEnclave(hProcess,
        lpAddress,
        dwSize,
        dwInitialCommitment,
        flEnclaveType,
        lpEnclaveInformation,
        dwInfoLength,
        lpEnclaveError);

    print("CreateEnclave SGX: ", result, ffi.C.GetLastError())
end

local function test_createenclave_VBS()
    local hProcess = nil;
    local lpAddress = nil;
    local dwSize = 1024 * 4094  -- 4 MB
    local dwInitialCommitment = 0
    local flEnclaveType = ffi.C.ENCLAVE_TYPE_VBS
    local lpEnclaveInformation = ffi.new("ENCLAVE_CREATE_INFO_VBS")
    local dwInfoLength = ffi.sizeof("ENCLAVE_CREATE_INFO_VBS")
    local lpEnclaveError = ffi.new("DWORD[1]")

    local result = ffi.C.CreateEnclave(hProcess,
        lpAddress,
        dwSize,
        dwInitialCommitment,
        flEnclaveType,
        lpEnclaveInformation,
        dwInfoLength,
        lpEnclaveError);

    print("CreateEnclave: ", result, lpEnclaveError[0], ffi.C.GetLastError())
end

--test_enclavesupport()
--test_createenclave_VBS()
test_createenclave_SGX()