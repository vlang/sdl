module image
import sdl

type Vec8Char = [8]u8
type Vec4Short = [4]i16
type Vec2Int = [2]int
type Vec1LongLong = [1]i64
type Vec4Float = [4]f32
type Vec2Double = [2]f64
type Vec16Char = [16]u8
type Vec4Int = [4]int
type Vec2LongLong = [2]i64


type Sint8 = u8
type Uint8 = u8
type Sint16 = i16
type Uint16 = u16
type Sint32 = int
type Uint32 = u32
type Sint64 = i64
type Uint64 = u64
type SDL_Time = i64
struct SDL_alignment_test { 
	a Uint8
	b voidptr
}
enum SDL_DUMMY_ENUM {
	dummy_enum_value
}
type SDL_malloc_func = fn (usize) voidptr
type SDL_calloc_func = fn (usize, usize) voidptr
type SDL_realloc_func = fn (voidptr, usize) voidptr
type SDL_free_func = fn (voidptr)
type SDL_CompareCallback = fn (voidptr, voidptr) int
type SDL_CompareCallback_r = fn (voidptr, voidptr, voidptr) int
fn C.SDL_fabsf(x f32) f32
pub fn sdl_fabsf(x f32) f32 {
	return C.SDL_fabsf(x)
}
type SDL_iconv_t = voidptr
type SDL_FunctionPointer = fn ()
enum SDL_AssertState {
	
	sdl_assertion_retry
	sdl_assertion_break
	sdl_assertion_abort
	sdl_assertion_ignore
	sdl_assertion_always_ignore
	
}
struct SDL_AssertData { 
	always_ignore bool
	trigger_count u32
	condition &i8
	filename &i8
	linenum int
	function &i8
	next &SDL_AssertData
}
type SDL_AssertionHandler = fn (&SDL_AssertData, voidptr) SDL_AssertState
enum SDL_AsyncIOTaskType {
	
	sdl_asyncio_task_read
	sdl_asyncio_task_write
	sdl_asyncio_task_close
	
}
enum SDL_AsyncIOResult {
	
	sdl_asyncio_complete
	sdl_asyncio_failure
	sdl_asyncio_canceled
	
}
struct SDL_AsyncIOOutcome { 
	asyncio &sdl.AsyncIO
	type_ SDL_AsyncIOTaskType
	result SDL_AsyncIOResult
	buffer voidptr
	offset Uint64
	bytes_requested Uint64
	bytes_transferred Uint64
	userdata voidptr
}
type SDL_SpinLock = int
struct SDL_AtomicInt { 
	value int
}
struct SDL_AtomicU32 { 
	value Uint32
}
@[c2v_variadic]
type Ptrdiff_t = i64
type Size_t = i64
type Wchar_t = u16
type Max_align_t = f64
fn C._BitScanReverse(arg0 &u32, arg1 u32) u8
pub fn bit_scan_reverse(arg0 &u32, arg1 u32) u8 {
	return C._BitScanReverse(arg0, arg1)
}
type SDL_PropertiesID = u32
enum SDL_PropertyType {
	
	sdl_property_type_invalid
	sdl_property_type_pointer
	sdl_property_type_string
	sdl_property_type_number
	sdl_property_type_float
	sdl_property_type_boolean
}
type SDL_CleanupPropertyCallback = fn (voidptr, voidptr)
type SDL_EnumeratePropertiesCallback = fn (voidptr, SDL_PropertiesID, &i8)
type SDL_ThreadID = u64
type SDL_TLSID = SDL_AtomicInt
enum SDL_ThreadPriority {
	
	sdl_thread_priority_low
	sdl_thread_priority_normal
	sdl_thread_priority_high
	sdl_thread_priority_time_critical
}
enum SDL_ThreadState {
	
	sdl_thread_unknown
	sdl_thread_alive
	sdl_thread_detached
	sdl_thread_complete
	
}
type SDL_ThreadFunction = fn (voidptr) int
type SDL_TLSDestructorCallback = fn (voidptr)
enum SDL_InitStatus {
	
	sdl_init_status_uninitialized
	sdl_init_status_initializing
	sdl_init_status_initialized
	sdl_init_status_uninitializing
}
struct SDL_InitState { 
	status SDL_AtomicInt
	thread_ SDL_ThreadID
	reserved voidptr
}
enum SDL_IOStatus {
	
	sdl_io_status_ready
	sdl_io_status_error
	sdl_io_status_eof
	sdl_io_status_not_ready
	sdl_io_status_readonly
	sdl_io_status_writeonly
	
}
enum SDL_IOWhence {
	
	sdl_io_seek_set
	sdl_io_seek_cur
	sdl_io_seek_end
	
}
struct SDL_IOStreamInterface { 
	version Uint32
	size ?fn (voidptr) Sint64
	seek ?fn (voidptr, Sint64, SDL_IOWhence) Sint64
	read ?fn (voidptr, voidptr, usize, &SDL_IOStatus) usize
	write ?fn (voidptr, voidptr, usize, &SDL_IOStatus) usize
	flush ?fn (voidptr, &SDL_IOStatus) bool
	close ?fn (voidptr) bool
}
enum SDL_AudioFormat {
	
	sdl_audio_unknown
	sdl_audio_u8
	sdl_audio_s8
	sdl_audio_s16_le
	sdl_audio_s16_be
	sdl_audio_s32_le
	sdl_audio_s32_be
	sdl_audio_f32_le
	sdl_audio_f32_be
	sdl_audio_s16 //= sdl_audio_s16_le
	sdl_audio_s32 //= sdl_audio_s32_le
	sdl_audio_f32 //= sdl_audio_f32_le
}
type SDL_AudioDeviceID = u32
struct SDL_AudioSpec { 
	format SDL_AudioFormat
	channels int
	freq int
}
type SDL_AudioStreamCallback = fn (voidptr, &sdl.AudioStream, int, int)
type SDL_AudioPostmixCallback = fn (voidptr, &SDL_AudioSpec, &f32, int)
type SDL_BlendMode = u32
enum SDL_BlendOperation {
	
	sdl_blendoperation_add = 1
	sdl_blendoperation_subtract = 2
	sdl_blendoperation_rev_subtract = 3
	sdl_blendoperation_minimum = 4
	sdl_blendoperation_maximum = 5
	
}
enum SDL_BlendFactor {
	
