# README

The examples in this directory are the 
[official SDL3 examples](https://examples.libsdl.org/SDL3/) ported from C
source code to V source code.

The first renderer example (`renderer/01-clear`) has comments containing the
original ported C source lines above the corresponding V code to help clarify
how the C source is ported. Other examples may only have the original C
source *comments*.

Comments are preserved for educational purposes and to aid port navigation.

## Why/how the examples/ports work without a `fn main() {}` in V

The examples in this directory (and likely more SDL3 based V apps)
has `module no_main` and no `fn main() {}` definition, but can still compile
and run.

This is only possible, if the program imports `sdl.callbacks`, which does the
necessary callback setup for SDL3 specifically.

```v oksyntax
// Note, there is no `fn main() {}`, here, but instead:
module no_main

import sdl
import sdl.callbacks

fn init() {
	callbacks.on_init(app_init)
	callbacks.on_quit(app_quit)
	callbacks.on_event(app_event)
	callbacks.on_iterate(app_iterate)
}

fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {}

fn app_quit(appstate voidptr, result sdl.AppResult) {}

fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {}

fn app_iterate(appstate voidptr) sdl.AppResult {}
```

The reason this magic works is because of `module no_main` in
combination with [a C shim](https://github.com/vlang/sdl/blob/3.2.0/c/sdl_main_use_callbacks_postinclude.h)
that makes it possible to use SDL3's implementation of the 
*main-loop control inversion* scheme (aka. callbacks for program 
initialization, main loop, events (blocking code) and quit/cleanup).
More and more platforms promote and make use of this scheme, whether
people like it or not.

The example `examples/ports/template..` is a commented example that
illustrate how the code needs to be written for `SDL_MAIN_USE_CALLBACKS`
to work in V.

SDL3 has chosen to support the *main-loop control inversion* and make it a
first-class citizen in SDL3. The official SDL3 examples, written in C, use
the mentioned callback scheme, so to help ease and understand better the V
equivalents in `examples/ports`, `vlang/sdl` show how it is possible to use
this more magic, implicit and somewhat awkward code setup to build and run
SDL3 applications coded using the scheme.

Read more about SDL3's handling of the `main` function here:
[https://wiki.libsdl.org/SDL3/README/main-functions](https://wiki.libsdl.org/SDL3/README/main-functions)
[https://wiki.libsdl.org/SDL3/SDL_MAIN_USE_CALLBACKS](https://wiki.libsdl.org/SDL3/SDL_MAIN_USE_CALLBACKS)
... and more about the initial reasoning here:
[https://github.com/libsdl-org/SDL/issues/6785](https://github.com/libsdl-org/SDL/issues/6785)

It is utilized in these V ports to ease the porting of SDL3 examples and apps
to V, since this is what SDL3 promote as their recommended way of doing SDL3
applications.