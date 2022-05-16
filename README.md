# sdl

`sdl` is a SDL2 V module and a wrapper around [libSDL2](https://www.libsdl.org/).

The module strives to support 100% of the SDL2 API.

So, among many other things, you can:
- Open windows and accelerated rendering contexts
- Render basic 2D graphics
- Handle input events from keyboards, touches, mice, gamepads and joysticks
- Play audio, sound effects and music

# Install

If you want to use SDL2 `v2.0.8` you can simply do:
```bash
v install sdl
```

If you want to use another version of SDL2 you will, currently, have to install
it via `git` or by manual download.

An example of installing SDL2 `v2.0.12` via `git`:
```bash
git clone https://github.com/vlang/sdl.git ~/.vmodules
cd ~/.vmodules/sdl
git checkout 2.0.12
```
and for Windows:
```bash
git clone https://github.com/vlang/sdl.git %HOMEPATH%/.vmodules/sdl
cd %HOMEPATH%/.vmodules/sdl
git checkout 2.0.12
```
Then follow the steps in the [Windows](#windows) section below.

You can see what `sdl` releases are available in the [GitHub repository](https://github.com/vlang/sdl/branches) via branches.

Also note that you'll need the SDL2 libraries available on your system
see the [Dependencies](#dependencies) section below for more details.

### Version notes

SDL2 `v2.0.8` is currently the lowest version of SDL2 supported.
SDL2 is backwards compatible - so anything written against `v2.0.8` can be compiled and run
against newer versions of the SDL2 library.

Also note that SDL2 **is not** compatible with SDL `v1.x`.

## Support

`sdl` is currently supported on:
- Linux
- MacOS (via [homebrew](https://brew.sh/))
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
```bash
sudo dnf install SDL2-devel SDL2_ttf-devel SDL2_mixer-devel SDL2_image-devel
```
#### Ubuntu
```bash
sudo apt install libsdl2-ttf-dev libsdl2-mixer-dev libsdl2-image-dev
```

#### Arch
```bash
sudo pacman -S sdl2 sdl2_image sdl2_mixer sdl2_ttf
```

#### ClearLinux
```bash
sudo swupd bundle-add devpkg-SDL2_ttf devpkg-SDL2_mixer devpkg-SDL2_image
```

### MacOS

#### Brew
```bash
brew install sdl2 sdl2_gfx sdl2_ttf sdl2_mixer sdl2_image sdl2_net
```

If you get no music with the above, try:
```bash
brew reinstall --build-from-source --force sdl2 sdl2_gfx sdl2_image sdl2_mixer sdl2_net sdl2_ttf webp libtiff libmodplug libogg
```

### Windows
It is necessary to install the sdl2 development libraries for Windows.
To do this, change to the root directory of the sdl module, like
`cd %HOMEPATH%\.vmodules\sdl`
and run
`v run windows_install_dependencies.vsh`.
This will create a directory called "thirdparty" which will be used to download and extract the required libraries.
To successfully run a provided example or your own projects, the sdl dlls must be copied to the main application directory.
e.g.:
```bash
copy thirdparty\SDL2-2.0.8\lib\x64\SDL2.dll examples\basic_window\
cd ..
v run sdl\examples\basic_window\main.v
```

## Contributions

- nsauzede
- spytheman
- adlesh
- Larpon
