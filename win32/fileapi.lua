
--* FileApi.h -- ApiSet Contract for api-ms-win-core-file-l1                      *

local ffi = require("ffi")

if not _APISETFILE_ then
_APISETFILE_ = true

--require("win32.apiset")
--require("win32.apisetcconv")
require("win32.minwindef")
require("win32.minwinbase")



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[
//
// Constants
//
static const int CREATE_NEW         = 1;
static const int CREATE_ALWAYS      = 2;
static const int OPEN_EXISTING      = 3;
static const int OPEN_ALWAYS        = 4;
static const int TRUNCATE_EXISTING  = 5;

static const int INVALID_FILE_SIZE =((DWORD)0xFFFFFFFF);
static const int INVALID_SET_FILE_POINTER =((DWORD)-1);
static const int INVALID_FILE_ATTRIBUTES =((DWORD)-1);
]]
end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then
ffi.cdef[[

LONG
__stdcall
CompareFileTime(
     const FILETIME* lpFileTime1,
     const FILETIME* lpFileTime2
    );



BOOL
__stdcall
CreateDirectoryA(
     LPCSTR lpPathName,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );


BOOL
__stdcall
CreateDirectoryW(
     LPCWSTR lpPathName,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes
    );
]]

--[[
#ifdef UNICODE
#define CreateDirectory  CreateDirectoryW
#else
#define CreateDirectory  CreateDirectoryA
#endif // !UNICODE
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP, WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
HANDLE
__stdcall
CreateFileA(
     LPCSTR lpFileName,
     DWORD dwDesiredAccess,
     DWORD dwShareMode,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
     DWORD dwCreationDisposition,
     DWORD dwFlagsAndAttributes,
     HANDLE hTemplateFile
    );


HANDLE
__stdcall
CreateFileW(
     LPCWSTR lpFileName,
     DWORD dwDesiredAccess,
     DWORD dwShareMode,
     LPSECURITY_ATTRIBUTES lpSecurityAttributes,
     DWORD dwCreationDisposition,
     DWORD dwFlagsAndAttributes,
     HANDLE hTemplateFile
    );
]]

--[[
#ifdef UNICODE
#define CreateFile  CreateFileW
#else
#define CreateFile  CreateFileA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
DefineDosDeviceW(
     DWORD dwFlags,
     LPCWSTR lpDeviceName,
     LPCWSTR lpTargetPath
    );
]]

--[[
#ifdef UNICODE
#define DefineDosDevice  DefineDosDeviceW
#endif
--]]

end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
DeleteFileA(
     LPCSTR lpFileName
    );


BOOL
__stdcall
DeleteFileW(
     LPCWSTR lpFileName
    );
]]

--[[
#ifdef UNICODE
#define DeleteFile  DeleteFileW
#else
#define DeleteFile  DeleteFileA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
DeleteVolumeMountPointW(
     LPCWSTR lpszVolumeMountPoint
    );
]]

--[[
#ifdef UNICODE
#define DeleteVolumeMountPoint  DeleteVolumeMountPointW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
FileTimeToLocalFileTime(
     const FILETIME* lpFileTime,
     LPFILETIME lpLocalFileTime
    );




BOOL
__stdcall
FindClose(
     HANDLE hFindFile
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
FindCloseChangeNotification(
     HANDLE hChangeHandle
    );



HANDLE
__stdcall
FindFirstChangeNotificationA(
     LPCSTR lpPathName,
     BOOL bWatchSubtree,
     DWORD dwNotifyFilter
    );


HANDLE
__stdcall
FindFirstChangeNotificationW(
     LPCWSTR lpPathName,
     BOOL bWatchSubtree,
     DWORD dwNotifyFilter
    );
]]

--[[
#ifdef UNICODE
#define FindFirstChangeNotification  FindFirstChangeNotificationW
#else
#define FindFirstChangeNotification  FindFirstChangeNotificationA
#endif // !UNICODE
--]]
end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
HANDLE
__stdcall
FindFirstFileA(
     LPCSTR lpFileName,
     LPWIN32_FIND_DATAA lpFindFileData
    );


HANDLE
__stdcall
FindFirstFileW(
     LPCWSTR lpFileName,
     LPWIN32_FIND_DATAW lpFindFileData
    );
]]