	sdl_blendfactor_zero = 1
	sdl_blendfactor_one = 2
	sdl_blendfactor_src_color = 3
	sdl_blendfactor_one_minus_src_color = 4
	sdl_blendfactor_src_alpha = 5
	sdl_blendfactor_one_minus_src_alpha = 6
	sdl_blendfactor_dst_color = 7
	sdl_blendfactor_one_minus_dst_color = 8
	sdl_blendfactor_dst_alpha = 9
	sdl_blendfactor_one_minus_dst_alpha = 10
	
}
enum SDL_PixelType {
	
	sdl_pixeltype_unknown
	sdl_pixeltype_index_1
	sdl_pixeltype_index_4
	sdl_pixeltype_index_8
	sdl_pixeltype_packed_8
	sdl_pixeltype_packed_16
	sdl_pixeltype_packed_32
	sdl_pixeltype_arrayu_8
	sdl_pixeltype_arrayu_16
	sdl_pixeltype_arrayu_32
	sdl_pixeltype_arrayf_16
	sdl_pixeltype_arrayf_32
	sdl_pixeltype_index_2
}
enum SDL_BitmapOrder {
	
	sdl_bitmaporder_none
	sdl_bitmaporder_4321
	sdl_bitmaporder_1234
}
enum SDL_PackedOrder {
	
	sdl_packedorder_none
	sdl_packedorder_xrgb
	sdl_packedorder_rgbx
	sdl_packedorder_argb
	sdl_packedorder_rgba
	sdl_packedorder_xbgr
	sdl_packedorder_bgrx
	sdl_packedorder_abgr
	sdl_packedorder_bgra
}
enum SDL_ArrayOrder {
	
	sdl_arrayorder_none
	sdl_arrayorder_rgb
	sdl_arrayorder_rgba
	sdl_arrayorder_argb
	sdl_arrayorder_bgr
	sdl_arrayorder_bgra
	sdl_arrayorder_abgr
}
enum SDL_PackedLayout {
	
	sdl_packedlayout_none
	sdl_packedlayout_332
	sdl_packedlayout_4444
	sdl_packedlayout_1555
	sdl_packedlayout_5551
	sdl_packedlayout_565
	sdl_packedlayout_8888
	sdl_packedlayout_2101010
	sdl_packedlayout_1010102
}

enum SDL_ColorType {
	
	sdl_color_type_unknown = 0
	sdl_color_type_rgb = 1
	sdl_color_type_ycbcr = 2
}
enum SDL_ColorRange {
	
	sdl_color_range_unknown = 0
	sdl_color_range_limited = 1
	sdl_color_range_full = 2
	
}
enum SDL_ColorPrimaries {
	
	sdl_color_primaries_unknown = 0
	sdl_color_primaries_bt_709 = 1
	sdl_color_primaries_unspecified = 2
	sdl_color_primaries_bt_470_m = 4
	sdl_color_primaries_bt_470_bg = 5
	sdl_color_primaries_bt_601 = 6
	sdl_color_primaries_smpte_240 = 7
	sdl_color_primaries_generic_film = 8
	sdl_color_primaries_bt_2020 = 9
	sdl_color_primaries_xyz = 10
	sdl_color_primaries_smpte_431 = 11
	sdl_color_primaries_smpte_432 = 12
	sdl_color_primaries_ebu_3213 = 22
	sdl_color_primaries_custom = 31
}
enum SDL_TransferCharacteristics {
	
	sdl_transfer_characteristics_unknown = 0
	sdl_transfer_characteristics_bt_709 = 1
	sdl_transfer_characteristics_unspecified = 2
	sdl_transfer_characteristics_gamma_22 = 4
	sdl_transfer_characteristics_gamma_28 = 5
	sdl_transfer_characteristics_bt_601 = 6
	sdl_transfer_characteristics_smpte_240 = 7
	sdl_transfer_characteristics_linear = 8
	sdl_transfer_characteristics_log_100 = 9
	sdl_transfer_characteristics_log_100_sqrt_10 = 10
	sdl_transfer_characteristics_iec_61966 = 11
	sdl_transfer_characteristics_bt_1361 = 12
	sdl_transfer_characteristics_srgb = 13
	sdl_transfer_characteristics_bt_2020_10_bit = 14
	sdl_transfer_characteristics_bt_2020_12_bit = 15
	sdl_transfer_characteristics_pq = 16
	sdl_transfer_characteristics_smpte_428 = 17
	sdl_transfer_characteristics_hlg = 18
	sdl_transfer_characteristics_custom = 31
}
enum SDL_MatrixCoefficients {
	
	sdl_matrix_coefficients_identity = 0
	sdl_matrix_coefficients_bt_709 = 1
	sdl_matrix_coefficients_unspecified = 2
	sdl_matrix_coefficients_fcc = 4
	sdl_matrix_coefficients_bt_470_bg = 5
	sdl_matrix_coefficients_bt_601 = 6
	sdl_matrix_coefficients_smpte_240 = 7
	sdl_matrix_coefficients_ycgco = 8
	sdl_matrix_coefficients_bt_2020_ncl = 9
	sdl_matrix_coefficients_bt_2020_cl = 10
	sdl_matrix_coefficients_smpte_2085 = 11
	sdl_matrix_coefficients_chroma_derived_ncl = 12
	sdl_matrix_coefficients_chroma_derived_cl = 13
	sdl_matrix_coefficients_ictcp = 14
	sdl_matrix_coefficients_custom = 31
}
enum SDL_ChromaLocation {
	
	sdl_chroma_location_none = 0
	sdl_chroma_location_left = 1
	sdl_chroma_location_center = 2
	sdl_chroma_location_topleft = 3
	
}

struct SDL_Color { 
	r Uint8
	g Uint8
	b Uint8
	a Uint8
}
struct SDL_FColor { 
	r f32
	g f32
	b f32
	a f32
}
struct SDL_Palette { 
	ncolors int
	colors &SDL_Color
	version Uint32
	refcount int
}
struct SDL_PixelFormatDetails { 
	format sdl.PixelFormat
	bits_per_pixel Uint8
	bytes_per_pixel Uint8
	padding [2]Uint8
	rmask Uint32
	gmask Uint32
	bmask Uint32
	amask Uint32
	rbits Uint8
	gbits Uint8
	bbits Uint8
	abits Uint8
	rshift Uint8
	gshift Uint8
	bshift Uint8
	ashift Uint8
}
struct SDL_Point { 
	x int
	y int
}
struct SDL_FPoint { 
	x f32
	y f32
}
struct SDL_Rect { 
	x int
	y int
	w int
	h int
}
struct SDL_FRect { 
	x f32
	y f32
	w f32
	h f32
}
fn C.SDL_RectsEqualEpsilon(a &SDL_FRect, b &SDL_FRect, epsilon f32) bool
pub fn sdl_rects_equal_epsilon(a &SDL_FRect, b &SDL_FRect, epsilon f32) bool {
	return C.SDL_RectsEqualEpsilon(a, b, epsilon)
}
type SDL_SurfaceFlags = u32
enum SDL_ScaleMode {
	
