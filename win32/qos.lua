local ffi = require ("ffi")



if not __QOS_H_ then
__QOS_H_ = true


require("win32.winapifamily")


if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) then

ffi.cdef[[
typedef ULONG   SERVICETYPE;
]]

ffi.cdef[[
static const int SERVICETYPE_NOTRAFFIC               = 0x00000000;  /* No data in this 
                                                         * direction */
static const int SERVICETYPE_BESTEFFORT              = 0x00000001;  /* Best Effort */
static const int SERVICETYPE_CONTROLLEDLOAD          = 0x00000002;  /* Controlled Load */
static const int SERVICETYPE_GUARANTEED              = 0x00000003;  /* Guaranteed */

static const int SERVICETYPE_NETWORK_UNAVAILABLE     = 0x00000004;  /* Used to notify 
                                                         * change to user */
static const int SERVICETYPE_GENERAL_INFORMATION     = 0x00000005;  /* corresponds to 
                                                         * "General Parameters"
                                                         * defined by IntServ */
static const int SERVICETYPE_NOCHANGE                = 0x00000006;  /* used to indicate
                                                         * that the flow spec
                                                         * contains no change
                                                         * from any previous
                                                         * one */
static const int SERVICETYPE_NONCONFORMING           = 0x00000009;  /* Non-Conforming Traffic */
static const int SERVICETYPE_NETWORK_CONTROL         = 0x0000000A;  /* Network Control traffic */
static const int SERVICETYPE_QUALITATIVE             = 0x0000000D;  /* Qualitative applications */ 



/*********  The usage of these is currently not supported.  ***************/
static const int SERVICE_BESTEFFORT                  = 0x80010000;
static const int SERVICE_CONTROLLEDLOAD              = 0x80020000;
static const int SERVICE_GUARANTEED                  = 0x80040000;
static const int SERVICE_QUALITATIVE                 = 0x80200000;
/* **************************** ***** ************************************ */
]]


ffi.cdef[[
static const int SERVICE_NO_TRAFFIC_CONTROL  = 0x81000000;
static const int SERVICE_NO_QOS_SIGNALING  = 0x40000000;
]]


ffi.cdef[[

typedef struct _flowspec
{
    ULONG       TokenRate;              /* In Bytes/sec */
    ULONG       TokenBucketSize;        /* In Bytes */
    ULONG       PeakBandwidth;          /* In Bytes/sec */
    ULONG       Latency;                /* In microseconds */
    ULONG       DelayVariation;         /* In microseconds */
    SERVICETYPE ServiceType;
    ULONG       MaxSduSize;             /* In Bytes */
    ULONG       MinimumPolicedSize;     /* In Bytes */

} FLOWSPEC, *PFLOWSPEC, * LPFLOWSPEC;
]]

ffi.cdef[[
static const int QOS_NOT_SPECIFIED   =  0xFFFFFFFF;
static const int   POSITIVE_INFINITY_RATE   =  0xFFFFFFFE;
]]

ffi.cdef[[
typedef struct  {

    ULONG   ObjectType;
    ULONG   ObjectLength;  /* the length of object buffer INCLUDING 
                            * this header */

} QOS_OBJECT_HDR, *LPQOS_OBJECT_HDR;
]]

ffi.cdef[[

static const int   QOS_GENERAL_ID_BASE                    =  2000;
static const int   QOS_OBJECT_END_OF_LIST                 =  (0x00000001 + QOS_GENERAL_ID_BASE) ;
static const int   QOS_OBJECT_SD_MODE                     =  (0x00000002 + QOS_GENERAL_ID_BASE); 
static const int   QOS_OBJECT_SHAPING_RATE	              = (0x00000003 + QOS_GENERAL_ID_BASE);
static const int   QOS_OBJECT_DESTADDR                    =  (0x00000004 + QOS_GENERAL_ID_BASE);
]]



ffi.cdef[[
typedef struct _QOS_SD_MODE {

    QOS_OBJECT_HDR   ObjectHdr;
    ULONG            ShapeDiscardMode;

} QOS_SD_MODE, *LPQOS_SD_MODE;

static const int TC_NONCONF_BORROW      = 0;
static const int TC_NONCONF_SHAPE       = 1;
static const int TC_NONCONF_DISCARD     = 2;
static const int TC_NONCONF_BORROW_PLUS = 3; // Not supported currently
]]


ffi.cdef[[
typedef struct _QOS_SHAPING_RATE {

    QOS_OBJECT_HDR   ObjectHdr;
    ULONG            ShapingRate;

} QOS_SHAPING_RATE, *LPQOS_SHAPING_RATE;
]]


end --/* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */


end  --/* __QOS_H_ */
