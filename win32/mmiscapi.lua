--[[
/********************************************************************************
*                                                                               *
* mmiscapi.h -- ApiSet Contract for api-ms-win-mm-misc-l1-1                     *  
*                                                                               *
* Copyright (c) Microsoft Corporation. All rights reserved.                     *
*                                                                               *
********************************************************************************/
--]]

local ffi = require("ffi")


--#ifndef _MMISCAPI_H_
--#define _MMISCAPI_H_

--#include <apiset.h>
--#include <apisetcconv.h>


require ("win32.mmsyscom") --// mm common definitions




if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

if not MMNODRV then

--        Installable driver support

#ifdef _WIN32 then
typedef struct DRVCONFIGINFOEX {
    DWORD   dwDCISize;
    LPCWSTR  lpszDCISectionName;
    LPCWSTR  lpszDCIAliasName;
    DWORD    dnDevNode;
} DRVCONFIGINFOEX, *PDRVCONFIGINFOEX,  *NPDRVCONFIGINFOEX,  *LPDRVCONFIGINFOEX;

#else
typedef struct DRVCONFIGINFOEX {
    DWORD   dwDCISize;
    LPCSTR  lpszDCISectionName;
    LPCSTR  lpszDCIAliasName;
    DWORD    dnDevNode;
} DRVCONFIGINFOEX, *PDRVCONFIGINFOEX,  *NPDRVCONFIGINFOEX,  *LPDRVCONFIGINFOEX;
#endif

if (WINVER < 0x030a) or _WIN32 then

if not DRV_LOAD then
DRV_LOAD = true 

ffi.cdef[[
/* Driver messages */
static const int DRV_LOAD              =  0x0001;
static const int DRV_ENABLE            =  0x0002;
static const int DRV_OPEN              =  0x0003;
static const int DRV_CLOSE             =  0x0004;
static const int DRV_DISABLE           =  0x0005;
static const int DRV_FREE              =  0x0006;
static const int DRV_CONFIGURE         =  0x0007;
static const int DRV_QUERYCONFIGURE    =  0x0008;
static const int DRV_INSTALL           =  0x0009;
static const int DRV_REMOVE            =  0x000A;
static const int DRV_EXITSESSION       =  0x000B;
static const int DRV_POWER             =  0x000F;
static const int DRV_RESERVED          =  0x0800;
static const int DRV_USER              =  0x4000;
]]

--/* LPARAM of DRV_CONFIGURE message */
if _WIN32 then
ffi.cdef[[
typedef struct tagDRVCONFIGINFO {
    DWORD   dwDCISize;
    LPCWSTR  lpszDCISectionName;
    LPCWSTR  lpszDCIAliasName;
} DRVCONFIGINFO, *PDRVCONFIGINFO,  *NPDRVCONFIGINFO,  *LPDRVCONFIGINFO;
]]
else
ffi.cdef[[
typedef struct tagDRVCONFIGINFO {
    DWORD   dwDCISize;
    LPCSTR  lpszDCISectionName;
    LPCSTR  lpszDCIAliasName;
} DRVCONFIGINFO, *PDRVCONFIGINFO,  *NPDRVCONFIGINFO,  *LPDRVCONFIGINFO;
]]
end

ffi.cdef[[
/* Supported return values for DRV_CONFIGURE message */
static const int DRVCNF_CANCEL          = 0x0000;
static const int DRVCNF_OK              = 0x0001;
static const int DRVCNF_RESTART         = 0x0002;
]]

--/* installable driver function prototypes */
if _WIN32 then

ffi.cdef[[
typedef LRESULT (__stdcall* DRIVERPROC)(DWORD_PTR, HDRVR, UINT, LPARAM, LPARAM);
]]

