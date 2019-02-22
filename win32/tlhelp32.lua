--[[
/*****************************************************************************\
*                                                                             *
* tlhelp32.h -  WIN32 tool help functions, types, and definitions             *
*                                                                             *
* Version 1.0                                                                 *
*                                                                             *
* NOTE: windows.h/winbase.h must be #included first                           *
*                                                                             *
* Copyright (c) Microsoft Corp.  All rights reserved.                         *
*                                                                             *
\*****************************************************************************/
--]]

local ffi = require("ffi")

require ("win32.winapifamily")
require("win32.windef")

if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then


ffi.cdef[[
static const int MAX_MODULE_NAME32 = 255;
]]

--/****** Shapshot function **********************************************/
ffi.cdef[[
HANDLE
__stdcall
CreateToolhelp32Snapshot(
    DWORD dwFlags,
    DWORD th32ProcessID
    );
]]

ffi.cdef[[
static const int TH32CS_SNAPHEAPLIST= 0x00000001;
static const int TH32CS_SNAPPROCESS = 0x00000002;
static const int TH32CS_SNAPTHREAD  = 0x00000004;
static const int TH32CS_SNAPMODULE  = 0x00000008;
static const int TH32CS_SNAPMODULE32= 0x00000010;
static const int TH32CS_SNAPALL     = (TH32CS_SNAPHEAPLIST | TH32CS_SNAPPROCESS | TH32CS_SNAPTHREAD | TH32CS_SNAPMODULE);
static const int TH32CS_INHERIT     = 0x80000000;
]]

--/****** heap walking ***************************************************/
ffi.cdef[[
typedef struct tagHEAPLIST32
{
    SIZE_T dwSize;
    DWORD  th32ProcessID;   // owning process
    ULONG_PTR  th32HeapID;      // heap (in owning processs context!)
    DWORD  dwFlags;
} HEAPLIST32;
typedef HEAPLIST32 *  PHEAPLIST32;
typedef HEAPLIST32 *  LPHEAPLIST32;
]]

ffi.cdef[[

static const int HF32_DEFAULT    =  1;  // processs default heap
static const int HF32_SHARED     =  2;  // is shared heap
]]

ffi.cdef[[
BOOL
__stdcall
Heap32ListFirst(
    HANDLE hSnapshot,
    LPHEAPLIST32 lphl
    );

BOOL
__stdcall
Heap32ListNext(
    HANDLE hSnapshot,
    LPHEAPLIST32 lphl
    );

typedef struct tagHEAPENTRY32
{
    SIZE_T dwSize;
    HANDLE hHandle;     // Handle of this heap block
    ULONG_PTR dwAddress;   // Linear address of start of block
    SIZE_T dwBlockSize; // Size of block in bytes
    DWORD  dwFlags;
    DWORD  dwLockCount;
    DWORD  dwResvd;
    DWORD  th32ProcessID;   // owning process
    ULONG_PTR  th32HeapID;      // heap block is in
} HEAPENTRY32;
typedef HEAPENTRY32 *  PHEAPENTRY32;
typedef HEAPENTRY32 *  LPHEAPENTRY32;
//
// dwFlags
//
static const int LF32_FIXED    = 0x00000001;
static const int LF32_FREE     = 0x00000002;
static const int LF32_MOVEABLE = 0x00000004;
]]

ffi.cdef[[
BOOL
__stdcall
Heap32First(
    LPHEAPENTRY32 lphe,
    DWORD th32ProcessID,
    ULONG_PTR th32HeapID
    );

BOOL
__stdcall
Heap32Next(
    LPHEAPENTRY32 lphe
    );

BOOL
__stdcall
Toolhelp32ReadProcessMemory(
    DWORD th32ProcessID,
    LPCVOID lpBaseAddress,
    LPVOID lpBuffer,
    SIZE_T cbRead,
    SIZE_T* lpNumberOfBytesRead
    );
]]

--/***** Process walking *************************************************/
ffi.cdef[[
typedef struct tagPROCESSENTRY32W
{
    DWORD   dwSize;
    DWORD   cntUsage;
    DWORD   th32ProcessID;          // this process
    ULONG_PTR th32DefaultHeapID;
    DWORD   th32ModuleID;           // associated exe
    DWORD   cntThreads;
    DWORD   th32ParentProcessID;    // this processs parent process
    LONG    pcPriClassBase;         // Base priority of processs threads
    DWORD   dwFlags;
    WCHAR   szExeFile[MAX_PATH];    // Path
} PROCESSENTRY32W;
typedef PROCESSENTRY32W *  PPROCESSENTRY32W;
typedef PROCESSENTRY32W *  LPPROCESSENTRY32W;

BOOL
__stdcall
Process32FirstW(
    HANDLE hSnapshot,
    LPPROCESSENTRY32W lppe
    );

BOOL
__stdcall
Process32NextW(
    HANDLE hSnapshot,
    LPPROCESSENTRY32W lppe
    );

typedef struct tagPROCESSENTRY32
{
    DWORD   dwSize;
    DWORD   cntUsage;
    DWORD   th32ProcessID;          // this process
    ULONG_PTR th32DefaultHeapID;
    DWORD   th32ModuleID;           // associated exe
    DWORD   cntThreads;
    DWORD   th32ParentProcessID;    // this processs parent process
    LONG    pcPriClassBase;         // Base priority of processs threads
    DWORD   dwFlags;
    CHAR    szExeFile[MAX_PATH];    // Path
} PROCESSENTRY32;
typedef PROCESSENTRY32 *  PPROCESSENTRY32;
typedef PROCESSENTRY32 *  LPPROCESSENTRY32;
]]

