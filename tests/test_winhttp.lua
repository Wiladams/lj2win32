package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C


require("win32.sdkddkver")
require("win32.minwindef")
require("win32.minwinbase")

local winhttp = require("win32.winhttp")
local unicode = require("unicode_util")
local L = unicode.toUnicode

local HttpClient = require("HttpClient")
local HttpSession = HttpClient.HttpSession
local HttpRequest = HttpClient.HttpRequest
local HttpConnection = HttpClient.HttpConnection



-- Test it out
local session = HttpSession();


print("Session: ", session)
if not session then 
    return nil;
end

local connection, err = session:createConnection({ServerName = "www.bing.com"})

print("connection: ", connection, err)

local request, err = connection:createRequest({Verb = "GET", Resource=""})

print("request: ", request, err)

if not request then
    return false;
end

local bResult = request:send()
print("send: ", bResult)

local bResult = request:waitForResponse()

print("waitForResponse: ", bResult)

if not bResult then return 
    false
end



for header in request:responseHeaders() do
    print("HEADER: ", header)
end


local dataAvail = request:dataAvailable()
if dataAvail > 0 then
    print("data available: ", dataAvail)
end

--[[
    Wouldn't it be nice to do:

        local stream = Http["www.bing.com"]:get("index.html")
        or
        local stream = Http:get("www.bing.com/index.html")
        local headers = Http:get("www.bing.com/index.html").headers
        local headers = stream.headers
        
        or
        local result = Http:put("www.bin.com/index.html", stream)
        or 
        local result = Http["www.bing.com"]:put("index.html", stream)
]]
