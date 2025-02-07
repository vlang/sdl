// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_platform_defines.h
//

// SDL_platform_defines.h tries to get a standard set of platform defines.

// A preprocessor macro that is only defined if compiling for AIX.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_aix = C.SDL_PLATFORM_AIX // 1

// A preprocessor macro that is only defined if compiling for Haiku OS.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_haiku = C.SDL_PLATFORM_HAIKU // 1

// A preprocessor macro that is only defined if compiling for BSDi
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_bsdi = C.SDL_PLATFORM_BSDI // 1

// A preprocessor macro that is only defined if compiling for FreeBSD.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_freebsd = C.SDL_PLATFORM_FREEBSD // 1

// A preprocessor macro that is only defined if compiling for HP-UX.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_hpux = C.SDL_PLATFORM_HPUX // 1

// A preprocessor macro that is only defined if compiling for IRIX.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_irix = C.SDL_PLATFORM_IRIX // 1

// A preprocessor macro that is only defined if compiling for Linux.
//
// Note that Android, although ostensibly a Linux-based system, will not
// define this. It defines SDL_PLATFORM_ANDROID instead.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_linux = C.SDL_PLATFORM_LINUX // 1

// A preprocessor macro that is only defined if compiling for Android.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_android = C.SDL_PLATFORM_ANDROID // 1

// A preprocessor macro that is only defined if compiling for a Unix-like
// system.
//
// Other platforms, like Linux, might define this in addition to their primary
// define.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_unix = C.SDL_PLATFORM_UNIX // 1

// A preprocessor macro that is only defined if compiling for Apple platforms.
//
// iOS, macOS, etc will additionally define a more specific platform macro.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_PLATFORM_MACOS
// See also: SDL_PLATFORM_IOS
// See also: SDL_PLATFORM_TVOS
// See also: SDL_PLATFORM_VISIONOS
// pub const platform_apple = C.SDL_PLATFORM_APPLE // 1

// A preprocessor macro that is only defined if compiling for tvOS.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_PLATFORM_APPLE
// pub const platform_tvos = C.SDL_PLATFORM_TVOS // 1

// A preprocessor macro that is only defined if compiling for VisionOS.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_PLATFORM_APPLE
// pub const platform_visionos = C.SDL_PLATFORM_VISIONOS // 1

// A preprocessor macro that is only defined if compiling for iOS.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_PLATFORM_APPLE
// pub const platform_ios = C.SDL_PLATFORM_IOS // 1

// A preprocessor macro that is only defined if compiling for macOS.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_PLATFORM_APPLE
// pub const platform_macos = C.SDL_PLATFORM_MACOS // 1

// A preprocessor macro that is only defined if compiling for Emscripten.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_emscripten = C.SDL_PLATFORM_EMSCRIPTEN // 1

// A preprocessor macro that is only defined if compiling for NetBSD.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_netbsd = C.SDL_PLATFORM_NETBSD // 1

// A preprocessor macro that is only defined if compiling for OpenBSD.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_openbsd = C.SDL_PLATFORM_OPENBSD // 1

// A preprocessor macro that is only defined if compiling for OS/2.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_os2 = C.SDL_PLATFORM_OS2 // 1

// A preprocessor macro that is only defined if compiling for Tru64 (OSF/1).
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_osf = C.SDL_PLATFORM_OSF // 1

// A preprocessor macro that is only defined if compiling for QNX Neutrino.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_qnxnto = C.SDL_PLATFORM_QNXNTO // 1

// A preprocessor macro that is only defined if compiling for RISC OS.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_riscos = C.SDL_PLATFORM_RISCOS // 1

// A preprocessor macro that is only defined if compiling for SunOS/Solaris.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_solaris = C.SDL_PLATFORM_SOLARIS // 1

// A preprocessor macro that is only defined if compiling for Cygwin.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_cygwin = C.SDL_PLATFORM_CYGWIN // 1

// A preprocessor macro that is only defined if compiling for Windows.
//
// This also covers several other platforms, like Microsoft GDK, Xbox, WinRT,
// etc. Each will have their own more-specific platform macros, too.
//
// NOTE: This macro is available since SDL 3.2.0.
//
// See also: SDL_PLATFORM_WIN32
// See also: SDL_PLATFORM_XBOXONE
// See also: SDL_PLATFORM_XBOXSERIES
// See also: SDL_PLATFORM_WINGDK
// See also: SDL_PLATFORM_GDK
// pub const platform_windows = C.SDL_PLATFORM_WINDOWS // 1

// pub const winapi_family_phone = C.SDL_WINAPI_FAMILY_PHONE // (WINAPI_FAMILY == WINAPI_FAMILY_PHONE_APP)

// A preprocessor macro that is only defined if compiling for Microsoft GDK
// for Windows.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_wingdk = C.SDL_PLATFORM_WINGDK // 1

// A preprocessor macro that is only defined if compiling for Xbox One.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_xboxone = C.SDL_PLATFORM_XBOXONE // 1

// A preprocessor macro that is only defined if compiling for Xbox Series.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_xboxseries = C.SDL_PLATFORM_XBOXSERIES // 1

// A preprocessor macro that is only defined if compiling for desktop Windows.
//
// Despite the "32", this also covers 64-bit Windows; as an informal
// convention, its system layer tends to still be referred to as "the Win32
// API."
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_win32 = C.SDL_PLATFORM_WIN32 // 1

// A preprocessor macro that is only defined if compiling for Microsoft GDK on
// any platform.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_gdk = C.SDL_PLATFORM_GDK // 1

// A preprocessor macro that is only defined if compiling for Sony PSP.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_psp = C.SDL_PLATFORM_PSP // 1

// A preprocessor macro that is only defined if compiling for Sony PlayStation
// 2.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_ps2 = C.SDL_PLATFORM_PS2 // 1

// A preprocessor macro that is only defined if compiling for Sony Vita.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_vita = C.SDL_PLATFORM_VITA // 1

// A preprocessor macro that is only defined if compiling for Nintendo 3DS.
//
// NOTE: This macro is available since SDL 3.2.0.
// pub const platform_3ds = C.SDL_PLATFORM_3DS // 1