	sdl_scalemode_invalid = -1
	sdl_scalemode_nearest
	sdl_scalemode_linear
	
}
enum SDL_FlipMode {
	
	sdl_flip_none
	sdl_flip_horizontal
	sdl_flip_vertical
	
}
type SDL_GLContext = voidptr
type SDL_EGLDisplay = voidptr
type SDL_EGLConfig = voidptr
type SDL_EGLSurface = voidptr
type SDL_EGLAttrib = voidptr
type SDL_EGLint = int
type SDL_EGLAttribArrayCallback = fn (voidptr) &SDL_EGLAttrib
type SDL_EGLIntArrayCallback = fn (voidptr, SDL_EGLDisplay, SDL_EGLConfig) &SDL_EGLint
enum SDL_GLAttr {
	
	sdl_gl_red_size
	sdl_gl_green_size
	sdl_gl_blue_size
	sdl_gl_alpha_size
	sdl_gl_buffer_size
	sdl_gl_doublebuffer
	sdl_gl_depth_size
	sdl_gl_stencil_size
	sdl_gl_accum_red_size
	sdl_gl_accum_green_size
	sdl_gl_accum_blue_size
	sdl_gl_accum_alpha_size
	sdl_gl_stereo
	sdl_gl_multisamplebuffers
	sdl_gl_multisamplesamples
	sdl_gl_accelerated_visual
	sdl_gl_retained_backing
	sdl_gl_context_major_version
	sdl_gl_context_minor_version
	sdl_gl_context_flags
	sdl_gl_context_profile_mask
	sdl_gl_share_with_current_context
	sdl_gl_framebuffer_srgb_capable
	sdl_gl_context_release_behavior
	sdl_gl_context_reset_notification
	sdl_gl_context_no_error
	sdl_gl_floatbuffers
	sdl_gl_egl_platform
}
type SDL_GLProfile = u32
type SDL_GLContextFlag = u32
type SDL_GLContextReleaseFlag = u32
type SDL_GLContextResetNotification = u32
enum SDL_HitTestResult {
	
	sdl_hittest_normal
	sdl_hittest_draggable
	sdl_hittest_resize_topleft
	sdl_hittest_resize_top
	sdl_hittest_resize_topright
	sdl_hittest_resize_right
	sdl_hittest_resize_bottomright
	sdl_hittest_resize_bottom
	sdl_hittest_resize_bottomleft
	sdl_hittest_resize_left
	
}
struct SDL_DialogFileFilter { 
	name &i8
	pattern &i8
}
type SDL_DialogFileCallback = fn (voidptr, &&i8, int)
enum SDL_FileDialogType {
	
	sdl_filedialog_openfile
	sdl_filedialog_savefile
	sdl_filedialog_openfolder
}
struct SDL_GUID { 
	data [16]Uint8
}
enum SDL_PowerState {
	
	sdl_powerstate_error = -1
	sdl_powerstate_unknown
	sdl_powerstate_on_battery
	sdl_powerstate_no_battery
	sdl_powerstate_charging
	sdl_powerstate_charged
	
}
enum SDL_Capitalization {
	
	sdl_capitalize_none
	sdl_capitalize_sentences
	sdl_capitalize_words
	sdl_capitalize_letters
	
}
type SDL_MouseID = u32
enum SDL_SystemCursor {
	
	sdl_system_cursor_default
	sdl_system_cursor_text
	sdl_system_cursor_wait
	sdl_system_cursor_crosshair
	sdl_system_cursor_progress
	sdl_system_cursor_nwse_resize
	sdl_system_cursor_nesw_resize
	sdl_system_cursor_ew_resize
	sdl_system_cursor_ns_resize
	sdl_system_cursor_move
	sdl_system_cursor_not_allowed
	sdl_system_cursor_pointer
	sdl_system_cursor_nw_resize
	sdl_system_cursor_n_resize
	sdl_system_cursor_ne_resize
	sdl_system_cursor_e_resize
	sdl_system_cursor_se_resize
	sdl_system_cursor_s_resize
	sdl_system_cursor_sw_resize
	sdl_system_cursor_w_resize
	sdl_system_cursor_count
}
enum SDL_MouseWheelDirection {
	
	sdl_mousewheel_normal
	sdl_mousewheel_flipped
	
}
type SDL_MouseButtonFlags = u32
type SDL_TouchID = u64
type SDL_FingerID = u64
enum SDL_TouchDeviceType {
	
	sdl_touch_device_invalid = -1
	sdl_touch_device_direct
	sdl_touch_device_indirect_absolute
	sdl_touch_device_indirect_relative
	
}
struct SDL_Finger { 
	id SDL_FingerID
	x f32
	y f32
	pressure f32
}
type SDL_PenID = u32
type SDL_PenInputFlags = u32
enum SDL_PathType {
	
	sdl_pathtype_none
	sdl_pathtype_file
	sdl_pathtype_directory
	sdl_pathtype_other
	
}
struct SDL_PathInfo { 
	type_ SDL_PathType
	size Uint64
	create_time SDL_Time
	modify_time SDL_Time
	access_time SDL_Time
}
type SDL_GlobFlags = u32
enum SDL_EnumerationResult {
	
	sdl_enum_continue
	sdl_enum_success
	sdl_enum_failure
	
}
type SDL_EnumerateDirectoryCallback = fn (voidptr, &i8, &i8) SDL_EnumerationResult
enum SDL_GPUPrimitiveType {
	
	sdl_gpu_primitivetype_trianglelist
	sdl_gpu_primitivetype_trianglestrip
	sdl_gpu_primitivetype_linelist
	sdl_gpu_primitivetype_linestrip
	sdl_gpu_primitivetype_pointlist
	
}
enum SDL_GPULoadOp {
	
	sdl_gpu_loadop_load
	sdl_gpu_loadop_clear
	sdl_gpu_loadop_dont_care
	
}
enum SDL_GPUStoreOp {
	