ffi.cdef[[

LRESULT
__stdcall
CloseDriver(
     HDRVR hDriver,
     LPARAM lParam1,
     LPARAM lParam2
    );


HDRVR
__stdcall
OpenDriver(
     LPCWSTR szDriverName,
     LPCWSTR szSectionName,
     LPARAM lParam2
    );


LRESULT
__stdcall
SendDriverMessage(
     HDRVR hDriver,
     UINT message,
     LPARAM lParam1,
     LPARAM lParam2
    );


HMODULE
__stdcall
DrvGetModuleHandle(
     HDRVR hDriver
    );


HMODULE
__stdcall
GetDriverModuleHandle(
     HDRVR hDriver
    );


LRESULT
__stdcall
DefDriverProc(
     DWORD_PTR dwDriverIdentifier,
     HDRVR hdrvr,
     UINT uMsg,
     LPARAM lParam1,
     LPARAM lParam2
    );
]]
else
ffi.cdef[[
LRESULT   __stdcall DrvClose(HDRVR hdrvr, LPARAM lParam1, LPARAM lParam2);
HDRVR     __stdcall DrvOpen(LPCSTR szDriverName, LPCSTR szSectionName, LPARAM lParam2);
LRESULT   __stdcall DrvSendMessage(HDRVR hdrvr, UINT uMsg, LPARAM lParam1, LPARAM lParam2);
HINSTANCE __stdcall DrvGetModuleHandle(HDRVR hdrvr);
LRESULT   __stdcall DrvDefDriverProc(DWORD dwDriverIdentifier, HDRVR hdrvr, UINT uMsg, LPARAM lParam1, LPARAM lParam2);
]]

--#define DefDriverProc DrvDefDriverProc

end --/* ifdef _WIN32 */
end --/* DRV_LOAD */
end --/* ifdef (WINVER < 0x030a) || defined(_WIN32) */

if (WINVER >= 0x030a) then
ffi.cdef[[
/* return values from DriverProc() function */
static const int DRV_CANCEL           =  DRVCNF_CANCEL;
static const int DRV_OK               =  DRVCNF_OK;
static const int DRV_RESTART          =  DRVCNF_RESTART;
]]
end --/* ifdef WINVER >= 0x030a */

ffi.cdef[[
static const int DRV_MCI_FIRST        =  DRV_RESERVED;
static const int DRV_MCI_LAST         =  (DRV_RESERVED + 0xFFF);
]]


--                      Driver Helper function moved from mmddk.h

ffi.cdef[[
BOOL
__stdcall
DriverCallback(
    DWORD_PTR dwCallback,
    DWORD dwFlags,
    HDRVR hDevice,
    DWORD dwMsg,
    DWORD_PTR dwUser,
    DWORD_PTR dwParam1,
    DWORD_PTR dwParam2
    );
]]

ffi.cdef[[
/****************************************************************************

  Sound schemes

****************************************************************************/LONG
__stdcall
sndOpenSound(
     LPCWSTR EventName,
     LPCWSTR AppName,
     INT32 Flags,
     PHANDLE FileHandle
    );
]]

--[[
//
// removed from winmmi.h

//
/****************************************************************************

  API to install/remove/query a MMSYS driver

****************************************************************************/

/* generic prototype for audio device driver entry-point functions
// midMessage(), modMessage(), widMessage(), wodMessage(), auxMessage()
*/
--]]
ffi.cdef[[
typedef DWORD (__stdcall *DRIVERMSGPROC)(DWORD, DWORD, DWORD_PTR, DWORD_PTR, DWORD_PTR);

UINT
__stdcall
mmDrvInstall(
    HDRVR hDriver,
    LPCWSTR wszDrvEntry,
    DRIVERMSGPROC drvMessage,
    UINT wFlags
    );
]]

end  --/* ifndef MMNODRV */


if not MMNOMMIO then

--                        Multimedia File I/O support

/* MMIO error return values */
#define MMIOERR_BASE                256
#define MMIOERR_FILENOTFOUND        (MMIOERR_BASE + 1)  /* file not found */
#define MMIOERR_OUTOFMEMORY         (MMIOERR_BASE + 2)  /* out of memory */
#define MMIOERR_CANNOTOPEN          (MMIOERR_BASE + 3)  /* cannot open */
#define MMIOERR_CANNOTCLOSE         (MMIOERR_BASE + 4)  /* cannot close */
#define MMIOERR_CANNOTREAD          (MMIOERR_BASE + 5)  /* cannot read */
#define MMIOERR_CANNOTWRITE         (MMIOERR_BASE + 6)  /* cannot write */
#define MMIOERR_CANNOTSEEK          (MMIOERR_BASE + 7)  /* cannot seek */
#define MMIOERR_CANNOTEXPAND        (MMIOERR_BASE + 8)  /* cannot expand file */
#define MMIOERR_CHUNKNOTFOUND       (MMIOERR_BASE + 9)  /* chunk not found */
#define MMIOERR_UNBUFFERED          (MMIOERR_BASE + 10) /*  */
#define MMIOERR_PATHNOTFOUND        (MMIOERR_BASE + 11) /* path incorrect */
#define MMIOERR_ACCESSDENIED        (MMIOERR_BASE + 12) /* file was protected */
#define MMIOERR_SHARINGVIOLATION    (MMIOERR_BASE + 13) /* file in use */
#define MMIOERR_NETWORKERROR        (MMIOERR_BASE + 14) /* network not responding */
#define MMIOERR_TOOMANYOPENFILES    (MMIOERR_BASE + 15) /* no more file handles  */
#define MMIOERR_INVALIDFILE         (MMIOERR_BASE + 16) /* default error file error */

