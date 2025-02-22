// See also `sdl_main_use_callbacks_preinclude.h`.
// See also `sdl_main_use_callbacks_include.h`.
// 
// This is a C shim to make it possible to use SDL3's implementation
// of the main-loop control inversion that more and more
// platforms promote and use (callbacks for program init,loop,event/block,quit).
// NOTE: Read more about the setup and reasons for this in `examples/ports/README.md`.
		   
SDL_AppResult SDL_AppInit(void **appstate, int argc, char *argv[]) {
	g_main_argc = argc;
	g_main_argv = argv;
	# if defined(_VGCBOEHM)
		GC_set_pages_executable(0);
		GC_INIT();
	#endif
	_vinit(argc, argv);
	return g_sdl_app_init(appstate, argc, argv);
}

void SDL_AppQuit(void *appstate, SDL_AppResult result) {
	g_sdl_app_quit(appstate, result);
	_vcleanup();
}

SDL_AppResult SDL_AppEvent(void *appstate, SDL_Event *event) {
	return g_sdl_app_event(appstate, event);
}

SDL_AppResult SDL_AppIterate(void *appstate) {  
	return g_sdl_app_iterate(appstate);
}
