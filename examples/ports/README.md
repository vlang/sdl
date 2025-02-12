# README

The examples in this directory are the [official SDL3 examples](https://examples.libsdl.org/SDL3/)
ported from C source code to V source code.

To compile and run the examples you need to pass `-d sdl_callbacks` to
the V compiler when building. Not doing so can end up with a build output similar to the
following:
```
error: function `main` must be declared in the main module
```
The first renderer example (`renderer/01-clear`) has comments containing the original ported C source lines
above the corresponding V code to help clarify how the C source is ported.
Other examples may only have the original C source *comments*.

Comments are preserved for educational purposes and to aid port navigation.

# Why/how the examples/ports work without a `fn main() {}` in V

The examples in this directory (and likely more SDL3 based V apps)
has `module no_main` and no `fn main() {}` definition, but can still compile and run.

This is only possible if the programmer builds with the flags `-d sdl_callbacks`.
The programmer also need to implement 4 special functions and `@[export]` them with special names:

```v
// Omitted fn main() {}, instead:

module no_main

@[export: 'v_sdl_app_init'] // Exported name(s) have significant importance
pub fn app_init(appstate &voidptr, argc int, argv &&char) sdl.AppResult {}

@[export: 'v_sdl_app_event'] // Exported name(s) have significant importance
pub fn app_event(appstate voidptr, event &sdl.Event) sdl.AppResult {}

@[export: 'v_sdl_app_iterate'] // Exported name(s) have significant importance
pub fn app_iterate(appstate voidptr) sdl.AppResult {}

@[export: 'v_sdl_app_quit'] // Exported name(s) have significant importance
pub fn app_quit(appstate voidptr, result sdl.AppResult) {}
```

The reason this magic works is because of `module no_main` and [a C shim](https://github.com/vlang/sdl/blob/3.2.0/c/sdl_main_use_callbacks_shim.h)
that makes it possible to use SDL3's implementation of the *main-loop control inversion* scheme
(aka. callbacks for program initialization, main loop, events (blocking code) and quit/cleanup).
More and more platforms promote and make use of this scheme, whether people like it or not.

The example `v-sdl-no-main` is a commented example that try to explain how the code
needs to be structured for `SDL_MAIN_USE_CALLBACKS` to work in V.

SDL3 has chosen to support the *main-loop control inversion* and make it
a first-class citizen in SDL3. The official SDL3 examples, written in C,
use the mentioned callback scheme, so to help ease and understand better the
V equivalents in `examples/ports`, `vlang/sdl` show how it is possible
to use this more magic, implicit and somewhat awkward code setup to build
and run SDL3 applications coded using the scheme.

Read more about SDL3's handling of the `main` function here:
[https://wiki.libsdl.org/SDL3/README/main-functions](https://wiki.libsdl.org/SDL3/README/main-functions)
[https://wiki.libsdl.org/SDL3/SDL_MAIN_USE_CALLBACKS](https://wiki.libsdl.org/SDL3/SDL_MAIN_USE_CALLBACKS)
... and more about the initial reasoning here:
[https://github.com/libsdl-org/SDL/issues/6785](https://github.com/libsdl-org/SDL/issues/6785)

It is utilized in these V ports to ease the porting of SDL3 examples
and apps to V, since this is what SDL3 promote as their
recommended way of doing SDL3 applications.