	sdl_gpu_storeop_store
	sdl_gpu_storeop_dont_care
	sdl_gpu_storeop_resolve
	sdl_gpu_storeop_resolve_and_store
	
}
enum SDL_GPUIndexElementSize {
	
	sdl_gpu_indexelementsize_16_bit
	sdl_gpu_indexelementsize_32_bit
	
}
enum SDL_GPUTextureFormat {
	
	sdl_gpu_textureformat_invalid
	sdl_gpu_textureformat_a8_unorm
	sdl_gpu_textureformat_r8_unorm
	sdl_gpu_textureformat_r8_g8_unorm
	sdl_gpu_textureformat_r8_g8_b8_a8_unorm
	sdl_gpu_textureformat_r16_unorm
	sdl_gpu_textureformat_r16_g16_unorm
	sdl_gpu_textureformat_r16_g16_b16_a16_unorm
	sdl_gpu_textureformat_r10_g10_b10_a2_unorm
	sdl_gpu_textureformat_b5_g6_r5_unorm
	sdl_gpu_textureformat_b5_g5_r5_a1_unorm
	sdl_gpu_textureformat_b4_g4_r4_a4_unorm
	sdl_gpu_textureformat_b8_g8_r8_a8_unorm
	sdl_gpu_textureformat_bc_1_rgba_unorm
	sdl_gpu_textureformat_bc_2_rgba_unorm
	sdl_gpu_textureformat_bc_3_rgba_unorm
	sdl_gpu_textureformat_bc_4_r_unorm
	sdl_gpu_textureformat_bc_5_rg_unorm
	sdl_gpu_textureformat_bc_7_rgba_unorm
	sdl_gpu_textureformat_bc_6_h_rgb_float
	sdl_gpu_textureformat_bc_6_h_rgb_ufloat
	sdl_gpu_textureformat_r8_snorm
	sdl_gpu_textureformat_r8_g8_snorm
	sdl_gpu_textureformat_r8_g8_b8_a8_snorm
	sdl_gpu_textureformat_r16_snorm
	sdl_gpu_textureformat_r16_g16_snorm
	sdl_gpu_textureformat_r16_g16_b16_a16_snorm
	sdl_gpu_textureformat_r16_float
	sdl_gpu_textureformat_r16_g16_float
	sdl_gpu_textureformat_r16_g16_b16_a16_float
	sdl_gpu_textureformat_r32_float
	sdl_gpu_textureformat_r32_g32_float
	sdl_gpu_textureformat_r32_g32_b32_a32_float
	sdl_gpu_textureformat_r11_g11_b10_ufloat
	sdl_gpu_textureformat_r8_uint
	sdl_gpu_textureformat_r8_g8_uint
	sdl_gpu_textureformat_r8_g8_b8_a8_uint
	sdl_gpu_textureformat_r16_uint
	sdl_gpu_textureformat_r16_g16_uint
	sdl_gpu_textureformat_r16_g16_b16_a16_uint
	sdl_gpu_textureformat_r32_uint
	sdl_gpu_textureformat_r32_g32_uint
	sdl_gpu_textureformat_r32_g32_b32_a32_uint
	sdl_gpu_textureformat_r8_int
	sdl_gpu_textureformat_r8_g8_int
	sdl_gpu_textureformat_r8_g8_b8_a8_int
	sdl_gpu_textureformat_r16_int
	sdl_gpu_textureformat_r16_g16_int
	sdl_gpu_textureformat_r16_g16_b16_a16_int
	sdl_gpu_textureformat_r32_int
	sdl_gpu_textureformat_r32_g32_int
	sdl_gpu_textureformat_r32_g32_b32_a32_int
	sdl_gpu_textureformat_r8_g8_b8_a8_unorm_srgb
	sdl_gpu_textureformat_b8_g8_r8_a8_unorm_srgb
	sdl_gpu_textureformat_bc_1_rgba_unorm_srgb
	sdl_gpu_textureformat_bc_2_rgba_unorm_srgb
	sdl_gpu_textureformat_bc_3_rgba_unorm_srgb
	sdl_gpu_textureformat_bc_7_rgba_unorm_srgb
	sdl_gpu_textureformat_d16_unorm
	sdl_gpu_textureformat_d24_unorm
	sdl_gpu_textureformat_d32_float
	sdl_gpu_textureformat_d24_unorm_s8_uint
	sdl_gpu_textureformat_d32_float_s8_uint
	sdl_gpu_textureformat_astc_4x4_unorm
	sdl_gpu_textureformat_astc_5x4_unorm
	sdl_gpu_textureformat_astc_5x5_unorm
	sdl_gpu_textureformat_astc_6x5_unorm
	sdl_gpu_textureformat_astc_6x6_unorm
	sdl_gpu_textureformat_astc_8x5_unorm
	sdl_gpu_textureformat_astc_8x6_unorm
	sdl_gpu_textureformat_astc_8x8_unorm
	sdl_gpu_textureformat_astc_10x5_unorm
	sdl_gpu_textureformat_astc_10x6_unorm
	sdl_gpu_textureformat_astc_10x8_unorm
	sdl_gpu_textureformat_astc_10x10_unorm
	sdl_gpu_textureformat_astc_12x10_unorm
	sdl_gpu_textureformat_astc_12x12_unorm
	sdl_gpu_textureformat_astc_4x4_unorm_srgb
	sdl_gpu_textureformat_astc_5x4_unorm_srgb
	sdl_gpu_textureformat_astc_5x5_unorm_srgb
	sdl_gpu_textureformat_astc_6x5_unorm_srgb
	sdl_gpu_textureformat_astc_6x6_unorm_srgb
	sdl_gpu_textureformat_astc_8x5_unorm_srgb
	sdl_gpu_textureformat_astc_8x6_unorm_srgb
	sdl_gpu_textureformat_astc_8x8_unorm_srgb
	sdl_gpu_textureformat_astc_10x5_unorm_srgb
	sdl_gpu_textureformat_astc_10x6_unorm_srgb
	sdl_gpu_textureformat_astc_10x8_unorm_srgb
	sdl_gpu_textureformat_astc_10x10_unorm_srgb
	sdl_gpu_textureformat_astc_12x10_unorm_srgb
	sdl_gpu_textureformat_astc_12x12_unorm_srgb
	sdl_gpu_textureformat_astc_4x4_float
	sdl_gpu_textureformat_astc_5x4_float
	sdl_gpu_textureformat_astc_5x5_float
	sdl_gpu_textureformat_astc_6x5_float
	sdl_gpu_textureformat_astc_6x6_float
	sdl_gpu_textureformat_astc_8x5_float
	sdl_gpu_textureformat_astc_8x6_float
	sdl_gpu_textureformat_astc_8x8_float
	sdl_gpu_textureformat_astc_10x5_float
	sdl_gpu_textureformat_astc_10x6_float
	sdl_gpu_textureformat_astc_10x8_float
	sdl_gpu_textureformat_astc_10x10_float
	sdl_gpu_textureformat_astc_12x10_float
	sdl_gpu_textureformat_astc_12x12_float
}
type SDL_GPUTextureUsageFlags = u32
enum SDL_GPUTextureType {
	
