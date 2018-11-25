

--[[
Abstract:

    Master include file for Windows applications.

--]]

--require("win32.sdkddkver")

if not _INC_WINDOWS then
_INC_WINDOWS = true


--[[
/*  If defined, the following flags inhibit definition
 *     of the indicated items.
 *
 *  NOGDICAPMASKS     - CC_*, LC_*, PC_*, CP_*, TC_*, RC_
 *  NOVIRTUALKEYCODES - VK_*
 *  NOWINMESSAGES     - WM_*, EM_*, LB_*, CB_*
 *  NOWINSTYLES       - WS_*, CS_*, ES_*, LBS_*, SBS_*, CBS_*
 *  NOSYSMETRICS      - SM_*
 *  NOMENUS           - MF_*
 *  NOICONS           - IDI_*
 *  NOKEYSTATES       - MK_*
 *  NOSYSCOMMANDS     - SC_*
 *  NORASTEROPS       - Binary and Tertiary raster ops
 *  NOSHOWWINDOW      - SW_*
 *  OEMRESOURCE       - OEM Resource values
 *  NOATOM            - Atom Manager routines
 *  NOCLIPBOARD       - Clipboard routines
 *  NOCOLOR           - Screen colors
 *  NOCTLMGR          - Control and Dialog routines
 *  NODRAWTEXT        - DrawText() and DT_*
 *  NOGDI             - All GDI defines and routines
 *  NOKERNEL          - All KERNEL defines and routines
 *  NOUSER            - All USER defines and routines
 *  NONLS             - All NLS defines and routines
 *  NOMB              - MB_* and MessageBox()
 *  NOMEMMGR          - GMEM_*, LMEM_*, GHND, LHND, associated routines
 *  NOMETAFILE        - typedef METAFILEPICT
 *  NOMINMAX          - Macros min(a,b) and max(a,b)
 *  NOMSG             - typedef MSG and associated routines
 *  NOOPENFILE        - OpenFile(), OemToAnsi, AnsiToOem, and OF_*
 *  NOSCROLL          - SB_* and scrolling routines
 *  NOSERVICE         - All Service Controller routines, SERVICE_ equates, etc.
 *  NOSOUND           - Sound driver routines
 *  NOTEXTMETRIC      - typedef TEXTMETRIC and associated routines
 *  NOWH              - SetWindowsHook and WH_*
 *  NOWINOFFSETS      - GWL_*, GCL_*, associated routines
 *  NOCOMM            - COMM driver routines
 *  NOKANJI           - Kanji support stuff.
 *  NOHELP            - Help engine interface.
 *  NOPROFILER        - Profiler interface.
 *  NODEFERWINDOWPOS  - DeferWindowPos routines
 *  NOMCX             - Modem Configuration Extensions
 */
--]]




--[[
if not _68K and not _MPPC and not _X86 and not _IA64 and not _AMD64 and not _ARM and not _ARM64 and _M_IX86 then
_X86_ = false;
if  not _CHPE_X86_ARM64_ and _M_HYBRID then
_CHPE_X86_ARM64_ = true;
end
end

if not _68K and not _MPPC and not _X86 and not _IA64 and not _AMD64 and not _ARM and not _ARM64 and _M_AMD64 then
 _AMD64_ = true
end

if not _68K and not _MPPC and not _X86 and not _IA64 and not _AMD64 and not _ARM and not _ARM64 and _M_ARM then
 _ARM_ = true
end

if not _68K and not _MPPC and not _X86 and not _IA64 and not _AMD64 and not _ARM and not _ARM64 and _M_ARM64 then
 _ARM64_ = true
end

if not _68K and not _MPPC and not _X86 and not _IA64 and not _AMD64 and not _ARM and not _ARM64 and _M_M68K then
 _68K_ = true
end

if not _68K and not _MPPC and not _X86 and not _IA64 and not _AMD64 and not _ARM and not _ARM64 and _M_MPPC then
 _MPPC_ = true
end

if not _68K and not _MPPC and not _X86 and not _M_IX86) and not _AMD64 and not _ARM and not _ARM64 and _M_IA64 then
if not _IA64
 _IA64_ = true
end /* !_IA64_ */
end

if not _MAC
if _68K or _MPPC
 _MAC = true
end
end

if defined (_MSC_VER)
if ( _MSC_VER >= 800 )
if not __cplusplus
#pragma warning(disable:4116)       /* TYPE_ALIGNMENT generates this - move it */
                                    /* outside the warning push/pop scope. */
end
end
end
--]]

--[[
if not RC_INVOKED then
require("win32.excpt")
require("win32.stdarg")
end /* RC_INVOKED */
--]]

require("win32.windef")
require("win32.winbase")
require("win32.wingdi")
require("win32.winuser")

if not _MAC or _WIN32NLS then
require("win32.winnls")         -- NYI
end

if not _MAC then
require("win32.wincon")
require("win32.winver")
end

if not _MAC or _WIN32REG then
require("win32.winreg")
end

if not _MAC then
require("win32.winnetwk")
end

if not WIN32_LEAN_AND_MEAN then
require("win32.cderr")
require("win32.dde")
require("win32.ddeml")
require("win32.dlgs")
if not _MAC then
require("win32.lzexpand")
require("win32.mmsystem")
require("win32.nb30")
require("win32.rpc")
end    -- _MAC
require("win32.shellapi")
if not _MAC then
require("win32.winperf")
require("win32.winsock")
end -- _MAC
if not NOCRYPT then
require("win32.wincrypt")
require("win32.winefs")
require("win32.winscard")
end -- NOCRYPT

if not NOGDI then
    if not _MAC then
        require("win32.winspool")
        iff INC_OLE1 then
            require("win32.ole")
        else
            require("win32.ole2")
        end --/* !INC_OLE1 */
    end --/* !MAC */
    require("win32.commdlg")
end -- !NOGDI

end -- WIN32_LEAN_AND_MEAN

require("win32.stralign")

if _MAC then
require("win32.winwlm")
end


if INC_OLE2 then
require("win32.ole2")
end -- INC_OLE2 

if not _MAC then
if not NOSERVICE then
require("win32.winsvc")
end


if not  NOMCX then
require("win32.mcx")
end -- NOMCX */

if not NOIME then
require("win32.imm")
end -- NOIME

end  -- !_MAC




end -- _INC_WINDOWS


