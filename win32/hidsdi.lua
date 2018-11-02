

local ffi = require("ffi")

--#include <pshpack4.h>
ffi.cdef[[
typedef  LONG NTSTATUS;
]]

require("win32.hidusage")
require("win32.hidpi")

ffi.cdef([[
typedef struct _HIDD_CONFIGURATION {
    PVOID    cookie;
    ULONG    size;
    ULONG    RingBufferSize;
} HIDD_CONFIGURATION, *PHIDD_CONFIGURATION;

typedef struct _HIDD_ATTRIBUTES {
    ULONG   Size; // = sizeof (struct _HIDD_ATTRIBUTES)

    //
    // Vendor ids of this hid device
    //
    USHORT  VendorID;
    USHORT  ProductID;
    USHORT  VersionNumber;

    //
    // Additional fields will be added to the end of this structure.
    //
} HIDD_ATTRIBUTES, *PHIDD_ATTRIBUTES;
]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

ffi.cdef[[
BOOLEAN __stdcall
HidD_GetAttributes (
     HANDLE              HidDeviceObject,
     PHIDD_ATTRIBUTES    Attributes
    );

void __stdcall
HidD_GetHidGuid (
     LPGUID   HidGuid
   );

BOOLEAN __stdcall
HidD_GetPreparsedData (
     HANDLE                  HidDeviceObject,
    PHIDP_PREPARSED_DATA  * PreparsedData
   );

BOOLEAN __stdcall
HidD_FreePreparsedData (
   PHIDP_PREPARSED_DATA PreparsedData
   );

BOOLEAN __stdcall
HidD_FlushQueue (
      HANDLE                HidDeviceObject
   );

BOOLEAN __stdcall
HidD_GetConfiguration (
     HANDLE               HidDeviceObject,
    PHIDD_CONFIGURATION Configuration,
     ULONG                ConfigurationLength
   );

BOOLEAN __stdcall
HidD_SetConfiguration (
     HANDLE               HidDeviceObject,
    PHIDD_CONFIGURATION Configuration,
     ULONG                ConfigurationLength
   );

BOOLEAN __stdcall
HidD_GetFeature (
      HANDLE   HidDeviceObject,
    PVOID ReportBuffer,
      ULONG    ReportBufferLength
   );

BOOLEAN __stdcall
HidD_SetFeature (
      HANDLE   HidDeviceObject,
    PVOID ReportBuffer,
      ULONG    ReportBufferLength
   );

BOOLEAN __stdcall
HidD_GetInputReport (
      HANDLE   HidDeviceObject,
    PVOID ReportBuffer,
      ULONG    ReportBufferLength
   );

BOOLEAN __stdcall
HidD_SetOutputReport (
      HANDLE   HidDeviceObject,
    PVOID ReportBuffer,
      ULONG    ReportBufferLength
   );

BOOLEAN __stdcall
HidD_GetNumInputBuffers (
     HANDLE  HidDeviceObject,
     PULONG  NumberBuffers
    );

BOOLEAN __stdcall
HidD_SetNumInputBuffers (
    HANDLE HidDeviceObject,
    ULONG  NumberBuffers
    );

BOOLEAN __stdcall
HidD_GetPhysicalDescriptor (
      HANDLE   HidDeviceObject,
    PVOID Buffer,
      ULONG    BufferLength
   );

BOOLEAN __stdcall
HidD_GetManufacturerString (
      HANDLE   HidDeviceObject,
   PVOID Buffer,
      ULONG    BufferLength
   );

BOOLEAN __stdcall
HidD_GetProductString (
      HANDLE   HidDeviceObject,
   PVOID Buffer,
      ULONG    BufferLength
   );

BOOLEAN __stdcall
HidD_GetIndexedString (
      HANDLE   HidDeviceObject,
      ULONG    StringIndex,
    PVOID Buffer,
      ULONG    BufferLength
   );

BOOLEAN __stdcall
HidD_GetSerialNumberString (
      HANDLE   HidDeviceObject,
    PVOID Buffer,
      ULONG    BufferLength
   );

BOOLEAN __stdcall
HidD_GetMsGenreDescriptor (
      HANDLE   HidDeviceObject,
   PVOID Buffer,
      ULONG    BufferLength
   );
]]

