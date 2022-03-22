# sdl

`sdl` is a SDL2 V module and a wrapper around `libSDL2`.
The module strives to support 100% of the SDL2 API.

So, among many other things, you can:
- basic graphics (2D drawing)
- input handling (keyboard/gamepad/joystick events)
- sounds
- music

Currently available APIs:
- atomic         (SDL_atomic.h)
- audio          (SDL_audio.h)
- blendmode      (SDL_blendmode.h)
- clipboard      (SDL_clipboard.h)
- cpuinfo        (SDL_cpuinfo.h)
- endian         (SDL_endian.h)
- error          (SDL_error.h)
- events         (SDL_events.h)
- filesystem     (SDL_filesystem.h)
- gamecontroller (SDL_gamecontroller.h)
- gesture        (SDL_gesture.h)
- haptic         (SDL_haptic.h)
- hints          (SDL_hints.h)
- hidapi         (SDL_hidapi.h)
- joystick       (SDL_joystick.h)
- keyboard       (SDL_keyboard.h)
- keycode        (SDL_keycode.h)
- loadso         (SDL_loadso.h)
- locale         (SDL_locale.h)
- log            (SDL_log.h)
- main           (SDL_main.h)
- messagebox     (SDL_messagebox.h)
- misc           (SDL_misc.h)
- mouse          (SDL_mouse.h)
- mutex          (SDL_mutex.h)
- pixels         (SDL_pixels.h)
- platform       (SDL_platform.h)
- power          (SDL_power.h)
- quit           (SDL_quit.h)
- rect           (SDL_rect.h)
- render         (SDL_render.h)
- rwops          (SDL_rwops.h)
- scancode       (SDL_scancode.h)
- sensor         (SDL_sensor.h)
- sdl            (SDL_sdl.h)
- stdinc         (SDL_stdinc.h)
- shape          (SDL_shape.h)
- surface        (SDL_surface.h)
- system         (SDL_system.h)
- thread         (SDL_thread.h)
- timer          (SDL_timer.h)
- touch          (SDL_touch.h)
- version        (SDL_version.h)
- video          (SDL_video.h)
- vulkan         (SDL_vulkan.h)

Currently available SDL2 modules:
- [image](image/README.md), for image load, save and render support
- ttf, for TTF font support and text rendering
- mixer, for audio mixing

## Support
sdl is supported on:
- Linux (major distros)
- MacOS (brew)
- Windows

## Examples

[tVintris](examples/tvintris)

![tVintris screenshot](/examples/tvintris/images/tvintris.png)

You can run the tVintris example like this :
```
v run sdl/examples/tvintris/tvintris.v
```

## Dependencies

### Linux

#### Fedora
`$ sudo dnf install SDL2-devel SDL2_ttf-devel SDL2_mixer-devel SDL2_image-devel`

#### Ubuntu
`$ sudo apt install libsdl2-ttf-dev libsdl2-mixer-dev libsdl2-image-dev`

#### Arch
 `$ sudo pacman -S sdl2 sdl2_image sdl2_mixer sdl2_ttf`

#### ClearLinux
`$ sudo swupd bundle-add devpkg-SDL2_ttf devpkg-SDL2_mixer devpkg-SDL2_image`

### MacOS

#### Brew
`$ brew install sdl2 sdl2_gfx sdl2_ttf sdl2_mixer sdl2_image sdl2_net`

If you get no music with the above, try:
`$ brew reinstall --build-from-source --force sdl2 sdl2_gfx sdl2_image sdl2_mixer sdl2_net sdl2_ttf webp libtiff libmodplug libogg`

### Windows
It is necessary to install the sdl2 development libraries for Windows.
To do this, change to the root directory of the sdl module, like
`cd %HOMEPATH%\.vmodules\sdl`
and run
`v run windows_install_dependencies.vsh`.
This will create a directory called "thirdparty" which will be used to download and extract the required libraries.
To successfully run a provided example or your own projects, the sdl dlls must be copied to the main application directory.
e.g..
```
copy thirdparty\SDL2-2.0.20\lib\x64\SDL2.dll examples\basic_window\
cd ..
v run sdl\examples\basic_window\main.v
```

## Contributions

- nsauzede
- spytheman
- adlesh
- Larpon
