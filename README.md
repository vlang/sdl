# sdl

SDL2 V module -- libSDL2 wrapper.

Current APIs available/tested in examples:
- basic graphics (2D drawing)
- [Image](image/README.md)
- TTF font (text rendering)
- input handling (keyboard/joystick events)
- sounds (WAV mixing)
- music (MOD mixing)
- more to come.. (networking ?)

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
v run examples/tvintris/tvintris.v
```

## Dependencies

### Linux

#### Fedora
`$ sudo dnf install SDL2-devel SDL2_ttf-devel SDL2_mixer-devel SDL2_image-devel`

#### Ubuntu
`$ sudo apt install libsdl2-ttf-dev libsdl2-mixer-dev libsdl2-image-dev`

#### ClearLinux
`$ sudo swupd bundle-add devpkg-SDL2_ttf devpkg-SDL2_mixer devpkg-SDL2_image`

### MacOS

#### Brew
`$ brew install sdl2 sdl2_gfx sdl2_ttf sdl2_mixer sdl2_image sdl2_net`

If you get no music with the above, try:
`$ brew reinstall --build-from-source --force sdl2 sdl2_gfx sdl2_image sdl2_mixer sdl2_net sdl2_ttf webp libtiff libmodplug libogg`

### Windows

`$ .github\workflows\windows-install-sdl.bat`

## Contributions

- nsauzede
- spytheman
- adlesh