	sdl_gpu_texturetype_2_d
	sdl_gpu_texturetype_2_d_array
	sdl_gpu_texturetype_3_d
	sdl_gpu_texturetype_cube
	sdl_gpu_texturetype_cube_array
	
}
enum SDL_GPUSampleCount {
	
	sdl_gpu_samplecount_1
	sdl_gpu_samplecount_2
	sdl_gpu_samplecount_4
	sdl_gpu_samplecount_8
	
}
enum SDL_GPUCubeMapFace {
	
	sdl_gpu_cubemapface_positivex
	sdl_gpu_cubemapface_negativex
	sdl_gpu_cubemapface_positivey
	sdl_gpu_cubemapface_negativey
	sdl_gpu_cubemapface_positivez
	sdl_gpu_cubemapface_negativez
}
type SDL_GPUBufferUsageFlags = u32
enum SDL_GPUTransferBufferUsage {
	
	sdl_gpu_transferbufferusage_upload
	sdl_gpu_transferbufferusage_download
}
enum SDL_GPUShaderStage {
	
	sdl_gpu_shaderstage_vertex
	sdl_gpu_shaderstage_fragment
}
type SDL_GPUShaderFormat = u32
enum SDL_GPUVertexElementFormat {
	
	sdl_gpu_vertexelementformat_invalid
	sdl_gpu_vertexelementformat_int
	sdl_gpu_vertexelementformat_int_2
	sdl_gpu_vertexelementformat_int_3
	sdl_gpu_vertexelementformat_int_4
	sdl_gpu_vertexelementformat_uint
	sdl_gpu_vertexelementformat_uint_2
	sdl_gpu_vertexelementformat_uint_3
	sdl_gpu_vertexelementformat_uint_4
	sdl_gpu_vertexelementformat_float
	sdl_gpu_vertexelementformat_float_2
	sdl_gpu_vertexelementformat_float_3
	sdl_gpu_vertexelementformat_float_4
	sdl_gpu_vertexelementformat_byte_2
	sdl_gpu_vertexelementformat_byte_4
	sdl_gpu_vertexelementformat_ubyte_2
	sdl_gpu_vertexelementformat_ubyte_4
	sdl_gpu_vertexelementformat_byte_2_norm
	sdl_gpu_vertexelementformat_byte_4_norm
	sdl_gpu_vertexelementformat_ubyte_2_norm
	sdl_gpu_vertexelementformat_ubyte_4_norm
	sdl_gpu_vertexelementformat_short_2
	sdl_gpu_vertexelementformat_short_4
	sdl_gpu_vertexelementformat_ushort_2
	sdl_gpu_vertexelementformat_ushort_4
	sdl_gpu_vertexelementformat_short_2_norm
	sdl_gpu_vertexelementformat_short_4_norm
	sdl_gpu_vertexelementformat_ushort_2_norm
	sdl_gpu_vertexelementformat_ushort_4_norm
	sdl_gpu_vertexelementformat_half_2
	sdl_gpu_vertexelementformat_half_4
}
enum SDL_GPUVertexInputRate {
	
	sdl_gpu_vertexinputrate_vertex
	sdl_gpu_vertexinputrate_instance
	
}
enum SDL_GPUFillMode {
	
	sdl_gpu_fillmode_fill
	sdl_gpu_fillmode_line
	
}
enum SDL_GPUCullMode {
	
	sdl_gpu_cullmode_none
	sdl_gpu_cullmode_front
	sdl_gpu_cullmode_back
	
}
enum SDL_GPUFrontFace {
	
	sdl_gpu_frontface_counter_clockwise
	sdl_gpu_frontface_clockwise
	
}
enum SDL_GPUCompareOp {
	
	sdl_gpu_compareop_invalid
	sdl_gpu_compareop_never
	sdl_gpu_compareop_less
	sdl_gpu_compareop_equal
	sdl_gpu_compareop_less_or_equal
	sdl_gpu_compareop_greater
	sdl_gpu_compareop_not_equal
	sdl_gpu_compareop_greater_or_equal
	sdl_gpu_compareop_always
	
}
enum SDL_GPUStencilOp {
	
	sdl_gpu_stencilop_invalid
	sdl_gpu_stencilop_keep
	sdl_gpu_stencilop_zero
	sdl_gpu_stencilop_replace
	sdl_gpu_stencilop_increment_and_clamp
	sdl_gpu_stencilop_decrement_and_clamp
	sdl_gpu_stencilop_invert
	sdl_gpu_stencilop_increment_and_wrap
	sdl_gpu_stencilop_decrement_and_wrap
	
}
enum SDL_GPUBlendOp {
	
	sdl_gpu_blendop_invalid
	sdl_gpu_blendop_add
	sdl_gpu_blendop_subtract
	sdl_gpu_blendop_reverse_subtract
	sdl_gpu_blendop_min
	sdl_gpu_blendop_max
	
}
enum SDL_GPUBlendFactor {
	
	sdl_gpu_blendfactor_invalid
	sdl_gpu_blendfactor_zero
	sdl_gpu_blendfactor_one
	sdl_gpu_blendfactor_src_color
	sdl_gpu_blendfactor_one_minus_src_color
	sdl_gpu_blendfactor_dst_color
	sdl_gpu_blendfactor_one_minus_dst_color
	sdl_gpu_blendfactor_src_alpha
	sdl_gpu_blendfactor_one_minus_src_alpha
	sdl_gpu_blendfactor_dst_alpha
	sdl_gpu_blendfactor_one_minus_dst_alpha
	sdl_gpu_blendfactor_constant_color
	sdl_gpu_blendfactor_one_minus_constant_color
	sdl_gpu_blendfactor_src_alpha_saturate
	
}
type SDL_GPUColorComponentFlags = u8
enum SDL_GPUFilter {
	
