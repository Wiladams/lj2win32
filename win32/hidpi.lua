-- public interface to HID parsing library
local ffi = require("ffi")

-- put the following at the end of each cdef to get packing
--[=[

]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

--]=]


--#include <pshpack4.h>

-- Please include "hidsdi.h" to use the user space (dll / parser)
-- Please include "hidpddi.h" to use the kernel space parser

ffi.cdef[[
static const int HIDP_LINK_COLLECTION_ROOT = ((USHORT) -1);
static const int HIDP_LINK_COLLECTION_UNSPECIFIED = ((USHORT) 0);
]]

ffi.cdef[[
typedef enum _HIDP_REPORT_TYPE
{
    HidP_Input,
    HidP_Output,
    HidP_Feature
} HIDP_REPORT_TYPE;
]]

ffi.cdef([[
typedef struct _USAGE_AND_PAGE
{
    USAGE Usage;
    USAGE UsagePage;
} USAGE_AND_PAGE, *PUSAGE_AND_PAGE;
__attribute__((__packed__));]])
--..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

ffi.cdef([[
typedef struct _HIDP_BUTTON_CAPS
{
    USAGE    UsagePage;
    UCHAR    ReportID;
    BOOLEAN  IsAlias;

    USHORT   BitField;
    USHORT   LinkCollection;   // A unique internal index pointer

    USAGE    LinkUsage;
    USAGE    LinkUsagePage;

    BOOLEAN  IsRange;
    BOOLEAN  IsStringRange;
    BOOLEAN  IsDesignatorRange;
    BOOLEAN  IsAbsolute;

    ULONG    Reserved[10];
    union {
        struct {
            USAGE    UsageMin,         UsageMax;
            USHORT   StringMin,        StringMax;
            USHORT   DesignatorMin,    DesignatorMax;
            USHORT   DataIndexMin,     DataIndexMax;
        } Range;
        struct  {
            USAGE    Usage,            Reserved1;
            USHORT   StringIndex,      Reserved2;
            USHORT   DesignatorIndex,  Reserved3;
            USHORT   DataIndex,        Reserved4;
        } NotRange;
    };

} HIDP_BUTTON_CAPS, *PHIDP_BUTTON_CAPS;
]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

ffi.cdef([[
typedef struct _HIDP_VALUE_CAPS
{
    USAGE    UsagePage;
    UCHAR    ReportID;
    BOOLEAN  IsAlias;

    USHORT   BitField;
    USHORT   LinkCollection;   // A unique internal index pointer

    USAGE    LinkUsage;
    USAGE    LinkUsagePage;

    BOOLEAN  IsRange;
    BOOLEAN  IsStringRange;
    BOOLEAN  IsDesignatorRange;
    BOOLEAN  IsAbsolute;

    BOOLEAN  HasNull;        // Does this channel have a null report   union
    UCHAR    Reserved;
    USHORT   BitSize;        // How many bits are devoted to this value?

    USHORT   ReportCount;    // See Note below.  Usually set to 1.
    USHORT   Reserved2[5];

    ULONG    UnitsExp;
    ULONG    Units;

    LONG     LogicalMin,       LogicalMax;
    LONG     PhysicalMin,      PhysicalMax;

    union {
        struct {
            USAGE    UsageMin,         UsageMax;
            USHORT   StringMin,        StringMax;
            USHORT   DesignatorMin,    DesignatorMax;
            USHORT   DataIndexMin,     DataIndexMax;
        } Range;

        struct {
            USAGE    Usage,            Reserved1;
            USHORT   StringIndex,      Reserved2;
            USHORT   DesignatorIndex,  Reserved3;
            USHORT   DataIndex,        Reserved4;
        } NotRange;
    };
} HIDP_VALUE_CAPS, *PHIDP_VALUE_CAPS;
]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

ffi.cdef([[
typedef struct _HIDP_LINK_COLLECTION_NODE
{
    USAGE    LinkUsage;
    USAGE    LinkUsagePage;
    USHORT   Parent;
    USHORT   NumberOfChildren;
    USHORT   NextSibling;
    USHORT   FirstChild;
    ULONG    CollectionType: 8;  // As defined in 6.2.2.6 of HID spec
    ULONG    IsAlias : 1; // This link node is an allias of the next link node.
    ULONG    Reserved: 23;
    PVOID    UserContext; // The user can hang his coat here.
} HIDP_LINK_COLLECTION_NODE, *PHIDP_LINK_COLLECTION_NODE;
]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

ffi.cdef[[
typedef PUCHAR  PHIDP_REPORT_DESCRIPTOR;
typedef struct _HIDP_PREPARSED_DATA * PHIDP_PREPARSED_DATA;
]]

ffi.cdef([[
typedef struct _HIDP_CAPS
{
    USAGE    Usage;
    USAGE    UsagePage;
    USHORT   InputReportByteLength;
    USHORT   OutputReportByteLength;
    USHORT   FeatureReportByteLength;
    USHORT   Reserved[17];

    USHORT   NumberLinkCollectionNodes;

    USHORT   NumberInputButtonCaps;
    USHORT   NumberInputValueCaps;
    USHORT   NumberInputDataIndices;

    USHORT   NumberOutputButtonCaps;
    USHORT   NumberOutputValueCaps;
    USHORT   NumberOutputDataIndices;

    USHORT   NumberFeatureButtonCaps;
    USHORT   NumberFeatureValueCaps;
    USHORT   NumberFeatureDataIndices;
} HIDP_CAPS, *PHIDP_CAPS;
]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

ffi.cdef([[
typedef struct _HIDP_DATA
{
    USHORT  DataIndex;
    USHORT  Reserved;
    union {
        ULONG   RawValue; // for values
        BOOLEAN On; // for buttons MUST BE TRUE for buttons.
    };
} HIDP_DATA, *PHIDP_DATA;
]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

ffi.cdef([[
typedef struct _HIDP_UNKNOWN_TOKEN
{
    UCHAR  Token;
    UCHAR  Reserved[3];
    ULONG  BitField;
} HIDP_UNKNOWN_TOKEN, *PHIDP_UNKNOWN_TOKEN;
]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

ffi.cdef([[
typedef struct _HIDP_EXTENDED_ATTRIBUTES
{
    UCHAR   NumGlobalUnknowns;
    UCHAR   Reserved [3];
    PHIDP_UNKNOWN_TOKEN  GlobalUnknowns;
    // ... Additional attributes
    ULONG   Data [1]; // variableLength  DO NOT ACCESS THIS FIELD
} HIDP_EXTENDED_ATTRIBUTES, *PHIDP_EXTENDED_ATTRIBUTES;
]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))

ffi.cdef[[
NTSTATUS __stdcall
HidP_GetCaps (
        PHIDP_PREPARSED_DATA      PreparsedData,
       PHIDP_CAPS                Capabilities
   );




NTSTATUS __stdcall
HidP_GetLinkCollectionNodes (
   PHIDP_LINK_COLLECTION_NODE LinkCollectionNodes,
     PULONG                     LinkCollectionNodesLength,
        PHIDP_PREPARSED_DATA       PreparsedData
   );




NTSTATUS __stdcall
HidP_GetSpecificButtonCaps (
         HIDP_REPORT_TYPE     ReportType,
     USAGE                UsagePage,      // Optional (0 => ignore)
     USHORT               LinkCollection, // Optional (0 => ignore)
     USAGE                Usage,          // Optional (0 => ignore)
   PHIDP_BUTTON_CAPS ButtonCaps,
      PUSHORT              ButtonCapsLength,
         PHIDP_PREPARSED_DATA PreparsedData
   );



NTSTATUS __stdcall
HidP_GetButtonCaps (
         HIDP_REPORT_TYPE     ReportType,
   PHIDP_BUTTON_CAPS ButtonCaps,
      PUSHORT              ButtonCapsLength,
         PHIDP_PREPARSED_DATA PreparsedData
);



NTSTATUS __stdcall
HidP_GetSpecificValueCaps (
         HIDP_REPORT_TYPE     ReportType,
     USAGE                UsagePage,      // Optional (0 => ignore)
     USHORT               LinkCollection, // Optional (0 => ignore)
     USAGE                Usage,          // Optional (0 => ignore)
   PHIDP_VALUE_CAPS     ValueCaps,
      PUSHORT              ValueCapsLength,
         PHIDP_PREPARSED_DATA PreparsedData
   );




NTSTATUS __stdcall
HidP_GetValueCaps (
         HIDP_REPORT_TYPE     ReportType,
   PHIDP_VALUE_CAPS ValueCaps,
      PUSHORT              ValueCapsLength,
         PHIDP_PREPARSED_DATA PreparsedData
);

NTSTATUS __stdcall
HidP_GetExtendedAttributes (
         HIDP_REPORT_TYPE            ReportType,
         USHORT                      DataIndex,
         PHIDP_PREPARSED_DATA        PreparsedData,
    PHIDP_EXTENDED_ATTRIBUTES Attributes,
      PULONG                      LengthAttributes
    );

NTSTATUS __stdcall
HidP_InitializeReportForID (
   HIDP_REPORT_TYPE ReportType,
   UCHAR ReportID,
   PHIDP_PREPARSED_DATA PreparsedData,
   PCHAR Report,
   ULONG ReportLength
   );

NTSTATUS __stdcall
HidP_SetData (
    HIDP_REPORT_TYPE ReportType,
    PHIDP_DATA DataList,
    PULONG DataLength,
    PHIDP_PREPARSED_DATA PreparsedData,
    PCHAR Report,
    ULONG ReportLength
    );

NTSTATUS __stdcall
HidP_GetData (
    HIDP_REPORT_TYPE ReportType,
    PHIDP_DATA DataList,
    PULONG DataLength,
    PHIDP_PREPARSED_DATA PreparsedData,
    PCHAR Report,
    ULONG ReportLength
    );



ULONG __stdcall
HidP_MaxDataListLength (
   HIDP_REPORT_TYPE      ReportType,
   PHIDP_PREPARSED_DATA  PreparsedData
   );




NTSTATUS __stdcall
HidP_SetUsages (
   HIDP_REPORT_TYPE    ReportType,
   USAGE   UsagePage,
   USHORT  LinkCollection,
   PUSAGE  UsageList,
    PULONG  UsageLength,
   PHIDP_PREPARSED_DATA  PreparsedData,
   PCHAR   Report,
   ULONG   ReportLength 
   );



NTSTATUS __stdcall
HidP_UnsetUsages (
   HIDP_REPORT_TYPE      ReportType,
   USAGE   UsagePage,
   USHORT  LinkCollection,
   PUSAGE  UsageList,
    PULONG  UsageLength,
   PHIDP_PREPARSED_DATA  PreparsedData,
   PCHAR   Report,
   ULONG   ReportLength
   );

NTSTATUS __stdcall
HidP_GetUsages (
   HIDP_REPORT_TYPE    ReportType,
   USAGE   UsagePage,
   USHORT  LinkCollection,
   PUSAGE UsageList,
      PULONG UsageLength,
   PHIDP_PREPARSED_DATA PreparsedData,
   PCHAR Report,
   ULONG   ReportLength
   );

NTSTATUS __stdcall
HidP_GetUsagesEx (
       HIDP_REPORT_TYPE    ReportType,
     USHORT  LinkCollection, // Optional
    PUSAGE_AND_PAGE  ButtonList,
      ULONG * UsageLength,
    PHIDP_PREPARSED_DATA PreparsedData,
    PCHAR   Report,
    ULONG  ReportLength
   );
 
ULONG __stdcall
HidP_MaxUsageListLength (
   HIDP_REPORT_TYPE      ReportType,
   USAGE                 UsagePage, // Optional
   PHIDP_PREPARSED_DATA  PreparsedData
   );

NTSTATUS __stdcall
HidP_SetUsageValue (
    HIDP_REPORT_TYPE ReportType,
    USAGE UsagePage,
    USHORT LinkCollection,
    USAGE Usage,
    ULONG UsageValue,
    PHIDP_PREPARSED_DATA PreparsedData,
    PCHAR Report,
    ULONG ReportLength
    );

NTSTATUS __stdcall
HidP_SetScaledUsageValue (
    HIDP_REPORT_TYPE ReportType,
    USAGE UsagePage,
    USHORT LinkCollection,
    USAGE Usage,
    LONG UsageValue,
    PHIDP_PREPARSED_DATA PreparsedData,
     PCHAR Report,
    ULONG ReportLength
    );

NTSTATUS __stdcall
HidP_SetUsageValueArray (
    HIDP_REPORT_TYPE ReportType,
    USAGE UsagePage,
    USHORT LinkCollection,
    USAGE Usage,
    PCHAR UsageValue,
    USHORT UsageValueByteLength,
    PHIDP_PREPARSED_DATA PreparsedData,
    (ReportLength) PCHAR Report,
    ULONG ReportLength
    );

NTSTATUS __stdcall
HidP_GetUsageValue (
    HIDP_REPORT_TYPE ReportType,
    USAGE UsagePage,
    USHORT LinkCollection,
    USAGE Usage,
    PULONG UsageValue,
    PHIDP_PREPARSED_DATA PreparsedData,
    PCHAR Report,
    ULONG ReportLength
    );

NTSTATUS __stdcall
HidP_GetScaledUsageValue (
    HIDP_REPORT_TYPE ReportType,
    USAGE UsagePage,
    USHORT LinkCollection,
    USAGE Usage,
    PLONG UsageValue,
    PHIDP_PREPARSED_DATA PreparsedData,
    PCHAR Report,
    ULONG ReportLength
    );

NTSTATUS __stdcall
HidP_GetUsageValueArray (
    HIDP_REPORT_TYPE ReportType,
    USAGE UsagePage,
    USHORT LinkCollection,
    USAGE Usage,
    PCHAR UsageValue,
    USHORT UsageValueByteLength,
    PHIDP_PREPARSED_DATA PreparsedData,
    PCHAR Report,
    ULONG ReportLength
    );

NTSTATUS __stdcall
HidP_UsageListDifference (
   PUSAGE  PreviousUsageList,
   PUSAGE  CurrentUsageList,
   PUSAGE  BreakUsageList,
   PUSAGE  MakeUsageList,
   ULONG    UsageListLength
    );

NTSTATUS __stdcall
HidP_UsageAndPageListDifference (
    PUSAGE_AND_PAGE PreviousUsageList,
   PUSAGE_AND_PAGE CurrentUsageList,
   PUSAGE_AND_PAGE BreakUsageList,
   PUSAGE_AND_PAGE MakeUsageList,
   ULONG           UsageListLength
   );
]]

ffi.cdef[[
typedef enum _HIDP_KEYBOARD_DIRECTION {
    HidP_Keyboard_Break,
    HidP_Keyboard_Make
} HIDP_KEYBOARD_DIRECTION;
]]

ffi.cdef([[
typedef struct _HIDP_KEYBOARD_MODIFIER_STATE {
   union {
      struct {
         ULONG LeftControl: 1;
         ULONG LeftShift: 1;
         ULONG LeftAlt: 1;
         ULONG LeftGUI: 1;
         ULONG RightControl: 1;
         ULONG RightShift: 1;
         ULONG RightAlt: 1;
         ULONG RigthGUI: 1;
         ULONG CapsLock: 1;
         ULONG ScollLock: 1;
         ULONG NumLock: 1;
         ULONG Reserved: 21;
      };
      ULONG ul;
   };

} HIDP_KEYBOARD_MODIFIER_STATE, * PHIDP_KEYBOARD_MODIFIER_STATE;
]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))
--#include <poppack.h>

ffi.cdef[[
//
// A call back function to give the i8042 scan codes to the caller of
// the below translation function.
//
typedef BOOLEAN (* PHIDP_INSERT_SCANCODES) (
                  PVOID Context,  // Some caller supplied context.
                  PCHAR NewScanCodes, // A list of i8042 scan codes.
                  ULONG Length // the length of the scan codes.
                  );


NTSTATUS __stdcall
HidP_TranslateUsageAndPagesToI8042ScanCodes (
    PUSAGE_AND_PAGE ChangedUsageList,
        ULONG                         UsageListLength,
        HIDP_KEYBOARD_DIRECTION       KeyAction,
     PHIDP_KEYBOARD_MODIFIER_STATE ModifierState,
        PHIDP_INSERT_SCANCODES        InsertCodesProcedure,
    PVOID                         InsertCodesContext
    );


NTSTATUS __stdcall
HidP_TranslateUsagesToI8042ScanCodes (
    PUSAGE ChangedUsageList,
        ULONG                         UsageListLength,
        HIDP_KEYBOARD_DIRECTION       KeyAction,
     PHIDP_KEYBOARD_MODIFIER_STATE ModifierState,
        PHIDP_INSERT_SCANCODES        InsertCodesProcedure,
    PVOID                         InsertCodesContext
    );
]]


--[[
//
// Define NT Status codes with Facility Code of FACILITY_HID_ERROR_CODE
//

// FACILITY_HID_ERROR_CODE defined in ntstatus.h
#ifndef FACILITY_HID_ERROR_CODE
#define FACILITY_HID_ERROR_CODE 0x11
#endif

#define HIDP_ERROR_CODES(SEV, CODE) \
        ((NTSTATUS) (((SEV) << 28) | (FACILITY_HID_ERROR_CODE << 16) | (CODE)))

#define HIDP_STATUS_SUCCESS                  (HIDP_ERROR_CODES(0x0,0))
#define HIDP_STATUS_NULL                     (HIDP_ERROR_CODES(0x8,1))
#define HIDP_STATUS_INVALID_PREPARSED_DATA   (HIDP_ERROR_CODES(0xC,1))
#define HIDP_STATUS_INVALID_REPORT_TYPE      (HIDP_ERROR_CODES(0xC,2))
#define HIDP_STATUS_INVALID_REPORT_LENGTH    (HIDP_ERROR_CODES(0xC,3))
#define HIDP_STATUS_USAGE_NOT_FOUND          (HIDP_ERROR_CODES(0xC,4))
#define HIDP_STATUS_VALUE_OUT_OF_RANGE       (HIDP_ERROR_CODES(0xC,5))
#define HIDP_STATUS_BAD_LOG_PHY_VALUES       (HIDP_ERROR_CODES(0xC,6))
#define HIDP_STATUS_BUFFER_TOO_SMALL         (HIDP_ERROR_CODES(0xC,7))
#define HIDP_STATUS_INTERNAL_ERROR           (HIDP_ERROR_CODES(0xC,8))
#define HIDP_STATUS_I8042_TRANS_UNKNOWN      (HIDP_ERROR_CODES(0xC,9))
#define HIDP_STATUS_INCOMPATIBLE_REPORT_ID   (HIDP_ERROR_CODES(0xC,0xA))
#define HIDP_STATUS_NOT_VALUE_ARRAY          (HIDP_ERROR_CODES(0xC,0xB))
#define HIDP_STATUS_IS_VALUE_ARRAY           (HIDP_ERROR_CODES(0xC,0xC))
#define HIDP_STATUS_DATA_INDEX_NOT_FOUND     (HIDP_ERROR_CODES(0xC,0xD))
#define HIDP_STATUS_DATA_INDEX_OUT_OF_RANGE  (HIDP_ERROR_CODES(0xC,0xE))
#define HIDP_STATUS_BUTTON_NOT_PRESSED       (HIDP_ERROR_CODES(0xC,0xF))
#define HIDP_STATUS_REPORT_DOES_NOT_EXIST    (HIDP_ERROR_CODES(0xC,0x10))
#define HIDP_STATUS_NOT_IMPLEMENTED          (HIDP_ERROR_CODES(0xC,0x20))
--]]

ffi.cdef[[
//
// We blundered this status code.
//
static const int HIDP_STATUS_I8242_TRANS_UNKNOWN = HIDP_STATUS_I8042_TRANS_UNKNOWN;
]]

--[[
#define HidP_IsSameUsageAndPage(u1, u2) ((* (PULONG) &u1) == (* (PULONG) &u2))

#define HidP_GetButtonsEx(Rty, LCo, BLi, ULe, Ppd, Rep, RLe)  \
         HidP_GetUsagesEx(Rty, LCo, BLi, ULe, Ppd, Rep, RLe)
   #define HidP_SetButtons(Rty, Up, Lco, ULi, ULe, Ppd, Rep, Rle) \
   HidP_SetUsages(Rty, Up, Lco, ULi, ULe, Ppd, Rep, Rle)

#define HidP_UnsetButtons(Rty, Up, Lco, ULi, ULe, Ppd, Rep, Rle) \
        HidP_UnsetUsages(Rty, Up, Lco, ULi, ULe, Ppd, Rep, Rle)

#define HidP_GetButtons(Rty, UPa, LCo, ULi, ULe, Ppd, Rep, RLe) \
        HidP_GetUsages(Rty, UPa, LCo, ULi, ULe, Ppd, Rep, RLe)

--]]