/* MMIO constants */
#define CFSEPCHAR       '+'             /* compound file name separator char. */

ffi.cdef[[
/* MMIO data types */
typedef DWORD           FOURCC;         /* a four character code */
typedef char _huge *    HPSTR;          /* a huge version of LPSTR */
]]

DECLARE_HANDLE("HMMIO");                  /* a handle to an open file */

ffi.cdef[[
typedef LRESULT (__stdcall MMIOPROC)(LPSTR lpmmioinfo, UINT uMsg,
            LPARAM lParam1, LPARAM lParam2);
typedef MMIOPROC  *LPMMIOPROC;
]]

ffi.cdef[[
/* general MMIO information data structure */
typedef struct _MMIOINFO
{
        /* general fields */
        DWORD           dwFlags;        /* general status flags */
        FOURCC          fccIOProc;      /* pointer to I/O procedure */
        LPMMIOPROC      pIOProc;        /* pointer to I/O procedure */
        UINT            wErrorRet;      /* place for error to be returned */
        HTASK           htask;          /* alternate local task */

        /* fields maintained by MMIO functions during buffered I/O */
        LONG            cchBuffer;      /* size of I/O buffer (or 0L) */
        HPSTR           pchBuffer;      /* start of I/O buffer (or NULL) */
        HPSTR           pchNext;        /* pointer to next byte to read/write */
        HPSTR           pchEndRead;     /* pointer to last valid byte to read */
        HPSTR           pchEndWrite;    /* pointer to last byte to write */
        LONG            lBufOffset;     /* disk offset of start of buffer */

        /* fields maintained by I/O procedure */
        LONG            lDiskOffset;    /* disk offset of next read or write */
        DWORD           adwInfo[3];     /* data specific to type of MMIOPROC */

        /* other fields maintained by MMIO */
        DWORD           dwReserved1;    /* reserved for MMIO use */
        DWORD           dwReserved2;    /* reserved for MMIO use */
        HMMIO           hmmio;          /* handle to open file */
} MMIOINFO, *PMMIOINFO,  *NPMMIOINFO,  *LPMMIOINFO;
typedef const MMIOINFO  *LPCMMIOINFO;
]]

ffi.cdef[[
/* RIFF chunk information data structure */
typedef struct _MMCKINFO
{
        FOURCC          ckid;           /* chunk ID */
        DWORD           cksize;         /* chunk size */
        FOURCC          fccType;        /* form type or list type */
        DWORD           dwDataOffset;   /* offset of data portion of chunk */
        DWORD           dwFlags;        /* flags used by MMIO functions */
} MMCKINFO, *PMMCKINFO,  *NPMMCKINFO,  *LPMMCKINFO;
typedef const MMCKINFO *LPCMMCKINFO;
]]

/* bit field masks */
#define MMIO_RWMODE     0x00000003      /* open file for reading/writing/both */
#define MMIO_SHAREMODE  0x00000070      /* file sharing mode number */

/* constants for dwFlags field of MMIOINFO */
#define MMIO_CREATE     0x00001000      /* create new file (or truncate file) */
#define MMIO_PARSE      0x00000100      /* parse new file returning path */
#define MMIO_DELETE     0x00000200      /* create new file (or truncate file) */
#define MMIO_EXIST      0x00004000      /* checks for existence of file */
#define MMIO_ALLOCBUF   0x00010000      /* mmioOpen() should allocate a buffer */
#define MMIO_GETTEMP    0x00020000      /* mmioOpen() should retrieve temp name */

#define MMIO_DIRTY      0x10000000      /* I/O buffer is dirty */

/* read/write mode numbers (bit field MMIO_RWMODE) */
#define MMIO_READ       0x00000000      /* open file for reading only */
#define MMIO_WRITE      0x00000001      /* open file for writing only */
#define MMIO_READWRITE  0x00000002      /* open file for reading and writing */