ffi.cdef[[
BOOL
__stdcall
Process32First(
    HANDLE hSnapshot,
    LPPROCESSENTRY32 lppe
    );

BOOL
__stdcall
Process32Next(
    HANDLE hSnapshot,
    LPPROCESSENTRY32 lppe
    );
]]

--[[
#ifdef UNICODE
#define Process32First Process32FirstW
#define Process32Next Process32NextW
#define PROCESSENTRY32 PROCESSENTRY32W
#define PPROCESSENTRY32 PPROCESSENTRY32W
#define LPPROCESSENTRY32 LPPROCESSENTRY32W
#endif  // !UNICODE
--]]

--/***** Thread walking **************************************************/
ffi.cdef[[
typedef struct tagTHREADENTRY32
{
    DWORD   dwSize;
    DWORD   cntUsage;
    DWORD   th32ThreadID;       // this thread
    DWORD   th32OwnerProcessID; // Process this thread is associated with
    LONG    tpBasePri;
    LONG    tpDeltaPri;
    DWORD   dwFlags;
} THREADENTRY32;
typedef THREADENTRY32 *  PTHREADENTRY32;
typedef THREADENTRY32 *  LPTHREADENTRY32;
]]

ffi.cdef[[
BOOL
__stdcall
Thread32First(
    HANDLE hSnapshot,
    LPTHREADENTRY32 lpte
    );

BOOL
__stdcall
Thread32Next(
    HANDLE hSnapshot,
    LPTHREADENTRY32 lpte
    );
]]

--/***** Module walking *************************************************/

ffi.cdef[[
typedef struct tagMODULEENTRY32W
{
    DWORD   dwSize;
    DWORD   th32ModuleID;       // This module
    DWORD   th32ProcessID;      // owning process
    DWORD   GlblcntUsage;       // Global usage count on the module
    DWORD   ProccntUsage;       // Module usage count in th32ProcessIDs context
    BYTE  * modBaseAddr;        // Base address of module in th32ProcessIDs context
    DWORD   modBaseSize;        // Size in bytes of module starting at modBaseAddr
    HMODULE hModule;            // The hModule of this module in th32ProcessIDs context
    WCHAR   szModule[MAX_MODULE_NAME32 + 1];
    WCHAR   szExePath[MAX_PATH];
} MODULEENTRY32W;
typedef MODULEENTRY32W *  PMODULEENTRY32W;
typedef MODULEENTRY32W *  LPMODULEENTRY32W;
]]

ffi.cdef[[
BOOL
__stdcall
Module32FirstW(
    HANDLE hSnapshot,
    LPMODULEENTRY32W lpme
    );

BOOL
__stdcall
Module32NextW(
    HANDLE hSnapshot,
    LPMODULEENTRY32W lpme
    );
]]

ffi.cdef[[
typedef struct tagMODULEENTRY32
{
    DWORD   dwSize;
    DWORD   th32ModuleID;       // This module
    DWORD   th32ProcessID;      // owning process
    DWORD   GlblcntUsage;       // Global usage count on the module
    DWORD   ProccntUsage;       // Module usage count in th32ProcessIDs context
    BYTE  * modBaseAddr;        // Base address of module in th32ProcessIDs context
    DWORD   modBaseSize;        // Size in bytes of module starting at modBaseAddr
    HMODULE hModule;            // The hModule of this module in th32ProcessIDs context
    char    szModule[MAX_MODULE_NAME32 + 1];
    char    szExePath[MAX_PATH];
} MODULEENTRY32;
typedef MODULEENTRY32 *  PMODULEENTRY32;
typedef MODULEENTRY32 *  LPMODULEENTRY32;
]]


ffi.cdef[[
BOOL
__stdcall
Module32First(
    HANDLE hSnapshot,
    LPMODULEENTRY32 lpme
    );

BOOL
__stdcall
Module32Next(
    HANDLE hSnapshot,
    LPMODULEENTRY32 lpme
    );
]]

--[[
#ifdef UNICODE
#define Module32First Module32FirstW
#define Module32Next Module32NextW
#define MODULEENTRY32 MODULEENTRY32W
#define PMODULEENTRY32 PMODULEENTRY32W
#define LPMODULEENTRY32 LPMODULEENTRY32W
#endif  // !UNICODE
--]]


end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
