local ffi = require("ffi")


ffi.cdef[[
typedef struct _GUID {
    unsigned long  Data1;
    unsigned short Data2;
    unsigned short Data3;
    unsigned char  Data4[ 8 ];
} GUID;
]]


local function bytecompare(a, b, n)
	for i=0,n-1 do
		if a[i] ~= b[i] then
			return false
		end
    end
    return true;
end


--local GUID = ffi.typeof("GUID");
local GUID_mt = {
	__tostring = function(self)
		local res = string.format("%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x",
			self.Data1, self.Data2, self.Data3,
			self.Data4[0], self.Data4[1],
			self.Data4[2], self.Data4[3], self.Data4[4],
			self.Data4[5], self.Data4[6], self.Data4[7])
		return res
	end,

	__eq = function(a, b)
		return (a.Data1 == b.Data1) and
			(a.Data2 == b.Data2) and
			(a.Data3 == b.Data3) and
			bytecompare(a.Data4, b.Data4, 4)
	end,
--[[
	__index = {
		Define = function(self, name, l, w1, w2, b1, b2,  b3,  b4,  b5,  b6,  b7,  b8 )
			return GUID({ l, w1, w2, { b1, b2,  b3,  b4,  b5,  b6,  b7,  b8 } }), name
		end,

		DefineOle = function(self, name, l, w1, w2)
			return GUID({ l, w1, w2, { 0xC0,0,0,0,0,0,0,0x46 } }), name
		end,
    },
--]]
}
ffi.metatype("GUID", GUID_mt)



function DEFINE_GUID(name, l, w1, w2, b1, b2, b3, b4, b5, b6, b7, b8)
    --local aguid = GUID():Define(name, l, w1, w2, b1, b2, b3, b4, b5, b6, b7, b8)
    local aguid = ffi.new("GUID",{ l, w1, w2, { b1, b2,  b3,  b4,  b5,  b6,  b7,  b8 } } )
	rawset(_G, name, aguid);
	return aguid;
end


function DEFINE_OLEGUID(name, l, w1, w2) 
    return DEFINE_GUID(name, l, w1, w2, 0xC0,0,0,0,0,0,0,0x46)
end



ffi.cdef[[
typedef GUID *LPGUID;
typedef const GUID *LPCGUID;
]]


ffi.cdef[[
typedef GUID IID;
typedef IID *LPIID;
typedef GUID CLSID;
typedef CLSID *LPCLSID;
typedef GUID FMTID;
typedef FMTID *LPFMTID;
]]

--[[
#define IID_NULL            GUID_NULL
#define CLSID_NULL          GUID_NULL
#define FMTID_NULL          GUID_NULL


#define IsEqualIID(riid1, riid2) IsEqualGUID(riid1, riid2)
#define IsEqualCLSID(rclsid1, rclsid2) IsEqualGUID(rclsid1, rclsid2)
#define IsEqualFMTID(rfmtid1, rfmtid2) IsEqualGUID(rfmtid1, rfmtid2)
--]]

--[[
#ifdef __midl_proxy
#define __MIDL_CONST
#else
#define __MIDL_CONST const
#endif
--]]

if not _REFGUID_DEFINED then
_REFGUID_DEFINED = true
ffi.cdef[[
typedef const GUID * REFGUID
//#define REFGUID const GUID * __MIDL_CONST
]]
end


if not _REFIID_DEFINED then
_REFIID_DEFINED = true;
ffi.cdef[[
typedef  const IID *  REFIID;
]]
end 

--[[
#ifndef _REFCLSID_DEFINED
#define _REFCLSID_DEFINED
#ifdef __cplusplus
#define REFCLSID const IID &
#else
#define REFCLSID const IID * __MIDL_CONST
#endif
#endif
--]]

if not _REFFMTID_DEFINED then
_REFFMTID_DEFINED = true
ffi.cdef[[
typedef const IID * REFFMTID;
//#define REFFMTID const IID * __MIDL_CONST
]]
end


--end --// !__IID_DEFINED__


--[=[
#if !defined (__midl)
#if !defined (_SYS_GUID_OPERATORS_)
#define _SYS_GUID_OPERATORS_
#include <string.h>

// Faster (but makes code fatter) inline version...use sparingly
#ifdef __cplusplus
__inline int InlineIsEqualGUID(REFGUID rguid1, REFGUID rguid2)
{
   return (
      ((unsigned long *) &rguid1)[0] == ((unsigned long *) &rguid2)[0] &&
      ((unsigned long *) &rguid1)[1] == ((unsigned long *) &rguid2)[1] &&
      ((unsigned long *) &rguid1)[2] == ((unsigned long *) &rguid2)[2] &&
      ((unsigned long *) &rguid1)[3] == ((unsigned long *) &rguid2)[3]);
}

__inline int IsEqualGUID(REFGUID rguid1, REFGUID rguid2)
{
    return !memcmp(&rguid1, &rguid2, sizeof(GUID));
}

#else   // ! __cplusplus

#define InlineIsEqualGUID(rguid1, rguid2)  \
        (((unsigned long *) rguid1)[0] == ((unsigned long *) rguid2)[0] &&   \
        ((unsigned long *) rguid1)[1] == ((unsigned long *) rguid2)[1] &&    \
        ((unsigned long *) rguid1)[2] == ((unsigned long *) rguid2)[2] &&    \
        ((unsigned long *) rguid1)[3] == ((unsigned long *) rguid2)[3])

#define IsEqualGUID(rguid1, rguid2) (!memcmp(rguid1, rguid2, sizeof(GUID)))

#endif  // __cplusplus

#ifdef __INLINE_ISEQUAL_GUID
#undef IsEqualGUID
#define IsEqualGUID(rguid1, rguid2) InlineIsEqualGUID(rguid1, rguid2)
#endif

// Same type, different name

#define IsEqualIID(riid1, riid2) IsEqualGUID(riid1, riid2)
#define IsEqualCLSID(rclsid1, rclsid2) IsEqualGUID(rclsid1, rclsid2)


#if !defined _SYS_GUID_OPERATOR_EQ_ && !defined _NO_SYS_GUID_OPERATOR_EQ_
#define _SYS_GUID_OPERATOR_EQ_
// A couple of C++ helpers

#ifdef __cplusplus
__inline bool operator==(REFGUID guidOne, REFGUID guidOther)
{
    return !!IsEqualGUID(guidOne,guidOther);
}

__inline bool operator!=(REFGUID guidOne, REFGUID guidOther)
{
    return !(guidOne == guidOther);
}
--]=]