/* share mode numbers (bit field MMIO_SHAREMODE) */
#define MMIO_COMPAT     0x00000000      /* compatibility mode */
#define MMIO_EXCLUSIVE  0x00000010      /* exclusive-access mode */
#define MMIO_DENYWRITE  0x00000020      /* deny writing to other processes */
#define MMIO_DENYREAD   0x00000030      /* deny reading to other processes */
#define MMIO_DENYNONE   0x00000040      /* deny nothing to other processes */

/* various MMIO flags */
#define MMIO_FHOPEN             0x0010  /* mmioClose: keep file handle open */
#define MMIO_EMPTYBUF           0x0010  /* mmioFlush: empty the I/O buffer */
#define MMIO_TOUPPER            0x0010  /* mmioStringToFOURCC: to u-case */
#define MMIO_INSTALLPROC    0x00010000  /* mmioInstallIOProc: install MMIOProc */
#define MMIO_GLOBALPROC     0x10000000  /* mmioInstallIOProc: install globally */
#define MMIO_REMOVEPROC     0x00020000  /* mmioInstallIOProc: remove MMIOProc */
#define MMIO_UNICODEPROC    0x01000000  /* mmioInstallIOProc: Unicode MMIOProc */
#define MMIO_FINDPROC       0x00040000  /* mmioInstallIOProc: find an MMIOProc */
#define MMIO_FINDCHUNK          0x0010  /* mmioDescend: find a chunk by ID */
#define MMIO_FINDRIFF           0x0020  /* mmioDescend: find a LIST chunk */
#define MMIO_FINDLIST           0x0040  /* mmioDescend: find a RIFF chunk */
#define MMIO_CREATERIFF         0x0020  /* mmioCreateChunk: make a LIST chunk */
#define MMIO_CREATELIST         0x0040  /* mmioCreateChunk: make a RIFF chunk */



/* message numbers for MMIOPROC I/O procedure functions */
#define MMIOM_READ      MMIO_READ       /* read */
#define MMIOM_WRITE    MMIO_WRITE       /* write */
#define MMIOM_SEEK              2       /* seek to a new position in file */
#define MMIOM_OPEN              3       /* open file */
#define MMIOM_CLOSE             4       /* close file */
#define MMIOM_WRITEFLUSH        5       /* write and flush */

#if (WINVER >= 0x030a)
#define MMIOM_RENAME            6       /* rename specified file */
#endif /* ifdef WINVER >= 0x030a */

#define MMIOM_USER         0x8000       /* beginning of user-defined messages */

/* standard four character codes */
#define FOURCC_RIFF     mmioFOURCC('R', 'I', 'F', 'F')
#define FOURCC_LIST     mmioFOURCC('L', 'I', 'S', 'T')

/* four character codes used to identify standard built-in I/O procedures */
#define FOURCC_DOS      mmioFOURCC('D', 'O', 'S', ' ')
#define FOURCC_MEM      mmioFOURCC('M', 'E', 'M', ' ')

/* flags for mmioSeek() */
#ifndef SEEK_SET
#define SEEK_SET        0               /* seek to an absolute position */
#define SEEK_CUR        1               /* seek relative to current position */
#define SEEK_END        2               /* seek relative to end of file */
#endif  /* ifndef SEEK_SET */

/* other constants */
#define MMIO_DEFAULTBUFFER      8192    /* default buffer size */

/* MMIO macros */
#define mmioFOURCC(ch0, ch1, ch2, ch3)  MAKEFOURCC(ch0, ch1, ch2, ch3)

--/* MMIO function prototypes */
if _WIN32 then

ffi.cdef[[
FOURCC
__stdcall
mmioStringToFOURCCA(
    LPCSTR sz,
     UINT uFlags
    );


FOURCC
__stdcall
mmioStringToFOURCCW(
    LPCWSTR sz,
     UINT uFlags
    );
]]

if UNICODE then
--#define mmioStringToFOURCC  mmioStringToFOURCCW
else
--#define mmioStringToFOURCC  mmioStringToFOURCCA
end --// !UNICODE

ffi.cdef[[
LPMMIOPROC
__stdcall
mmioInstallIOProcA(
     FOURCC fccIOProc,
     LPMMIOPROC pIOProc,
     DWORD dwFlags
    );


LPMMIOPROC
__stdcall
mmioInstallIOProcW(
     FOURCC fccIOProc,
     LPMMIOPROC pIOProc,
     DWORD dwFlags
    );
]]