--[[
#ifdef UNICODE
#define FindFirstFile  FindFirstFileW
#else
#define FindFirstFile  FindFirstFileA
#endif // !UNICODE
--]]

--#if (_WIN32_WINNT >= 0x0400)

ffi.cdef[[
HANDLE
__stdcall
FindFirstFileExA(
     LPCSTR lpFileName,
     FINDEX_INFO_LEVELS fInfoLevelId,
     LPVOID lpFindFileData,
     FINDEX_SEARCH_OPS fSearchOp,
     LPVOID lpSearchFilter,
     DWORD dwAdditionalFlags
    );


HANDLE
__stdcall
FindFirstFileExW(
     LPCWSTR lpFileName,
     FINDEX_INFO_LEVELS fInfoLevelId,
     LPVOID lpFindFileData,
     FINDEX_SEARCH_OPS fSearchOp,
     LPVOID lpSearchFilter,
     DWORD dwAdditionalFlags
    );
]]

--[[
#ifdef UNICODE
#define FindFirstFileEx  FindFirstFileExW
#else
#define FindFirstFileEx  FindFirstFileExA
#endif // !UNICODE
--]]
--#endif /* _WIN32_WINNT >= 0x0400 */

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
HANDLE
__stdcall
FindFirstVolumeW(
     LPWSTR lpszVolumeName,
     DWORD cchBufferLength
    );
]]

--[[
#ifdef UNICODE
#define FindFirstVolume FindFirstVolumeW
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
FindNextChangeNotification(
     HANDLE hChangeHandle
    );
]]

end --// WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
FindNextFileA(
     HANDLE hFindFile,
     LPWIN32_FIND_DATAA lpFindFileData
    );


BOOL
__stdcall
FindNextFileW(
     HANDLE hFindFile,
     LPWIN32_FIND_DATAW lpFindFileData
    );
]]

--[[
#ifdef UNICODE
#define FindNextFile  FindNextFileW
#else
#define FindNextFile  FindNextFileA
#endif // !UNICODE
--]]
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
FindNextVolumeW(
     HANDLE hFindVolume,
     LPWSTR lpszVolumeName,
     DWORD cchBufferLength
    );
]]

--[[
#ifdef UNICODE
#define FindNextVolume FindNextVolumeW
#endif
--]]