	sdl_gpu_filter_nearest
	sdl_gpu_filter_linear
	
}
enum SDL_GPUSamplerMipmapMode {
	
	sdl_gpu_samplermipmapmode_nearest
	sdl_gpu_samplermipmapmode_linear
	
}
enum SDL_GPUSamplerAddressMode {
	
	sdl_gpu_sampleraddressmode_repeat
	sdl_gpu_sampleraddressmode_mirrored_repeat
	sdl_gpu_sampleraddressmode_clamp_to_edge
	
}
enum SDL_GPUPresentMode {
	
	sdl_gpu_presentmode_vsync
	sdl_gpu_presentmode_immediate
	sdl_gpu_presentmode_mailbox
}
enum SDL_GPUSwapchainComposition {
	
	sdl_gpu_swapchaincomposition_sdr
	sdl_gpu_swapchaincomposition_sdr_linear
	sdl_gpu_swapchaincomposition_hdr_extended_linear
	sdl_gpu_swapchaincomposition_hdr_10_st_2084
}
struct SDL_GPUViewport { 
	x f32
	y f32
	w f32
	h f32
	min_depth f32
	max_depth f32
}
struct SDL_HapticDirection { 
	type_ Uint8
	dir [3]Sint32
}
struct SDL_HapticConstant { 
	type_ Uint16
	direction SDL_HapticDirection
	length Uint32
	delay Uint16
	button Uint16
	interval Uint16
	level Sint16
	attack_length Uint16
	attack_level Uint16
	fade_length Uint16
	fade_level Uint16
}
struct SDL_HapticPeriodic { 
	type_ Uint16
	direction SDL_HapticDirection
	length Uint32
	delay Uint16
	button Uint16
	interval Uint16
	period Uint16
	magnitude Sint16
	offset Sint16
	phase Uint16
	attack_length Uint16
	attack_level Uint16
	fade_length Uint16
	fade_level Uint16
}
struct SDL_HapticCondition { 
	type_ Uint16
	direction SDL_HapticDirection
	length Uint32
	delay Uint16
	button Uint16
	interval Uint16
	right_sat [3]Uint16
	left_sat [3]Uint16
	right_coeff [3]Sint16
	left_coeff [3]Sint16
	deadband [3]Uint16
	center [3]Sint16
}
struct SDL_HapticRamp { 
	type_ Uint16
	direction SDL_HapticDirection
	length Uint32
	delay Uint16
	button Uint16
	interval Uint16
	start Sint16
	end Sint16
	attack_length Uint16
	attack_level Uint16
	fade_length Uint16
	fade_level Uint16
}
struct SDL_HapticLeftRight { 
	type_ Uint16
	length Uint32
	large_magnitude Uint16
	small_magnitude Uint16
}
struct SDL_HapticCustom { 
	type_ Uint16
	direction SDL_HapticDirection
	length Uint32
	delay Uint16
	button Uint16
	interval Uint16
	channels Uint8
	period Uint16
	samples Uint16
	data &Uint16
	attack_length Uint16
	attack_level Uint16
	fade_length Uint16
	fade_level Uint16
}
union SDL_HapticEffect { 
	type_ Uint16
	constant SDL_HapticConstant
	periodic SDL_HapticPeriodic
	condition SDL_HapticCondition
	ramp SDL_HapticRamp
	leftright SDL_HapticLeftRight
	custom SDL_HapticCustom
}
type SDL_HapticID = u32
enum SDL_hid_bus_type {
	
	sdl_hid_api_bus_unknown = 0
	sdl_hid_api_bus_usb = 1
	sdl_hid_api_bus_bluetooth = 2
	sdl_hid_api_bus_i2_c = 3
	sdl_hid_api_bus_spi = 4
}
struct SDL_hid_device_info { 
	path &i8
	vendor_id u16
	product_id u16
	serial_number &Wchar_t
	release_number u16
	manufacturer_string &Wchar_t
	product_string &Wchar_t
	usage_page u16
	usage u16
	interface_number int
	interface_class int
	interface_subclass int
	interface_protocol int
	bus_type SDL_hid_bus_type
	next &SDL_hid_device_info
}
enum SDL_HintPriority {
	
	sdl_hint_default
	sdl_hint_normal
	sdl_hint_override
}
type SDL_HintCallback = fn (voidptr, &i8, &i8, &i8)
type SDL_InitFlags = u32
enum SDL_AppResult {
	
	sdl_app_continue
	sdl_app_success
	sdl_app_failure
	
}
type SDL_MainThreadCallback = fn (voidptr)
struct SDL_Locale { 
	language &i8
	country &i8
}
enum SDL_LogCategory {
	
	sdl_log_category_application
	sdl_log_category_error
	sdl_log_category_assert
	sdl_log_category_system
	sdl_log_category_audio
	sdl_log_category_video
	sdl_log_category_render
	sdl_log_category_input
	sdl_log_category_test
	sdl_log_category_gpu
	sdl_log_category_reserved_2
	sdl_log_category_reserved_3
	sdl_log_category_reserved_4
	sdl_log_category_reserved_5
	sdl_log_category_reserved_6
	sdl_log_category_reserved_7
	sdl_log_category_reserved_8
	sdl_log_category_reserved_9
	sdl_log_category_reserved_10
	sdl_log_category_custom
}
enum SDL_LogPriority {
	
	sdl_log_priority_invalid
	sdl_log_priority_trace
	sdl_log_priority_verbose
	sdl_log_priority_debug
	sdl_log_priority_info
	sdl_log_priority_warn
	sdl_log_priority_error
	sdl_log_priority_critical
	sdl_log_priority_count
}
type SDL_LogOutputFunction = fn (voidptr, int, SDL_LogPriority, &i8)
type SDL_MetalView = voidptr
enum SDL_ProcessIO {
	
	sdl_process_stdio_inherited
	sdl_process_stdio_null
	sdl_process_stdio_app
	sdl_process_stdio_redirect
	
}
struct SDL_Vertex { 
	position SDL_FPoint
	color SDL_FColor
	tex_coord SDL_FPoint
}
enum SDL_TextureAccess {
	
	sdl_textureaccess_static
	sdl_textureaccess_streaming
	sdl_textureaccess_target
	
}
enum SDL_RendererLogicalPresentation {
	
