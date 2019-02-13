
-- namespaceapi.h -- ApiSet Contract for api-ms-win-core-namespace-l1              *

local ffi = require("ffi")

--#include <apiset.h>
--#include <apisetcconv.h>
require("win32.winapifamily")
require("win32.minwindef")
require("win32.minwinbase")




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
static const int PRIVATE_NAMESPACE_FLAG_DESTROY    =  0x00000001;


HANDLE
__stdcall
CreatePrivateNamespaceW(
     LPSECURITY_ATTRIBUTES lpPrivateNamespaceAttributes,
     LPVOID lpBoundaryDescriptor,
     LPCWSTR lpAliasPrefix
    );



HANDLE
__stdcall
OpenPrivateNamespaceW(
     LPVOID lpBoundaryDescriptor,
     LPCWSTR lpAliasPrefix
    );



BOOLEAN
__stdcall
ClosePrivateNamespace(
     HANDLE Handle,
     ULONG Flags
    );



HANDLE
__stdcall
CreateBoundaryDescriptorW(
     LPCWSTR Name,
     ULONG Flags
    );



BOOL
__stdcall
AddSIDToBoundaryDescriptor(
     HANDLE* BoundaryDescriptor,
     PSID RequiredSid
    );



VOID
__stdcall
DeleteBoundaryDescriptor(
     HANDLE BoundaryDescriptor
    );
]]

end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