ffi.cdef[[
BOOL
__stdcall
FindVolumeClose(
     HANDLE hFindVolume
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
FlushFileBuffers(
     HANDLE hFile
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
GetDiskFreeSpaceA(
     LPCSTR lpRootPathName,
     LPDWORD lpSectorsPerCluster,
     LPDWORD lpBytesPerSector,
     LPDWORD lpNumberOfFreeClusters,
     LPDWORD lpTotalNumberOfClusters
    );


BOOL
__stdcall
GetDiskFreeSpaceW(
     LPCWSTR lpRootPathName,
     LPDWORD lpSectorsPerCluster,
     LPDWORD lpBytesPerSector,
     LPDWORD lpNumberOfFreeClusters,
     LPDWORD lpTotalNumberOfClusters
    );
]]

--[[
#ifdef UNICODE
#define GetDiskFreeSpace  GetDiskFreeSpaceW
#else
#define GetDiskFreeSpace  GetDiskFreeSpaceA
#endif // !UNICODE
--]]

ffi.cdef[[
BOOL
__stdcall
GetDiskFreeSpaceExA(
     LPCSTR lpDirectoryName,
     PULARGE_INTEGER lpFreeBytesAvailableToCaller,
     PULARGE_INTEGER lpTotalNumberOfBytes,
     PULARGE_INTEGER lpTotalNumberOfFreeBytes
    );


BOOL
__stdcall
GetDiskFreeSpaceExW(
     LPCWSTR lpDirectoryName,
     PULARGE_INTEGER lpFreeBytesAvailableToCaller,
     PULARGE_INTEGER lpTotalNumberOfBytes,
     PULARGE_INTEGER lpTotalNumberOfFreeBytes
    );
]]

--[[
#ifdef UNICODE
#define GetDiskFreeSpaceEx  GetDiskFreeSpaceExW
#else
#define GetDiskFreeSpaceEx  GetDiskFreeSpaceExA
#endif // !UNICODE
--]]

ffi.cdef[[
UINT
__stdcall
GetDriveTypeA(
     LPCSTR lpRootPathName
    );


UINT
__stdcall
GetDriveTypeW(
     LPCWSTR lpRootPathName
    );
]]

--[[
#ifdef UNICODE
#define GetDriveType  GetDriveTypeW
#else
#define GetDriveType  GetDriveTypeA
#endif // !UNICODE
--]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */

--[=[
#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)

typedef struct _WIN32_FILE_ATTRIBUTE_DATA {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
} WIN32_FILE_ATTRIBUTE_DATA, *LPWIN32_FILE_ATTRIBUTE_DATA;


DWORD
__stdcall
GetFileAttributesA(
     LPCSTR lpFileName
    );


DWORD
__stdcall
GetFileAttributesW(
     LPCWSTR lpFileName
    );

#ifdef UNICODE
#define GetFileAttributes  GetFileAttributesW
#else
#define GetFileAttributes  GetFileAttributesA
#endif // !UNICODE


BOOL
__stdcall
GetFileAttributesExA(
     LPCSTR lpFileName,
     GET_FILEEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FILE_ATTRIBUTE_DATA)) LPVOID lpFileInformation
    );


BOOL
__stdcall
GetFileAttributesExW(
     LPCWSTR lpFileName,
     GET_FILEEX_INFO_LEVELS fInfoLevelId,
    _Out_writes_bytes_(sizeof(WIN32_FILE_ATTRIBUTE_DATA)) LPVOID lpFileInformation
    );

#ifdef UNICODE
#define GetFileAttributesEx  GetFileAttributesExW
#else
#define GetFileAttributesEx  GetFileAttributesExA
#endif // !UNICODE

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

typedef struct _BY_HANDLE_FILE_INFORMATION {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD dwVolumeSerialNumber;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD nNumberOfLinks;
    DWORD nFileIndexHigh;
    DWORD nFileIndexLow;
} BY_HANDLE_FILE_INFORMATION, *PBY_HANDLE_FILE_INFORMATION, *LPBY_HANDLE_FILE_INFORMATION;


BOOL
__stdcall
GetFileInformationByHandle(
     HANDLE hFile,
     LPBY_HANDLE_FILE_INFORMATION lpFileInformation
    );



DWORD
__stdcall
GetFileSize(
     HANDLE hFile,
     LPDWORD lpFileSizeHigh
    );


#endif // WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
GetFileSizeEx(
     HANDLE hFile,
     PLARGE_INTEGER lpFileSize
    );



DWORD
__stdcall
GetFileType(
     HANDLE hFile
    );


#if (_WIN32_WINNT >= 0x0600)


DWORD
__stdcall
GetFinalPathNameByHandleA(
     HANDLE hFile,
    _Out_writes_(cchFilePath) LPSTR lpszFilePath,
     DWORD cchFilePath,
     DWORD dwFlags
    );


DWORD
__stdcall
GetFinalPathNameByHandleW(
     HANDLE hFile,
    _Out_writes_(cchFilePath) LPWSTR lpszFilePath,
     DWORD cchFilePath,
     DWORD dwFlags
    );

#ifdef UNICODE
#define GetFinalPathNameByHandle  GetFinalPathNameByHandleW
#else
#define GetFinalPathNameByHandle  GetFinalPathNameByHandleA
#endif // !UNICODE

#endif // (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
GetFileTime(
     HANDLE hFile,
     LPFILETIME lpCreationTime,
     LPFILETIME lpLastAccessTime,
     LPFILETIME lpLastWriteTime
    );



_Success_(return != 0 && return < nBufferLength)
DWORD
__stdcall
GetFullPathNameW(
     LPCWSTR lpFileName,
     DWORD nBufferLength,
     LPWSTR lpBuffer,
    _Outptr_opt_ LPWSTR* lpFilePart
    );


#ifdef UNICODE
#define GetFullPathName  GetFullPathNameW
#endif


_Success_(return != 0 && return < nBufferLength)
DWORD
__stdcall
GetFullPathNameA(
     LPCSTR lpFileName,
     DWORD nBufferLength,
     LPSTR lpBuffer,
    _Outptr_opt_ LPSTR* lpFilePart
    );


#ifndef UNICODE
#define GetFullPathName GetFullPathNameA
#endif


DWORD
__stdcall
GetLogicalDrives(
    VOID
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


DWORD
__stdcall
GetLogicalDriveStringsW(
     DWORD nBufferLength,
     LPWSTR lpBuffer
    );


#ifdef UNICODE
#define GetLogicalDriveStrings  GetLogicalDriveStringsW
#endif


_Success_(return != 0 && return < cchBuffer)
DWORD
__stdcall
GetLongPathNameA(
     LPCSTR lpszShortPath,
    _Out_writes_to_opt_(cchBuffer,return + 1) LPSTR lpszLongPath,
     DWORD cchBuffer
    );


#ifndef UNICODE
#define GetLongPathName GetLongPathNameA
#endif

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


_Success_(return != 0 && return < cchBuffer)
DWORD
__stdcall
GetLongPathNameW(
     LPCWSTR lpszShortPath,
    _Out_writes_to_opt_(cchBuffer,return + 1) LPWSTR lpszLongPath,
     DWORD cchBuffer
    );


#ifdef UNICODE
#define GetLongPathName GetLongPathNameW
#endif

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


_Success_(return != 0 && return < cchBuffer)
DWORD
__stdcall
GetShortPathNameW(
     LPCWSTR lpszLongPath,
    _Out_writes_to_opt_(cchBuffer,return + 1) LPWSTR lpszShortPath,
     DWORD cchBuffer
    );


#ifdef UNICODE
#define GetShortPathName  GetShortPathNameW
#endif

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


UINT
__stdcall
GetTempFileNameW(
     LPCWSTR lpPathName,
     LPCWSTR lpPrefixString,
     UINT uUnique,
     LPWSTR lpTempFileName
    );


#ifdef UNICODE
#define GetTempFileName  GetTempFileNameW
#endif

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

#if (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
GetVolumeInformationByHandleW(
     HANDLE hFile,
     LPWSTR lpVolumeNameBuffer,
     DWORD nVolumeNameSize,
     LPDWORD lpVolumeSerialNumber,
     LPDWORD lpMaximumComponentLength,
     LPDWORD lpFileSystemFlags,
     LPWSTR lpFileSystemNameBuffer,
     DWORD nFileSystemNameSize
    );


#endif /* _WIN32_WINNT >=  0x0600 */
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
GetVolumeInformationW(
     LPCWSTR lpRootPathName,
     LPWSTR lpVolumeNameBuffer,
     DWORD nVolumeNameSize,
     LPDWORD lpVolumeSerialNumber,
     LPDWORD lpMaximumComponentLength,
     LPDWORD lpFileSystemFlags,
     LPWSTR lpFileSystemNameBuffer,
     DWORD nFileSystemNameSize
    );


#ifdef UNICODE
#define GetVolumeInformation  GetVolumeInformationW
#endif

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


BOOL
__stdcall
GetVolumePathNameW(
     LPCWSTR lpszFileName,
     LPWSTR lpszVolumePathName,
     DWORD cchBufferLength
    );


#ifdef UNICODE
#define GetVolumePathName  GetVolumePathNameW
#endif

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
LocalFileTimeToFileTime(
     const FILETIME* lpLocalFileTime,
     LPFILETIME lpFileTime
    );



BOOL
__stdcall
LockFile(
     HANDLE hFile,
     DWORD dwFileOffsetLow,
     DWORD dwFileOffsetHigh,
     DWORD nNumberOfBytesToLockLow,
     DWORD nNumberOfBytesToLockHigh
    );



BOOL
__stdcall
LockFileEx(
     HANDLE hFile,
     DWORD dwFlags,
     DWORD dwReserved,
     DWORD nNumberOfBytesToLockLow,
     DWORD nNumberOfBytesToLockHigh,
     LPOVERLAPPED lpOverlapped
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


DWORD
__stdcall
QueryDosDeviceW(
     LPCWSTR lpDeviceName,
    _Out_writes_to_opt_(ucchMax,return) LPWSTR lpTargetPath,
     DWORD ucchMax
    );


#ifdef UNICODE
#define QueryDosDevice  QueryDosDeviceW
#endif

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


_Must_inspect_result_
BOOL
__stdcall
ReadFile(
     HANDLE hFile,
    _Out_writes_bytes_to_opt_(nNumberOfBytesToRead, *lpNumberOfBytesRead) __out_data_source(FILE) LPVOID lpBuffer,
     DWORD nNumberOfBytesToRead,
     LPDWORD lpNumberOfBytesRead,
    _Inout_opt_ LPOVERLAPPED lpOverlapped
    );



_Must_inspect_result_
BOOL
__stdcall
ReadFileEx(
     HANDLE hFile,
    _Out_writes_bytes_opt_(nNumberOfBytesToRead) __out_data_source(FILE) LPVOID lpBuffer,
     DWORD nNumberOfBytesToRead,
     LPOVERLAPPED lpOverlapped,
     LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

    
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


_Must_inspect_result_
BOOL
__stdcall
ReadFileScatter(
     HANDLE hFile,
     FILE_SEGMENT_ELEMENT aSegmentArray[],
     DWORD nNumberOfBytesToRead,
     LPDWORD lpReserved,
     LPOVERLAPPED lpOverlapped
    );


#endif // WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)


#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
RemoveDirectoryA(
     LPCSTR lpPathName
    );


BOOL
__stdcall
RemoveDirectoryW(
     LPCWSTR lpPathName
    );

#ifdef UNICODE
#define RemoveDirectory  RemoveDirectoryW
#else
#define RemoveDirectory  RemoveDirectoryA
#endif // !UNICODE


BOOL
__stdcall
SetEndOfFile(
     HANDLE hFile
    );



BOOL
__stdcall
SetFileAttributesA(
     LPCSTR lpFileName,
     DWORD dwFileAttributes
    );


BOOL
__stdcall
SetFileAttributesW(
     LPCWSTR lpFileName,
     DWORD dwFileAttributes
    );

#ifdef UNICODE
#define SetFileAttributes  SetFileAttributesW
#else
#define SetFileAttributes  SetFileAttributesA
#endif // !UNICODE

#if (_WIN32_WINNT >= 0x0600)


BOOL
__stdcall
SetFileInformationByHandle(
     HANDLE hFile,
     FILE_INFO_BY_HANDLE_CLASS FileInformationClass,
    _In_reads_bytes_(dwBufferSize) LPVOID lpFileInformation,
     DWORD dwBufferSize
    );


#endif


DWORD
__stdcall
SetFilePointer(
     HANDLE hFile,
     LONG lDistanceToMove,
    _Inout_opt_ PLONG lpDistanceToMoveHigh,
     DWORD dwMoveMethod
    );



BOOL
__stdcall
SetFilePointerEx(
     HANDLE hFile,
     LARGE_INTEGER liDistanceToMove,
     PLARGE_INTEGER lpNewFilePointer,
     DWORD dwMoveMethod
    );



BOOL
__stdcall
SetFileTime(
     HANDLE hFile,
     const FILETIME* lpCreationTime,
     const FILETIME* lpLastAccessTime,
     const FILETIME* lpLastWriteTime
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

#if _WIN32_WINNT >= 0x0501


BOOL
__stdcall
SetFileValidData(
     HANDLE hFile,
     LONGLONG ValidDataLength
    );


#endif // (_WIN32_WINNT >= 0x0501)

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


#pragma region Application Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM)


BOOL
__stdcall
UnlockFile(
     HANDLE hFile,
     DWORD dwFileOffsetLow,
     DWORD dwFileOffsetHigh,
     DWORD nNumberOfBytesToUnlockLow,
     DWORD nNumberOfBytesToUnlockHigh
    );



BOOL
__stdcall
UnlockFileEx(
     HANDLE hFile,
     DWORD dwReserved,
     DWORD nNumberOfBytesToUnlockLow,
     DWORD nNumberOfBytesToUnlockHigh,
     LPOVERLAPPED lpOverlapped
    );



BOOL
__stdcall
WriteFile(
     HANDLE hFile,
    _In_reads_bytes_opt_(nNumberOfBytesToWrite) LPCVOID lpBuffer,
     DWORD nNumberOfBytesToWrite,
     LPDWORD lpNumberOfBytesWritten,
    _Inout_opt_ LPOVERLAPPED lpOverlapped
    );



BOOL
__stdcall
WriteFileEx(
     HANDLE hFile,
    _In_reads_bytes_opt_(nNumberOfBytesToWrite) LPCVOID lpBuffer,
     DWORD nNumberOfBytesToWrite,
     LPOVERLAPPED lpOverlapped,
     LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
    );

    
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then


BOOL
__stdcall
WriteFileGather(
     HANDLE hFile,
     FILE_SEGMENT_ELEMENT aSegmentArray[],
     DWORD nNumberOfBytesToWrite,
     LPDWORD lpReserved,
     LPOVERLAPPED lpOverlapped
    );


end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */
--]=]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
DWORD
__stdcall
GetTempPathW(
     DWORD nBufferLength,
     LPWSTR lpBuffer
    );
]]

--[[
#ifdef UNICODE
#define GetTempPath  GetTempPathW
#endif
--]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
GetVolumeNameForVolumeMountPointW(
     LPCWSTR lpszVolumeMountPoint,
     LPWSTR lpszVolumeName,
     DWORD cchBufferLength
    );
]]

--[[
#ifdef UNICODE
#define GetVolumeNameForVolumeMountPoint  GetVolumeNameForVolumeMountPointW
#endif
--]]

--#if (_WIN32_WINNT >= 0x0501)

ffi.cdef[[
BOOL
__stdcall
GetVolumePathNamesForVolumeNameW(
     LPCWSTR lpszVolumeName,
       LPWCH lpszVolumePathNames,
     DWORD cchBufferLength,
     PDWORD lpcchReturnLength
    );
]]
--[[
#ifdef UNICODE
#define GetVolumePathNamesForVolumeName  GetVolumePathNamesForVolumeNameW
#endif
--]]

--#endif // _WIN32_WINNT >= 0x0501

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP, WINAPI_PARTITION_SYSTEM) then

--#if (_WIN32_WINNT >= 0x0602)
ffi.cdef[[
typedef struct _CREATEFILE2_EXTENDED_PARAMETERS {
    DWORD dwSize;   
    DWORD dwFileAttributes;
    DWORD dwFileFlags;   
    DWORD dwSecurityQosFlags;	
    LPSECURITY_ATTRIBUTES lpSecurityAttributes; 
    HANDLE hTemplateFile;      
} CREATEFILE2_EXTENDED_PARAMETERS, *PCREATEFILE2_EXTENDED_PARAMETERS, *LPCREATEFILE2_EXTENDED_PARAMETERS;


HANDLE
__stdcall
CreateFile2(
     LPCWSTR lpFileName,
     DWORD dwDesiredAccess,
     DWORD dwShareMode,
     DWORD dwCreationDisposition,
     LPCREATEFILE2_EXTENDED_PARAMETERS pCreateExParams
    );
]]

--#endif // _WIN32_WINNT >= 0x0602

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

--#if (_WIN32_WINNT >= 0x0600)

ffi.cdef[[
BOOL
__stdcall
SetFileIoOverlappedRange(
     HANDLE FileHandle,
     PUCHAR OverlappedRangeStart,
     ULONG Length
    );
]]

--#endif // _WIN32_WINNT >= 0x0600

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

--#if _WIN32_WINNT >= 0x0501

ffi.cdef[[
DWORD
__stdcall
GetCompressedFileSizeA(
     LPCSTR lpFileName,
     LPDWORD lpFileSizeHigh
    );


DWORD
__stdcall
GetCompressedFileSizeW(
     LPCWSTR lpFileName,
     LPDWORD lpFileSizeHigh
    );
]]

--[[
#ifdef UNICODE
#define GetCompressedFileSize  GetCompressedFileSizeW
#else
#define GetCompressedFileSize  GetCompressedFileSizeA
#endif // !UNICODE
--]]
--#endif // _WIN32_WINNT >= 0x0501

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

--#if (_WIN32_WINNT >= 0x0501)
ffi.cdef[[
typedef enum _STREAM_INFO_LEVELS {

    FindStreamInfoStandard,
    FindStreamInfoMaxInfoLevel

} STREAM_INFO_LEVELS;

typedef struct _WIN32_FIND_STREAM_DATA {

    LARGE_INTEGER StreamSize;
    WCHAR cStreamName[ MAX_PATH + 36 ];

} WIN32_FIND_STREAM_DATA, *PWIN32_FIND_STREAM_DATA;
]]

ffi.cdef[[
HANDLE
__stdcall
FindFirstStreamW(
     LPCWSTR lpFileName,
     STREAM_INFO_LEVELS InfoLevel,
     LPVOID lpFindStreamData,
     DWORD dwFlags
    );



BOOL
__stdcall
FindNextStreamW(
     HANDLE hFindStream,
     LPVOID lpFindStreamData
    );
]]

--#endif // (_WIN32_WINNT >= 0x0501)

ffi.cdef[[
BOOL
__stdcall
AreFileApisANSI(
    VOID
    );
]]

end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
DWORD
__stdcall
GetTempPathA(
     DWORD nBufferLength,
     LPSTR lpBuffer
    );
]]

