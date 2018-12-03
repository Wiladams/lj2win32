local ffi = require("ffi")

require("win32.winapifamily")

require("win32.wincontypes")


if not NOGDI then
require("win32.wingdi")
end

if not NOAPISET then
require("win32.consoleapi")
require("win32.consoleapi2")
require("win32.consoleapi3")
end

#define CONSOLE_REAL_OUTPUT_HANDLE (LongToHandle(-2))
#define CONSOLE_REAL_INPUT_HANDLE (LongToHandle(-3))

#define CONSOLE_TEXTMODE_BUFFER  1

#if(_WIN32_WINNT >= 0x0500)
#endif /* _WIN32_WINNT >= 0x0500 */


#if _MSC_VER >= 1200
#pragma warning(pop)
#endif

#ifdef __cplusplus
}
#endif

#endif // _WINCON_

