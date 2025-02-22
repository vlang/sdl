#include <SDL3/SDL_main.h>

// See also `sdl_main_use_callbacks_preinclude.h`.
// See also `sdl_main_use_callbacks_postinclude.h`.
//
// These are the default functions, that will be called, when the app does not define any override.
// They do nothing, they just simplify the logic in the actual SDL handlers.
// See also `sdl_main_use_callbacks_shim.h`
SDL_AppResult nop_sdl_app_init(void    **appstate, int argc, char *argv[]) { return SDL_APP_CONTINUE; }
void          nop_sdl_app_quit(void     *appstate, SDL_AppResult result)   {};
SDL_AppResult nop_sdl_app_event(void    *appstate, SDL_Event *event)       {
   	if(event->type == SDL_EVENT_QUIT) {
		return SDL_APP_SUCCESS; // end the program, reporting success to the OS.
	}
	return SDL_APP_CONTINUE;
}
SDL_AppResult nop_sdl_app_iterate(void  *appstate)                         { return SDL_APP_CONTINUE; }

// These callbacks should be changed, when the app wants to override something:
SDL_AppResult (*g_sdl_app_init)(void   **appstate, int argc, char *argv[]) = nop_sdl_app_init;
void          (*g_sdl_app_quit)(void    *appstate, SDL_AppResult result)   = nop_sdl_app_quit;
SDL_AppResult (*g_sdl_app_event)(void   *appstate, SDL_Event *event)       = nop_sdl_app_event;
SDL_AppResult (*g_sdl_app_iterate)(void *appstate)                         = nop_sdl_app_iterate;

