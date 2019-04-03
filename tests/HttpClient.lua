
local ffi = require("ffi")
local C = ffi.C

require("win32.sdkddkver")
require("win32.minwindef")
require("win32.minwinbase")

local winhttp = require("win32.winhttp")
local strdelim = require("strdelim")
local unicode = require("unicode_util")
local L = unicode.toUnicode
local toAnsi = unicode.toAnsi

--[[
    HTTP Request
]]
local HttpRequest = {}
setmetatable(HttpRequest, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local HttpRequest_mt = {
    __index = HttpRequest
}

function HttpRequest.init(self, params)
    setmetatable(params, HttpRequest_mt)
    return params
end

function HttpRequest.new(self, params)
    local hConnect = params.ConnectionHandle

    if not hConnect then
        if not params.Connection then
            return false, "HttpRequest.new: No connection specified"
        end

        hConnect = params.Connection.ConnectionHandle
    end

    if not params.Resource then
        return false, "HttpRequest.new: no resource specified"
    end

    local verb = params.Verb or "GET"
    local hRequest = winhttp.WinHttpOpenRequest( hConnect, L(verb), 
        L(params.Resource), nil, WINHTTP_NO_REFERER, WINHTTP_DEFAULT_ACCEPT_TYPES, 0);

    if hRequest == nil then
        return false, "WinHttpOpenRequest, FAIL"
    end

    ffi.gc(hRequest, winhttp.WinHttpCloseHandle)
    
    return self:init({RequestHandle = hRequest, Connection = params.Connection, Verb = params.Verb, Resource = params.Resource})
end

function HttpRequest.send(self)
    local bResults = winhttp.WinHttpSendRequest( self.RequestHandle, WINHTTP_NO_ADDITIONAL_HEADERS, 0, WINHTTP_NO_REQUEST_DATA, 0, 0, 0);
    return bResults ~= 0
end

function HttpRequest.waitForResponse(self)
    local bResult = winhttp.WinHttpReceiveResponse(self.RequestHandle, lpReserved);

    return bResult ~= 0
end

function HttpRequest.dataAvailable(self)
    local bytesAvailable = ffi.new("DWORD[1]")
    local bResult = winhttp.WinHttpQueryDataAvailable(self.RequestHandle, bytesAvailable);

    if bResult == 0 then
        return false, "WinHttpQueryDataAvailable, FAIL"
    end

    return tonumber(bytesAvailable[0])
end

function HttpRequest.responseHeaders(self)
    local function visitor()
        local dwInfoLevel = C.WINHTTP_QUERY_RAW_HEADERS
        local pwszName = WINHTTP_HEADER_NAME_BY_INDEX
        local bufferLength = 1024 * 64;
        local lpdwBufferLength = ffi.new("DWORD[1]",bufferLength);
        local lpBuffer = ffi.new("uint8_t[?]", bufferLength)
        local lpdwIndex = ffi.new("DWORD[1]")

        local bResult = winhttp.WinHttpQueryHeaders(self.RequestHandle,
            dwInfoLevel,
            pwszName ,
            lpBuffer,
            lpdwBufferLength,
            WINHTTP_NO_HEADER_INDEX);

        --print("responseHeaders: ", bResult,lpdwBufferLength[0] )
        local rSize = lpdwBufferLength[0]
        if rSize < 1 then
            return nil;
        end

        for idx, str in  strdelim.mstriter({
            data = lpBuffer, 
            datalength = rSize/2,
            basetype = ffi.typeof("wchar_t")
        }) do 
            print(idx, str)
            coroutine.yield(toAnsi(str))
        end
    end

    return coroutine.wrap(visitor)
end

--[[
    HTTP Connection
]]
local HttpConnection = {}
setmetatable(HttpConnection, {
    __call = function(self, ...)
        return self:new(...)
    end,
})
local HttpConnection_mt = {
    __index = HttpConnection;
}

function HttpConnection.init(self, obj)
    obj = obj or {}
    setmetatable(obj, HttpConnection_mt)
    
    return obj;
end

function HttpConnection.new(self, params)
    if not params then
        return false, "No parameters specified"
    end

    if not params.ServerName then 
        return false, "No Server Name Specified"
    end

    params.Port = params.Port or 80

    local serverName = L(params.ServerName)
    local reserved = 0

    local hConnection = winhttp.WinHttpConnect(params.SessionHandle, serverName, params.Port, reserved);

    if hConnection == nil then
        return false, "WinHttpConnect FAIL"
    end


    ffi.gc(hConnection, winhttp.WinHttpCloseHandle)


    return self:init({ServerName = params.ServerName, Port = params.Port, ConnectionHandle = hConnection})
end

function HttpConnection.createRequest(self, params)
    return HttpRequest:new({Connection = self, Verb = params.Verb, Resource = params.Resource})
end

--[[
    HTTP Session
]]
local HttpSession = {}
setmetatable(HttpSession, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local HttpSession_mt = {
    __index = HttpSession;
}

function HttpSession.init(self, obj)
    obj = obj or {}

    local dwAccessType = C.WINHTTP_ACCESS_TYPE_DEFAULT_PROXY
    local pszProxyW = nil;
    local pszProxyBypassW = nil;
    --local dwFlags = C.WINHTTP_FLAG_ASYNC;
    local dwFlags = 0;

    local hSession = winhttp.WinHttpOpen(L"test_winhttp", dwAccessType, pszProxyW, pszProxyBypassW, dwFlags);

    if hSession == nil then
        return nil;
    end

    -- close the handle properly if it goes out of scope
    ffi.gc(hSession, winhttp.WinHttpCloseHandle)

    obj.SessionHandle = hSession;
    
    setmetatable(obj, HttpSession_mt)

    return obj;
end

function HttpSession.new(self, ...)
    return self:init(...)
end

function HttpSession.createConnection(self, params)
    -- should check for a url
    -- and parse that
    if not params.ServerName then 
        return false, "No Server Name Specified"
    end

    return HttpConnection({SessionHandle = self.SessionHandle, ServerName = params.ServerName, Port = params.Port or 80})
end


return {
    HttpSession = HttpSession;
    HttpConnection = HttpConnection;
    HttpRequest = HttpRequest;
}