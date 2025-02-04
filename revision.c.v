// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_revision.h
//

// SDL_revision.h contains the SDL revision, which might be defined on the
// compiler command line, or generated right into the header itself by the
// build system.

pub const revision = C.SDL_REVISION // Example: 'release-3.2.0-0-g535d80bad (' SDL_VENDOR_INFO ')'