--[[
#ifndef UNICODE
#define GetTempPath  GetTempPathA
#endif
--]]
end  -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */
--]=]


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

--#if _WIN32_WINNT >= 0x0600

ffi.cdef[[
HANDLE
__stdcall
FindFirstFileNameW(
     LPCWSTR lpFileName,
     DWORD dwFlags,
     LPDWORD StringLength,
     PWSTR LinkName
    );



BOOL
__stdcall
FindNextFileNameW(
     HANDLE hFindStream,
     LPDWORD StringLength,
     PWSTR LinkName
    );
]]

--#endif // (_WIN32_WINNT >= 0x0600)

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
BOOL
__stdcall
GetVolumeInformationA(
     LPCSTR lpRootPathName,
     LPSTR lpVolumeNameBuffer,
     DWORD nVolumeNameSize,
     LPDWORD lpVolumeSerialNumber,
     LPDWORD lpMaximumComponentLength,
     LPDWORD lpFileSystemFlags,
     LPSTR lpFileSystemNameBuffer,
     DWORD nFileSystemNameSize
    );
]]

--[[
#ifndef UNICODE
#define GetVolumeInformation  GetVolumeInformationA
#endif
--]]

ffi.cdef[[
UINT
__stdcall
GetTempFileNameA(
     LPCSTR lpPathName,
     LPCSTR lpPrefixString,
     UINT uUnique,
     LPSTR lpTempFileName
    );
]]

--[[
#ifndef UNICODE
#define GetTempFileName  GetTempFileNameA
#endif
--]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP | WINAPI_PARTITION_SYSTEM) */



if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP , WINAPI_PARTITION_SYSTEM) then

ffi.cdef[[
VOID
__stdcall
SetFileApisToOEM(
    VOID
    );



VOID
__stdcall
SetFileApisToANSI(
    VOID
    );
]]

end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM) */


end --// _APISETFILE_
