--[[
 ioapiset.h -- ApiSet Contract for api-ms-win-core-io-l1
--]]



require("minwindef")
require("minwinbase")


ffi.cdef[[

_Ret_maybenull_
HANDLE
__stdcall
CreateIoCompletionPort(
    HANDLE FileHandle,
    HANDLE ExistingCompletionPort,
    ULONG_PTR CompletionKey,
    DWORD NumberOfConcurrentThreads
    );



BOOL
__stdcall
GetQueuedCompletionStatus(
    HANDLE CompletionPort,
    LPDWORD lpNumberOfBytesTransferred,
    PULONG_PTR lpCompletionKey,
    LPOVERLAPPED* lpOverlapped,
    DWORD dwMilliseconds
    );


BOOL
__stdcall
GetQueuedCompletionStatusEx(
    HANDLE CompletionPort,
     LPOVERLAPPED_ENTRY lpCompletionPortEntries,
    ULONG ulCount,
    PULONG ulNumEntriesRemoved,
    DWORD dwMilliseconds,
    BOOL fAlertable
    );


BOOL
__stdcall
PostQueuedCompletionStatus(
    HANDLE CompletionPort,
    DWORD dwNumberOfBytesTransferred,
    ULONG_PTR dwCompletionKey,
    LPOVERLAPPED lpOverlapped
    );


BOOL
__stdcall
DeviceIoControl(
    HANDLE hDevice,
    DWORD dwIoControlCode,
     LPVOID lpInBuffer,
    DWORD nInBufferSize,
     LPVOID lpOutBuffer,
    DWORD nOutBufferSize,
    LPDWORD lpBytesReturned,
     LPOVERLAPPED lpOverlapped
    );


BOOL
__stdcall
GetOverlappedResult(
    HANDLE hFile,
    LPOVERLAPPED lpOverlapped,
    LPDWORD lpNumberOfBytesTransferred,
    BOOL bWait
    );


BOOL
__stdcall
CancelIoEx(
    HANDLE hFile,
    LPOVERLAPPED lpOverlapped
    );


BOOL
__stdcall
CancelIo(
    HANDLE hFile
    );


BOOL
__stdcall
GetOverlappedResultEx(
    HANDLE hFile,
    LPOVERLAPPED lpOverlapped,
    LPDWORD lpNumberOfBytesTransferred,
    DWORD dwMilliseconds,
    BOOL bAlertable
    );


BOOL
__stdcall
CancelSynchronousIo(
    HANDLE hThread
    );

]]
