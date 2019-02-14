package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C 

require("win32.sdkddkver")

local systemtopology = require("win32.systemtopologyapi")

local PULONG = ffi.typeof("ULONG[$]",1)

local function test_highestnode()
    local HighestNodeNumber = PULONG()

    local success = C.GetNumaHighestNodeNumber(HighestNodeNumber) ~= 0;
    print("GetNumaHighestNodeNumber(): ", success, HighestNodeNumber[0])
end

local function test_nodemask()
    local HighestNodeNumber = PULONG()
    local success = C.GetNumaHighestNodeNumber(HighestNodeNumber) ~= 0;

    if not success then 
        print("FAILED: ", C.GetLastError())
    end

--[[
typedef struct _GROUP_AFFINITY {
    KAFFINITY Mask;
    WORD   Group;
    WORD   Reserved[3];
} GROUP_AFFINITY, *PGROUP_AFFINITY;
--]]
    local ProcessorMask = ffi.new("GROUP_AFFINITY")
    for Node = 0, HighestNodeNumber[0] do
        local success = C.GetNumaNodeProcessorMaskEx(Node, ProcessorMask) ~= 0;
        if not success then
            print("FAILED: ", C.GetLastError())
        else
            print(string.format("Group: %d", ProcessorMask.Group))
        end
    end
end

--test_highestnode()
test_nodemask()
