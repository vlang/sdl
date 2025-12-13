# sdl

`sdl` is a SDL V module and a wrapper around [libSDL](https://www.libsdl.org/).
Both SDL2 and SDL3 versions are supported through dedicated [branches](https://github.com/vlang/sdl/branches).

The module strives to support 100% of the SDL API.

So, among many other things, you can:
- Open windows and accelerated rendering contexts
- Render basic 2D graphics
- Handle input events from keyboards, touches, mice, gamepads and joysticks
- Play audio, sound effects and music

## Project Navigation

You are currently reading the instructions for **SDL2**.
For SDL3 instructions, see the `README.md` in any of the `3.x.x` [branches](https://github.com/vlang/sdl/branches).

## Install

To use `vlang/sdl` you need SDL2 libraries installed and the corresponding
`vlang/sdl` *branch* checked out that *matches the SDL2 version installed* on the target system.

See [Dependencies](#Dependencies) section below for how to install SDL2
for different OSes and systems.

If you have SDL2 version `2.30.x` installed on your system you can simply do:
```bash
v install sdl
v ~/.vmodules/sdl/setup.vsh
```

If you want to use another version of SDL2 you will, currently, have to install
it via `git` or by manual download.

An example of installing the system provided version of SDL2 via `git`:
```bash
git clone https://github.com/vlang/sdl.git ~/.vmodules/sdl
v ~/.vmodules/sdl/setup.vsh
```

Should `sdl2-config` be absent on your system you can try the following instead,
by providing the version manually:

An example of installing the `2.0.12` branch (that *matches* SDL2 version 2.0.12) via `git`:
```bash
git clone https://github.com/vlang/sdl.git ~/.vmodules/sdl
cd ~/.vmodules/sdl
git checkout 2.0.12
```
... and for Windows in cmd.exe:
```bash
git clone https://github.com/vlang/sdl.git %HOMEPATH%/.vmodules/sdl
cd %HOMEPATH%/.vmodules/sdl
git checkout 2.0.12
```
... and for Windows in PowerShell (PS):
```bash
git clone https://github.com/vlang/sdl.git "$HOME/.vmodules/sdl"
cd "$HOME/.vmodules/sdl"
git checkout 2.0.12
```

Then follow the steps in the [Windows](#windows) section below.

You can see what `sdl` releases are available in the [GitHub repository](https://github.com/vlang/sdl/branches) via branches.

## Notes

### Versions

SDL2 `v2.0.8` is currently the lowest version of SDL2 supported.
SDL2 is backwards compatible - so anything written against `v2.0.8` can be compiled and run
against newer versions of the SDL2 library.

Also note that SDL2 **is not** compatible with SDL `v1.x`.
SDL2 is however compatible with SDL3 through the [`sdl2-compat`](https://github.com/libsdl-org/sdl2-compat) layer.
Which makes it possible to use the SDL2 API through the SDL3 libraries.
You can tell `sdl` to use this compatibility layer on systems that support `pkgconfig` by
passing the compile time flag `-d sdl_compat` when building your `sdl`/SDL2 based V application.

### Notes on garbage collection and memory issues

Currently, with some setups, SDL2 is known to trigger crashes when used in conjunction
with V's default garbage collector. Because of this you have to explicitly **opt-in**
to use V's garbage collection with SDL2.

If you choose to use the garbage collector with SDL objects
(by running apps importing `sdl` with `v -d sdl_use_gc run`)
you may experience runtime crashes and output similar to this:

```
main__main: RUNTIME ERROR: invalid memory access
```

We are tracking the issue here: https://github.com/vlang/sdl/issues/744

The crashes can be avoided by simply **not** passing `-d sdl_use_gc` and
managing memory manually with SDL's memory functions like `sdl.free/1`, `sdl.malloc/1`,
`sdl.calloc/2`, `sdl.realloc/2` and the various `create_*` and `destroy` functions.

## Support

`sdl` is currently supported on:
- Linux
- MacOS (via [homebrew](https://brew.sh/))
- Windows

## Examples

[tVintris](examples/tvintris)

![tVintris screenshot](/examples/assets/images/tvintris.png)

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
It is necessary to install the SDL2 development libraries for Windows.

To do this, run this in cmd.exe:
```bash
cd %HOMEPATH%\.vmodules\sdl
v run windows_install_dependencies.vsh
```

In Powershell, instead of the above, run this:
```bash
cd "$HOME/.vmodules/sdl"
v run windows_install_dependencies.vsh
```

This will create a directory called "thirdparty" which will be used to download and
extract the required libraries. To successfully run a provided example or your own projects,
the sdl dlls must be copied to the main application directory. e.g.:
```bash
copy thirdparty\SDL2-2.28.0\lib\x64\SDL2.dll examples\basic_window\
cd ..
v run sdl\examples\basic_window\main.v
```

## Contributions

- nsauzede
- spytheman
- adlesh
- Larpon
