# sdl

`sdl` is a SDL3 V module and a wrapper around [libSDL3](https://www.libsdl.org/).

The module strives to support 100% of the SDL3 API.

So, among many other things, you can:
- Open windows and accelerated rendering contexts
- Render 2D graphics
- Handle input events from keyboards, touches, mice, gamepads and joysticks
- Play audio, sound effects and music

## Install

To use `vlang/sdl` you need SDL3 libraries installed and the corresponding
`vlang/sdl` *branch* checked out that *matches the SDL3 version installed* on the target system.

See [Dependencies](#Dependencies) section below for how to install SDL3
for different OSes and systems.

If you have SDL3 installed on your system you can simply do:
```bash
v install sdl
v ~/.vmodules/sdl/setup.vsh
```

If you want to use another version of SDL3 you will, currently, have to install
it via `git` or by manual download.

An example of installing the system provided version of SDL3 via `git`:
```bash
git clone https://github.com/vlang/sdl.git ~/.vmodules/sdl
v ~/.vmodules/sdl/setup.vsh
```

Should `pkg-config` be absent on your system you can try the following instead,
by providing the version manually:

An example of installing the `3.2.0` branch (that *matches* SDL3 version 3.2.0) via `git`:
```bash
git clone https://github.com/vlang/sdl.git ~/.vmodules/sdl
cd ~/.vmodules/sdl
git checkout 3.2.0
```
and for Windows:
```bash
git clone https://github.com/vlang/sdl.git %HOMEPATH%/.vmodules/sdl
cd %HOMEPATH%/.vmodules/sdl
git checkout 3.2.0
```
Then follow the steps in the [Windows](#windows) section below.

You can see what `sdl` releases are available in the [GitHub repository](https://github.com/vlang/sdl/branches) via branches.

## Notes

### Versions

SDL3 `v3.2.0` is currently the lowest version of SDL3 supported.
SDL3 is backwards compatible - so anything written against `v3.2.0` can be compiled and run
against *newer* versions of the SDL3 library.

Also note that SDL3 **is not** compatible with SDL `v1.x` or `2.x` directly.

You can run SDL2 code using SDL3 libraries through the `sdl2_compat` support layer.
You can read more about this compatibility in regards to V in the
[2.x branches README.md](https://github.com/vlang/sdl/blob/2.30.0/README.md#version-notes).

### Using SDL3 `SDL_App*` callbacks (and running *some* examples)

To use SDL3's *main-loop control inversion* / callback setup via
`SDL_MAIN_USE_CALLBACKS`. You will need to `@[export]` 4 specially named
functions and compile the code with `-d sdl_callbacks`.

The examples in `examples/ports/*` all require the build flags
`-d sdl_callbacks` to function as intended without a main function.

The examples *outside* the `ports` folder can be run normally.

Whether or not you want to use the "no main" approach for your own apps
is up to you. V supports both ways for building SDL3 applications.

Read more about the no main, callbacks and reasons in `examples/ports/README.md`(examples/ports/README.md).

### Notes on garbage collection and memory issues

Currently, with some setups, SDL3 is known to trigger crashes when used in conjunction
with V's default garbage collector. Because of this you have to explicitly **opt-in**
to use V's garbage collection with SDL3.

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

## Dependencies

### Linux

#### Arch
```bash
sudo pacman -S sdl3
```

### MacOS

#### Brew
```bash
brew install sdl3
```

### Windows

It is necessary to install the SDL3 development libraries for Windows.
To do this, change to the root directory of the sdl module, like
`cd %HOMEPATH%\.vmodules\sdl`
and run
`v run windows_install_dependencies.vsh`.
This will create a directory called "thirdparty" which will be used to download and
extract the required libraries. To successfully run a provided example or your own projects,
the sdl dlls must be copied to the main application directory. e.g.:
```bash
copy thirdparty\SDL3-3.2.0\lib\x64\SDL3.dll examples\basic_window\
cd ..
v run sdl\examples\basic_window\main.v
```

### All, from source

SDL3 can be built from source on all supported platforms
(some easier that others). See [SDL3's documentation for more info
on building and installing from source](https://github.com/libsdl-org/SDL/blob/main/docs/README-cmake.md)