	sdl_logical_presentation_disabled
	sdl_logical_presentation_stretch
	sdl_logical_presentation_letterbox
	sdl_logical_presentation_overscan
	sdl_logical_presentation_integer_scale
	
}
struct SDL_Texture { 
	format sdl.PixelFormat
	w int
	h int
	refcount int
}
struct SDL_StorageInterface { 
	version Uint32
	close ?fn (voidptr) bool
	ready ?fn (voidptr) bool
	enumerate ?fn (voidptr, &i8, SDL_EnumerateDirectoryCallback, voidptr) bool
	info ?fn (voidptr, &i8, &SDL_PathInfo) bool
	read_file ?fn (voidptr, &i8, voidptr, Uint64) bool
	write_file ?fn (voidptr, &i8, voidptr, Uint64) bool
	mkdir ?fn (voidptr, &i8) bool
	remove ?fn (voidptr, &i8) bool
	rename ?fn (voidptr, &i8, &i8) bool
	copy ?fn (voidptr, &i8, &i8) bool
	space_remaining ?fn (voidptr) Uint64
}
enum SDL_Sandbox {
	
	sdl_sandbox_none = 0
	sdl_sandbox_unknown_container
	sdl_sandbox_flatpak
	sdl_sandbox_snap
	sdl_sandbox_macos
}
struct SDL_DateTime { 
	year int
	month int
	day int
	hour int
	minute int
	second int
	nanosecond int
	day_of_week int
	utc_offset int
}
enum SDL_DateFormat {
	
	sdl_date_format_yyyymmdd = 0
	sdl_date_format_ddmmyyyy = 1
	sdl_date_format_mmddyyyy = 2
	
}
enum SDL_TimeFormat {
	
