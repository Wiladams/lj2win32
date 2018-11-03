package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
require("win32.minwindef")
require("win32.wtypes")
--[=[
ffi.cdef[[
typedef  LONG NTSTATUS;
typedef uint16_t    USHORT;
typedef USHORT USAGE, *PUSAGE;
]]
--]=]

--local hidpi = require("win32.hidpi")
local hidsdi = require("win32.hidsdi")

local function test_packing()
ffi.cdef[[
typedef union epoll_data {
  void *ptr;
  int fd;
  uint32_t u32;
  uint64_t u64;
} epoll_data_t;
]]

ffi.cdef([[
struct epoll_event {
int32_t events;
epoll_data_t data;
}]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))
end
