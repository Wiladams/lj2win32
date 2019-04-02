package.path = "../?.lua;"..package.path;

local ffi = require("ffi")
local C = ffi.C


require("win32.sdkddkver")
require("win32.minwindef")
require("win32.minwinbase")

local winhttp = require("win32.winhttp")
local unicode = require("unicode_util")
local L = unicode.toUnicode

local dwAccessType = C.WINHTTP_ACCESS_TYPE_DEFAULT_PROXY
local pszProxyW = nil;
local pszProxyBypassW = nil;
local dwFlags = C.WINHTTP_FLAG_ASYNC;

local hSession = winhttp.WinHttpOpen(L"test_winhttp", dwAccessType, pszProxyW, pszProxyBypassW, dwFlags);

print("hSession: ", hSession)

local pswzServerName = L"www.bing.com"
local nServerPort = 80
local dwReserved = 0

local hConnection = winhttp.WinHttpConnect(hSession, pswzServerName, nServerPort, dwReserved);

print("hConnection: ", hConnection)

local result = winhttp.WinHttpCloseHandle(hConnection);


--[[
    BOOL  bResults = FALSE;
    HINTERNET hSession = NULL,
              hConnect = NULL,
              hRequest = NULL;

    // Use WinHttpOpen to obtain a session handle.
    hSession = WinHttpOpen(  L"A WinHTTP Example Program/1.0", 
                             WINHTTP_ACCESS_TYPE_DEFAULT_PROXY,
                             WINHTTP_NO_PROXY_NAME, 
                             WINHTTP_NO_PROXY_BYPASS, 0);

    // Specify an HTTP server.
    if (hSession)
        hConnect = WinHttpConnect( hSession, L"www.wingtiptoys.com",
                                   INTERNET_DEFAULT_HTTP_PORT, 0);

    // Create an HTTP Request handle.
    if (hConnect)
        hRequest = WinHttpOpenRequest( hConnect, L"PUT", 
                                       L"/writetst.txt", 
                                       NULL, WINHTTP_NO_REFERER, 
                                       WINHTTP_DEFAULT_ACCEPT_TYPES,
                                       0);

    // Send a Request.
    if (hRequest) 
        bResults = WinHttpSendRequest( hRequest, 
                                       WINHTTP_NO_ADDITIONAL_HEADERS,
                                       0, WINHTTP_NO_REQUEST_DATA, 0, 
                                       0, 0);

    // PLACE ADDITIONAL CODE HERE.

    // Report any errors.
    if (!bResults)
        printf( "Error %d has occurred.\n", GetLastError());

    // Close any open handles.
    if (hRequest) WinHttpCloseHandle(hRequest);
    if (hConnect) WinHttpCloseHandle(hConnect);
    if (hSession) WinHttpCloseHandle(hSession);
]]