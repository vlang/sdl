// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

#include <wchar.h>

@[typedef]
pub struct C.wchar_t {}

// WCharT is a type alias for `C.wchar_t`.
// NOTE: the size of `C.wchar_t` varies between platforms, it is 2 bytes on windows,
// and usually 4 bytes elsewhere.
pub type WCharT = C.wchar_t