if UNICODE then
--#define mmioInstallIOProc  mmioInstallIOProcW
else
--#define mmioInstallIOProc  mmioInstallIOProcA
end --// !UNICODE

ffi.cdef[[
HMMIO
__stdcall
mmioOpenA(
     LPSTR pszFileName,
     LPMMIOINFO pmmioinfo,
     DWORD fdwOpen
    );


HMMIO
__stdcall
mmioOpenW(
     LPWSTR pszFileName,
     LPMMIOINFO pmmioinfo,
     DWORD fdwOpen
    );
]]

if UNICODE then
--#define mmioOpen  mmioOpenW
else
--#define mmioOpen  mmioOpenA
end --// !UNICODE

ffi.cdef[[
MMRESULT
__stdcall
mmioRenameA(
     LPCSTR pszFileName,
     LPCSTR pszNewFileName,
     LPCMMIOINFO pmmioinfo,
     DWORD fdwRename
    );


MMRESULT
__stdcall
mmioRenameW(
     LPCWSTR pszFileName,
     LPCWSTR pszNewFileName,
     LPCMMIOINFO pmmioinfo,
     DWORD fdwRename
    );
]]

if UNICODE then
--#define mmioRename  mmioRenameW
else
--#define mmioRename  mmioRenameA
end --// !UNICODE

else
ffi.cdef[[
FOURCC __stdcall mmioStringToFOURCC( LPCSTR sz, UINT uFlags);
LPMMIOPROC __stdcall mmioInstallIOProc( FOURCC fccIOProc, LPMMIOPROC pIOProc, DWORD dwFlags);
HMMIO __stdcall mmioOpen( LPSTR pszFileName, LPMMIOINFO pmmioinfo, DWORD fdwOpen);
]]

if (WINVER >= 0x030a) then
ffi.cdef[[
MMRESULT __stdcall mmioRename(  LPCSTR pszFileName,  LPCSTR pszNewFileName,  const MMIOINFO * pmmioinfo,  DWORD fdwRename);
]]
end --/* ifdef WINVER >= 0x030a */
end

ffi.cdef[[
MMRESULT
__stdcall
mmioClose(
     HMMIO hmmio,
     UINT fuClose
    );


LONG
__stdcall
mmioRead(
     HMMIO hmmio,
     HPSTR pch,
     LONG cch
    );


LONG
__stdcall
mmioWrite(
     HMMIO hmmio,
     const char  * pch,
     LONG cch
    );


LONG
__stdcall
mmioSeek(
     HMMIO hmmio,
     LONG lOffset,
     int iOrigin
    );


MMRESULT
__stdcall
mmioGetInfo(
     HMMIO hmmio,
     LPMMIOINFO pmmioinfo,
     UINT fuInfo
    );


MMRESULT
__stdcall
mmioSetInfo(
     HMMIO hmmio,
     LPCMMIOINFO pmmioinfo,
     UINT fuInfo
    );


MMRESULT
__stdcall
mmioSetBuffer(
     HMMIO hmmio,
     LPSTR pchBuffer,
     LONG cchBuffer,
     UINT fuBuffer
    );


MMRESULT
__stdcall
mmioFlush(
     HMMIO hmmio,
     UINT fuFlush
    );


MMRESULT
__stdcall
mmioAdvance(
     HMMIO hmmio,
     LPMMIOINFO pmmioinfo,
     UINT fuAdvance
    );


LRESULT
__stdcall
mmioSendMessage(
     HMMIO hmmio,
     UINT uMsg,
     LPARAM lParam1,
     LPARAM lParam2
    );


MMRESULT
__stdcall
mmioDescend(
     HMMIO hmmio,
     LPMMCKINFO pmmcki,
     const MMCKINFO   * pmmckiParent,
     UINT fuDescend
    );


MMRESULT
__stdcall
mmioAscend(
     HMMIO hmmio,
     LPMMCKINFO pmmcki,
     UINT fuAscend
    );


MMRESULT
__stdcall
mmioCreateChunk(
     HMMIO hmmio,
     LPMMCKINFO pmmcki,
     UINT fuCreate
    );
]]

end  --/* ifndef MMNOMMIO */

end -- WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)




--#endif // _MMISCAPI_H_