	sdl_time_format_24_hr = 0
	sdl_time_format_12_hr = 1
	
}
type SDL_TimerID = u32
type SDL_TimerCallback = fn (voidptr, SDL_TimerID, Uint32) Uint32
type SDL_NSTimerCallback = fn (voidptr, SDL_TimerID, Uint64) Uint64
type SDL_TrayEntryFlags = u32
fn C.IMG_Version() int
pub fn img_version() int {
	return C.IMG_Version()
}
fn C.IMG_LoadTyped_IO(src &sdl.IOStream, closeio bool, type_ &i8) &sdl.Surface
pub fn img_load_typed_io(src &sdl.IOStream, closeio bool, type_ &i8) &sdl.Surface {
	return C.IMG_LoadTyped_IO(src, closeio, type_)
}
fn C.IMG_Load(file &i8) &sdl.Surface
pub fn img_load(file &i8) &sdl.Surface {
	return C.IMG_Load(file)
}
fn C.IMG_Load_IO(src &sdl.IOStream, closeio bool) &sdl.Surface
pub fn img_load_io(src &sdl.IOStream, closeio bool) &sdl.Surface {
	return C.IMG_Load_IO(src, closeio)
}
fn C.IMG_LoadTexture(renderer &sdl.Renderer, file &i8) &SDL_Texture
pub fn img_load_texture(renderer &sdl.Renderer, file &i8) &SDL_Texture {
	return C.IMG_LoadTexture(renderer, file)
}
fn C.IMG_LoadTexture_IO(renderer &sdl.Renderer, src &sdl.IOStream, closeio bool) &SDL_Texture
pub fn img_load_texture_io(renderer &sdl.Renderer, src &sdl.IOStream, closeio bool) &SDL_Texture {
	return C.IMG_LoadTexture_IO(renderer, src, closeio)
}
fn C.IMG_LoadTextureTyped_IO(renderer &sdl.Renderer, src &sdl.IOStream, closeio bool, type_ &i8) &SDL_Texture
pub fn img_load_texture_typed_io(renderer &sdl.Renderer, src &sdl.IOStream, closeio bool, type_ &i8) &SDL_Texture {
	return C.IMG_LoadTextureTyped_IO(renderer, src, closeio, type_)
}
fn C.IMG_isAVIF(src &sdl.IOStream) bool
pub fn img_is_avif(src &sdl.IOStream) bool {
	return C.IMG_isAVIF(src)
}
fn C.IMG_isICO(src &sdl.IOStream) bool
pub fn img_is_ico(src &sdl.IOStream) bool {
	return C.IMG_isICO(src)
}
fn C.IMG_isCUR(src &sdl.IOStream) bool
pub fn img_is_cur(src &sdl.IOStream) bool {
	return C.IMG_isCUR(src)
}
fn C.IMG_isBMP(src &sdl.IOStream) bool
pub fn img_is_bmp(src &sdl.IOStream) bool {
	return C.IMG_isBMP(src)
}
fn C.IMG_isGIF(src &sdl.IOStream) bool
pub fn img_is_gif(src &sdl.IOStream) bool {
	return C.IMG_isGIF(src)
}
fn C.IMG_isJPG(src &sdl.IOStream) bool
pub fn img_is_jpg(src &sdl.IOStream) bool {
	return C.IMG_isJPG(src)
}
fn C.IMG_isJXL(src &sdl.IOStream) bool
pub fn img_is_jxl(src &sdl.IOStream) bool {
	return C.IMG_isJXL(src)
}
fn C.IMG_isLBM(src &sdl.IOStream) bool
pub fn img_is_lbm(src &sdl.IOStream) bool {
	return C.IMG_isLBM(src)
}
fn C.IMG_isPCX(src &sdl.IOStream) bool
pub fn img_is_pcx(src &sdl.IOStream) bool {
	return C.IMG_isPCX(src)
}
fn C.IMG_isPNG(src &sdl.IOStream) bool
pub fn img_is_png(src &sdl.IOStream) bool {
	return C.IMG_isPNG(src)
}
fn C.IMG_isPNM(src &sdl.IOStream) bool
pub fn img_is_pnm(src &sdl.IOStream) bool {
	return C.IMG_isPNM(src)
}
fn C.IMG_isSVG(src &sdl.IOStream) bool
pub fn img_is_svg(src &sdl.IOStream) bool {
	return C.IMG_isSVG(src)
}
fn C.IMG_isQOI(src &sdl.IOStream) bool
pub fn img_is_qoi(src &sdl.IOStream) bool {
	return C.IMG_isQOI(src)
}
fn C.IMG_isTIF(src &sdl.IOStream) bool
pub fn img_is_tif(src &sdl.IOStream) bool {
	return C.IMG_isTIF(src)
}
fn C.IMG_isXCF(src &sdl.IOStream) bool
pub fn img_is_xcf(src &sdl.IOStream) bool {
	return C.IMG_isXCF(src)
}
fn C.IMG_isXPM(src &sdl.IOStream) bool
pub fn img_is_xpm(src &sdl.IOStream) bool {
	return C.IMG_isXPM(src)
}
fn C.IMG_isXV(src &sdl.IOStream) bool
pub fn img_is_xv(src &sdl.IOStream) bool {
	return C.IMG_isXV(src)
}
fn C.IMG_isWEBP(src &sdl.IOStream) bool
pub fn img_is_webp(src &sdl.IOStream) bool {
	return C.IMG_isWEBP(src)
}
fn C.IMG_LoadAVIF_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_avif_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadAVIF_IO(src)
}
fn C.IMG_LoadICO_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_ico_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadICO_IO(src)
}
fn C.IMG_LoadCUR_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_cur_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadCUR_IO(src)
}
fn C.IMG_LoadBMP_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_bmp_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadBMP_IO(src)
}
fn C.IMG_LoadGIF_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_gif_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadGIF_IO(src)
}
fn C.IMG_LoadJPG_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_jpg_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadJPG_IO(src)
}
fn C.IMG_LoadJXL_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_jxl_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadJXL_IO(src)
}
fn C.IMG_LoadLBM_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_lbm_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadLBM_IO(src)
}
fn C.IMG_LoadPCX_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_pcx_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadPCX_IO(src)
}
fn C.IMG_LoadPNG_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_png_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadPNG_IO(src)
}
fn C.IMG_LoadPNM_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_pnm_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadPNM_IO(src)
}
fn C.IMG_LoadSVG_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_svg_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadSVG_IO(src)
}
fn C.IMG_LoadQOI_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_qoi_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadQOI_IO(src)
}
fn C.IMG_LoadTGA_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_tga_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadTGA_IO(src)
}
fn C.IMG_LoadTIF_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_tif_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadTIF_IO(src)
}
fn C.IMG_LoadXCF_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_xcf_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadXCF_IO(src)
}
fn C.IMG_LoadXPM_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_xpm_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadXPM_IO(src)
}
fn C.IMG_LoadXV_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_xv_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadXV_IO(src)
}
fn C.IMG_LoadWEBP_IO(src &sdl.IOStream) &sdl.Surface
pub fn img_load_webp_io(src &sdl.IOStream) &sdl.Surface {
	return C.IMG_LoadWEBP_IO(src)
}
fn C.IMG_LoadSizedSVG_IO(src &sdl.IOStream, width int, height int) &sdl.Surface
pub fn img_load_sized_svg_io(src &sdl.IOStream, width int, height int) &sdl.Surface {
	return C.IMG_LoadSizedSVG_IO(src, width, height)
}
fn C.IMG_ReadXPMFromArray(xpm &&u8) &sdl.Surface
pub fn img_read_xpmf_rom_array(xpm &&u8) &sdl.Surface {
	return C.IMG_ReadXPMFromArray(xpm)
}
fn C.IMG_ReadXPMFromArrayToRGB888(xpm &&u8) &sdl.Surface
pub fn img_read_xpmf_rom_array_to_rgb_888(xpm &&u8) &sdl.Surface {
	return C.IMG_ReadXPMFromArrayToRGB888(xpm)
}
fn C.IMG_SaveAVIF(surface &sdl.Surface, file &i8, quality int) bool
pub fn img_save_avif(surface &sdl.Surface, file &i8, quality int) bool {
	return C.IMG_SaveAVIF(surface, file, quality)
}
fn C.IMG_SaveAVIF_IO(surface &sdl.Surface, dst &sdl.IOStream, closeio bool, quality int) bool
pub fn img_save_avif_io(surface &sdl.Surface, dst &sdl.IOStream, closeio bool, quality int) bool {
	return C.IMG_SaveAVIF_IO(surface, dst, closeio, quality)
}
fn C.IMG_SavePNG(surface &sdl.Surface, file &i8) bool
pub fn img_save_png(surface &sdl.Surface, file &i8) bool {
	return C.IMG_SavePNG(surface, file)
}
fn C.IMG_SavePNG_IO(surface &sdl.Surface, dst &sdl.IOStream, closeio bool) bool
pub fn img_save_png_io(surface &sdl.Surface, dst &sdl.IOStream, closeio bool) bool {
	return C.IMG_SavePNG_IO(surface, dst, closeio)
}
fn C.IMG_SaveJPG(surface &sdl.Surface, file &i8, quality int) bool
pub fn img_save_jpg(surface &sdl.Surface, file &i8, quality int) bool {
	return C.IMG_SaveJPG(surface, file, quality)
}
fn C.IMG_SaveJPG_IO(surface &sdl.Surface, dst &sdl.IOStream, closeio bool, quality int) bool
pub fn img_save_jpg_io(surface &sdl.Surface, dst &sdl.IOStream, closeio bool, quality int) bool {
	return C.IMG_SaveJPG_IO(surface, dst, closeio, quality)
}
struct IMG_Animation { 
	w int
	h int
	count int
	frames &&sdl.Surface
	delays &int
}
fn C.IMG_LoadAnimation(file &i8) &IMG_Animation
pub fn img_load_animation(file &i8) &IMG_Animation {
	return C.IMG_LoadAnimation(file)
}
fn C.IMG_LoadAnimation_IO(src &sdl.IOStream, closeio bool) &IMG_Animation
pub fn img_load_animation_io(src &sdl.IOStream, closeio bool) &IMG_Animation {
	return C.IMG_LoadAnimation_IO(src, closeio)
}
fn C.IMG_LoadAnimationTyped_IO(src &sdl.IOStream, closeio bool, type_ &i8) &IMG_Animation
pub fn img_load_animation_typed_io(src &sdl.IOStream, closeio bool, type_ &i8) &IMG_Animation {
	return C.IMG_LoadAnimationTyped_IO(src, closeio, type_)
}
fn C.IMG_FreeAnimation(anim &IMG_Animation)
pub fn img_free_animation(anim &IMG_Animation) {
	C.IMG_FreeAnimation(anim)
}
fn C.IMG_LoadGIFAnimation_IO(src &sdl.IOStream) &IMG_Animation
pub fn img_load_gifa_nimation_io(src &sdl.IOStream) &IMG_Animation {
	return C.IMG_LoadGIFAnimation_IO(src)
}
fn C.IMG_LoadWEBPAnimation_IO(src &sdl.IOStream) &IMG_Animation
pub fn img_load_webpa_nimation_io(src &sdl.IOStream) &IMG_Animation {
	return C.IMG_LoadWEBPAnimation_IO(src)
}
