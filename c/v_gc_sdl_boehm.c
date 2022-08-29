void* V_GC_SDL_calloc(size_t n, size_t size) {
	#if defined(_VGCBOEHM)
	{
		size_t msize = n * size;
		return memset(GC_MALLOC(msize), 0, msize);
	}
	#endif
	return 0;
}
