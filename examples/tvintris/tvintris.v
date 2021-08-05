// Copyright (c) 2019-2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

// SDL2 port+wrapper, Twintris-like dual-game logic,
// and more, by Nicolas Sauzede 2019.
module main

import rand
import time
import os
import math
import sdl
import sdl.image
import sdl.mixer
import sdl.ttf

type img = sdl.Image
type mix = sdl.Mixer
type ttf = sdl.T

[inline]
fn sdl_fill_rect(s &SDL_Surface, r &SDL_Rect, c &SDL_Color) {
	sdl.fill_rect(s, r, c)
}

const (
	title           = 'tVintris'
	base_dir        = os.dir(os.real_path(os.executable()))
	font_name       = base_dir + '/../../assets/fonts/RobotoMono-Regular.ttf'
	music_name      = base_dir + '/sounds/TwintrisThosenine.mod'
	snd_block_name  = base_dir + '/sounds/block.wav'
	snd_line_name   = base_dir + '/sounds/single.wav'
	snd_double_name = base_dir + '/sounds/triple.wav'
	v_logo          = base_dir + '/images/v-logo_30_30.png'
	block_size      = 20 // pixels
	field_height    = 20 // # of blocks
	field_width     = 10
	tetro_size      = 4
	win_width       = block_size * field_width * 3
	win_height      = block_size * field_height
	timer_period    = 250 // ms
	text_size       = 16
	audio_buf_size  = 1024

	key_p2_fire     = C.SDLK_l
	key_p2_up       = C.SDLK_UP
	key_p2_down     = C.SDLK_DOWN
	key_p2_left     = C.SDLK_LEFT
	key_p2_right    = C.SDLK_RIGHT

	key_p1_fire     = C.SDLK_s
	key_p1_up       = C.SDLK_w
	key_p1_down     = C.SDLK_x
	key_p1_left     = C.SDLK_a
	key_p1_right    = C.SDLK_d

	n_joymax        = 2

	// joystick name => enter your own device name
	joy_p1_name     = 'Generic X-Box pad'

	// following are joystick button number
	jb_p1_fire      = 1

	// following are joystick hat value
	jh_p1_up        = 1
	jh_p1_down      = 4
	jh_p1_left      = 8
	jh_p1_right     = 3

	// joystick name => enter your own device name
	joy_p2_name     = 'RedOctane Guitar Hero X-plorer'

	// following are joystick button number
	jb_p2_fire      = 0

	// following are joystick hat value
	jh_p2_up        = 4
	jh_p2_down      = 1
	jh_p2_left      = 8
	jh_p2_right     = 2
)

const (
	mix_version = mix.version
	ttf_version = ttf.version
)

const (
	// Tetros' 4 possible states are encoded in binaries
	base_tetros      = [
		// 0000 0
		// 0000 0
		// 0110 6
		/* 0110 6 */ [66, 66, 66, 66]
	// 0000 0
	// 0000 0
	// 0010 2
	/* 0111 7 */, [27, 131, 72, 232]
	// 0000 0
	// 0000 0
	// 0011 3
	/* 0110 6 */, [36, 231, 36, 231]
	// 0000 0
	// 0000 0
	// 0110 6
	/* 0011 3 */, [63, 132, 63, 132]
	// 0000 0
	// 0011 3
	// 0001 1
	/* 0001 1 */, [311, 17, 223, 74]
	// 0000 0
	// 0011 3
	// 0010 2
	/* 0010 2 */, [322, 71, 113, 47]
	// Special case since 15 can't be used
	/* 1111 */, [1111, 9, 1111, 9]]

	// Each tetro has its unique color
	colors           = [
		SDL_Color{byte(0), byte(0), byte(0), byte(0)},
		// unused ?
		SDL_Color{byte(0), byte(0x62), byte(0xc0), byte(0)},
		// quad : darkblue 0062c0
		SDL_Color{byte(0xca), byte(0x7d), byte(0x5f), byte(0)},
		// tricorn : lightbrown ca7d5f
		SDL_Color{byte(0), byte(0xc1), byte(0xbf), byte(0)},
		// short topright : lightblue 00c1bf
		SDL_Color{byte(0), byte(0xc1), byte(0), byte(0)},
		// short topleft : lightgreen 00c100
		SDL_Color{byte(0xbf), byte(0xbe), byte(0), byte(0)},
		// long topleft : yellowish bfbe00
		SDL_Color{byte(0xd1), byte(0), byte(0xbf), byte(0)},
		// long topright : pink d100bf
		SDL_Color{byte(0xd1), byte(0), byte(0), byte(0)},
		// longest : lightred d10000
		SDL_Color{byte(0), byte(170), byte(170), byte(0)},
		// unused ?
	]

	// Background color
	background_color = SDL_Color{byte(0), byte(0), byte(0), byte(0)}

	// Foreground color
	foreground_color = SDL_Color{byte(0), byte(170), byte(170), byte(0)}

	// Text color
	text_color       = SDL_Color{byte(0xca), byte(0x7d), byte(0x5f), byte(0)}
)

// TODO: type Tetro [tetro_size]struct{ x, y int }
struct Block {
mut:
	x int
	y int
}

enum GameState {
	paused
	running
	gameover
}

struct AudioContext {
mut:
	music  voidptr
	volume int
	waves  [3]voidptr
}

struct SdlContext {
pub mut:
	//	VIDEO
	w        int
	h        int
	window   voidptr
	renderer voidptr
	screen   &SDL_Surface
	texture  voidptr
	//	AUDIO
	actx AudioContext
	//	JOYSTICKS
	jnames [2]string
	jids   [2]int
	//	V logo
	v_logo  &SDL_Surface
	tv_logo voidptr
}

struct Game {
mut:
	// Score of the current game
	score int
	// Count consecutive lines for scoring
	lines int
	// State of the current game
	state GameState
	// X offset of the game display
	ofs_x int
	// keys
	k_fire  int
	k_up    int
	k_down  int
	k_left  int
	k_right int
	// joystick ID
	joy_id int
	// joystick buttons
	jb_fire int
	// joystick hat values
	jh_up    int
	jh_down  int
	jh_left  int
	jh_right int
	// game rand seed
	seed     int
	seed_ini int
	// Position of the current tetro
	pos_x int
	pos_y int
	// field[y][x] contains the color of the block with (x,y) coordinates
	// "-1" border is to avoid bounds checking.
	// -1 -1 -1 -1
	// -1  0  0 -1
	// -1  0  0 -1
	// -1 -1 -1 -1
	field [][]int
	// TODO: tetro Tetro
	tetro []Block
	// TODO: tetros_cache []Tetro
	tetros_cache []Block
	// Index of the current tetro. Refers to its color.
	tetro_idx int
	// Index of the next tetro. Refers to its color.
	tetro_next int
	// tetro stats : buckets of drawn tetros
	tetro_stats []int
	// total number of drawn tetros
	tetro_total int
	// Index of the rotation (0-3)
	rotation_idx int
	// SDL2 context for drawing
	sdl SdlContext
	// TTF context for font drawing
	font voidptr
}

fn (mut sdlc SdlContext) set_sdl_context(w int, h int, title string) {
	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_AUDIO | C.SDL_INIT_JOYSTICK)
	C.atexit(C.SDL_Quit)
	C.TTF_Init()
	C.atexit(C.TTF_Quit)
	bpp := 32
	sdl.create_window_and_renderer(w, h, 0, &sdlc.window, &sdlc.renderer)

	//	C.SDL_CreateWindowAndRenderer(w, h, 0, voidptr(&sdlc.window), voidptr(&sdlc.renderer))
	C.SDL_SetWindowtitle(sdlc.window, title.str)
	sdlc.w = w
	sdlc.h = h
	sdlc.screen = sdl.create_rgb_surface(0, w, h, bpp, 0x00FF0000, 0x0000FF00, 0x000000FF,
		0xFF000000)
	sdlc.texture = C.SDL_CreateTexture(sdlc.renderer, C.SDL_PIXELFORMAT_ARGB8888, C.SDL_TEXTUREACCESS_STREAMING,
		w, h)

	C.Mix_Init(C.MIX_INIT_MOD)
	C.atexit(C.Mix_Quit)
	if C.Mix_OpenAudio(48000, C.MIX_DEFAULT_FORMAT, 2, audio_buf_size) < 0 {
		println("couldn't open audio")
	}
	println('opening music $music_name')
	sdlc.actx.music = C.Mix_LoadMUS(music_name.str)
	sdlc.actx.waves[0] = C.Mix_LoadWAV(snd_block_name.str)
	sdlc.actx.waves[1] = C.Mix_LoadWAV(snd_line_name.str)
	sdlc.actx.waves[2] = C.Mix_LoadWAV(snd_double_name.str)
	sdlc.actx.volume = C.SDL_MIX_MAXVOLUME
	if C.Mix_PlayMusic(sdlc.actx.music, 1) != -1 {
		C.Mix_VolumeMusic(sdlc.actx.volume)
	}
	njoy := C.SDL_NumJoysticks()
	for i in 0 .. njoy {
		C.SDL_JoystickOpen(i)
		jn := tos_clone(sdl.joystick_name_for_index(i))
		println('JOY NAME $jn')
		for j in 0 .. n_joymax {
			if sdlc.jnames[j] == jn {
				println('FOUND JOYSTICK $j $jn ID=$i')
				sdlc.jids[j] = i
			}
		}
	}
	flags := C.IMG_INIT_PNG
	imgres := img.img_init(flags)
	if (imgres & flags) != flags {
		println('error initializing image library.')
	}
	println('opening logo $v_logo')
	sdlc.v_logo = img.load(v_logo)
	if !isnil(sdlc.v_logo) {
		//		println('got v_logo=$sdlc.v_logo')
		sdlc.tv_logo = sdl.create_texture_from_surface(sdlc.renderer, sdlc.v_logo)

		//		println('got tv_logo=$sdlc.tv_logo')
	}
	C.SDL_JoystickEventState(C.SDL_ENABLE)
}

fn main() {
	println('tVintris -- tribute to venerable Twintris')
	mut game := &Game{
		font: 0
	}
	game.sdl.jnames[0] = joy_p1_name
	game.sdl.jnames[1] = joy_p2_name
	game.sdl.jids[0] = -1
	game.sdl.jids[1] = -1
	game.sdl.set_sdl_context(win_width, win_height, title)
	game.font = C.TTF_OpenFont(font_name.str, text_size)
	seed := time.now().unix
	mut game2 := &Game{
		font: 0
	}
	game2.sdl = game.sdl
	game2.font = game.font

	game.joy_id = game.sdl.jids[0]

	//	println('JOY1 id=${game.joy_id}')
	game2.joy_id = game.sdl.jids[1]

	//	println('JOY2 id=${game2.joy_id}')

	// delay uses milliseconds so 1000 ms / 30 frames (30fps) roughly = 33.3333 ms/frame
	time_per_frame := 1000.0 / 30.0

	game.k_fire = key_p1_fire
	game.k_up = key_p1_up
	game.k_down = key_p1_down
	game.k_left = key_p1_left
	game.k_right = key_p1_right
	game.jb_fire = jb_p1_fire
	game.jh_up = jh_p1_up
	game.jh_down = jh_p1_down
	game.jh_left = jh_p1_left
	game.jh_right = jh_p1_right
	game.ofs_x = 0
	game.seed_ini = seed
	game.init_game()
	game.state = .running
	go game.run() // Run the game loop in a new thread
	game2.k_fire = key_p2_fire
	game2.k_up = key_p2_up
	game2.k_down = key_p2_down
	game2.k_left = key_p2_left
	game2.k_right = key_p2_right
	game2.jb_fire = jb_p2_fire
	game2.jh_up = jh_p2_up
	game2.jh_down = jh_p2_down
	game2.jh_left = jh_p2_left
	game2.jh_right = jh_p2_right
	game2.ofs_x = win_width * 2 / 3
	game2.seed_ini = seed
	game2.init_game()
	game2.state = .running
	go game2.run() // Run the game loop in a new thread
	mut g := Game{
		font: 0
	}
	mut should_close := false
	mut total_frame_ticks := u64(0)
	mut total_frames := u32(0)

	for {
		total_frames++
		start_ticks := sdl.get_perf_counter()

		g1 := game
		g2 := game2

		// here we determine which game contains most recent state
		if g1.tetro_total > g.tetro_total {
			g = *g1
		}
		if g2.tetro_total > g.tetro_total {
			g = *g2
		}
		g.draw_begin()

		g1.draw_tetro()
		g1.draw_field()

		g2.draw_tetro()
		g2.draw_field()

		g.draw_middle()

		g1.draw_score()
		g2.draw_score()

		g.draw_stats()

		g.draw_v_logo()
		g.draw_end()

		//		game.handle_events()            // CRASHES if done in function ???
		evt := SDL_Event{}
		for 0 < sdl.poll_event(&evt) {
			match int(evt.@type) {
				C.SDL_QUIT {
					should_close = true
				}
				C.SDL_KEYDOWN {
					key := evt.key.keysym.sym
					if key == C.SDLK_ESCAPE {
						should_close = true
						break
					}
					game.handle_key(key)
					game2.handle_key(key)
				}
				C.SDL_JOYBUTTONDOWN {
					jb := int(evt.jbutton.button)
					joyid := evt.jbutton.which

					//					println('JOY BUTTON $jb $joyid')
					game.handle_jbutton(jb, joyid)
					game2.handle_jbutton(jb, joyid)
				}
				C.SDL_JOYHATMOTION {
					jh := int(evt.jhat.hat)
					jv := int(evt.jhat.value)
					joyid := evt.jhat.which

					//					println('JOY HAT $jh $jv $joyid')
					game.handle_jhat(jh, jv, joyid)
					game2.handle_jhat(jh, jv, joyid)
				}
				else {}
			}
		}
		if should_close {
			break
		}
		end_ticks := sdl.get_perf_counter()

		total_frame_ticks += end_ticks - start_ticks
		elapsed_time := f64(end_ticks - start_ticks) / f64(sdl.get_perf_frequency())

		// current_fps := 1.0 / elapsed_time

		// should limit system to (1 / time_per_frame) fps
		sdl.delay(u32(math.floor(time_per_frame - elapsed_time)))
	}
	if game.font != voidptr(0) {
		C.TTF_CloseFont(game.font)
	}
	if game.sdl.actx.music != voidptr(0) {
		C.Mix_FreeMusic(game.sdl.actx.music)
	}
	C.Mix_CloseAudio()
	if game.sdl.actx.waves[0] != voidptr(0) {
		C.Mix_FreeChunk(game.sdl.actx.waves[0])
	}
	if game.sdl.actx.waves[1] != voidptr(0) {
		C.Mix_FreeChunk(game.sdl.actx.waves[1])
	}
	if game.sdl.actx.waves[2] != voidptr(0) {
		C.Mix_FreeChunk(game.sdl.actx.waves[2])
	}
	if !isnil(game.sdl.tv_logo) {
		sdl.destroy_texture(game.sdl.tv_logo)
	}
	if !isnil(game.sdl.v_logo) {
		sdl.free_surface(game.sdl.v_logo)
	}
}

enum Action {
	idle
	space
	fire
}

fn (mut game Game) handle_key(key int) {
	// global keys
	mut action := Action.idle
	match key {
		C.SDLK_SPACE { action = .space }
		game.k_fire { action = .fire }
		else {}
	}

	if action == .space {
		match game.state {
			.running {
				C.Mix_PauseMusic()
				game.state = .paused
			}
			.paused {
				C.Mix_ResumeMusic()
				game.state = .running
			}
			else {}
		}
	}

	if action == .fire {
		match game.state {
			.gameover {
				game.init_game()
				game.state = .running
			}
			else {}
		}
	}
	if game.state != .running {
		return
	}

	// keys while game is running
	match key {
		game.k_up { game.rotate_tetro() }
		game.k_left { game.move_right(-1) }
		game.k_right { game.move_right(1) }
		game.k_down { game.move_tetro() } // drop faster when the player presses <down>
		else {}
	}
}

fn (mut game Game) handle_jbutton(jb int, joyid int) {
	if joyid != game.joy_id {
		return
	}

	// global buttons
	mut action := Action.idle
	match jb {
		game.jb_fire { action = .fire }
		else {}
	}

	if action == .fire {
		match game.state {
			.gameover {
				game.init_game()
				game.state = .running
			}
			else {}
		}
	}
}

fn (mut game Game) handle_jhat(jh int, jv int, joyid int) {
	if joyid != game.joy_id {
		return
	}
	if game.state != .running {
		return
	}

	//	println('testing hat values.. joyid=$joyid jh=$jh jv=$jv')
	// hat values while game is running
	match jv {
		game.jh_up { game.rotate_tetro() }
		game.jh_left { game.move_right(-1) }
		game.jh_right { game.move_right(1) }
		game.jh_down { game.move_tetro() } // drop faster when the player presses <down>
		else {}
	}
}

fn (mut g Game) init_game() {
	g.score = 0
	g.tetro_total = 0
	g.tetro_stats = [0, 0, 0, 0, 0, 0, 0]
	g.parse_tetros()
	g.seed = g.seed_ini
	g.generate_tetro()
	g.field = []

	// Generate the field, fill it with 0's, add -1's on each edge
	for i in 0 .. field_height + 2 {
		mut row := [0].repeat(field_width + 2)
		row[0] = -1
		row[field_width + 1] = -1
		g.field << row
	}
	mut first_row := g.field[0]
	mut last_row := g.field[field_height + 1]
	for j in 0 .. field_width + 2 {
		first_row[j] = -1
		last_row[j] = -1
	}
}

fn (mut g Game) parse_tetros() {
	for b_tetros in base_tetros {
		for b_tetro in b_tetros {
			for t in parse_binary_tetro(b_tetro) {
				g.tetros_cache << t
			}
		}
	}
}

fn (mut g Game) run() {
	for {
		if g.state == .running {
			g.move_tetro()
			n := g.delete_completed_lines()
			if n > 0 {
				g.lines += n
			} else {
				if g.lines > 0 {
					if g.lines > 1 {
						C.Mix_PlayChannel(0, g.sdl.actx.waves[2], 0)
					} else if g.lines == 1 {
						C.Mix_PlayChannel(0, g.sdl.actx.waves[1], 0)
					}
					g.score += 10 * g.lines * g.lines
					g.lines = 0
				}
			}
		}
		time.sleep_ms(timer_period) // medium delay between game step
	}
}

fn (mut game Game) rotate_tetro() {
	// Rotate the tetro
	old_rotation_idx := game.rotation_idx
	game.rotation_idx++
	if game.rotation_idx == tetro_size {
		game.rotation_idx = 0
	}
	game.get_tetro()
	if !game.move_right(0) {
		game.rotation_idx = old_rotation_idx
		game.get_tetro()
	}
	if game.pos_x < 0 {
		game.pos_x = 1
	}
}

fn (mut g Game) move_tetro() {
	// Check each block in current tetro
	for block in g.tetro {
		y := block.y + g.pos_y + 1
		x := block.x + g.pos_x

		// Reached the bottom of the screen or another block?
		// TODO: if g.field[y][x] != 0
		// if g.field[y][x] != 0 {
		row := g.field[y]
		if row[x] != 0 {
			// The new tetro has no space to drop => end of the game
			if g.pos_y < 2 {
				g.state = .gameover
				g.tetro_total = 0
				return
			}

			// Drop it and generate a new one
			g.drop_tetro()
			g.generate_tetro()
			C.Mix_PlayChannel(0, g.sdl.actx.waves[0], 0)
			return
		}
	}
	g.pos_y++
}

fn (mut g Game) move_right(dx int) bool {
	// Reached left/right edge or another tetro?
	for i in 0 .. tetro_size {
		tetro := g.tetro[i]
		y := tetro.y + g.pos_y
		x := tetro.x + g.pos_x + dx
		row := g.field[y]
		if row[x] != 0 {
			// Do not move
			return false
		}
	}
	g.pos_x += dx
	return true
}

fn (g &Game) delete_completed_lines() int {
	mut n := 0
	for y := field_height; y >= 1; y-- {
		n += g.delete_completed_line(y)
	}
	return n
}

fn (g &Game) delete_completed_line(y int) int {
	for x := 1; x <= field_width; x++ {
		f := g.field[y]
		if f[x] == 0 {
			return 0
		}
	}

	// Move everything down by 1 position
	for yy := y - 1; yy >= 1; yy-- {
		for x := 1; x <= field_width; x++ {
			mut a := g.field[yy + 1]
			b := g.field[yy]
			a[x] = b[x]
		}
	}
	return 1
}

// Draw a rand tetro index
fn (mut g Game) rand_tetro() int {
	cur := g.tetro_next
	g.tetro_next = rand.rand_r(&g.seed)
	g.tetro_next = g.tetro_next % b_tetros.len
	return cur
}

// Place a new tetro on top
fn (mut g Game) generate_tetro() {
	g.pos_y = 0
	g.pos_x = field_width / 2 - tetro_size / 2
	g.tetro_idx = g.rand_tetro()

	//	println('idx=${g.tetro_idx}')
	g.tetro_stats[g.tetro_idx] += 2 - 1
	g.tetro_total++
	g.rotation_idx = 0
	g.get_tetro()
}

// Get the right tetro from cache
fn (mut g Game) get_tetro() {
	idx := g.tetro_idx * tetro_size * tetro_size + g.rotation_idx * tetro_size
	g.tetro = g.tetros_cache[idx..idx + tetro_size]
}

fn (g &Game) drop_tetro() {
	for i in 0 .. tetro_size {
		tetro := g.tetro[i]
		x := tetro.x + g.pos_x
		y := tetro.y + g.pos_y

		// Remember the color of each block
		// TODO: g.field[y][x] = g.tetro_idx + 1
		mut row := g.field[y]
		row[x] = g.tetro_idx + 1
	}
}

fn (g &Game) draw_tetro() {
	for i in 0 .. tetro_size {
		tetro := g.tetro[i]
		g.draw_block(g.pos_y + tetro.y, g.pos_x + tetro.x, g.tetro_idx + 1)
	}
}

fn (g &Game) draw_block(i int, j int, color_idx int) {
	rect := SDL_Rect{g.ofs_x + (j - 1) * block_size, (i - 1) * block_size, block_size - 1, block_size - 1}
	col := colors[color_idx]
	sdl_fill_rect(g.sdl.screen, &rect, &col)
}

fn (g &Game) draw_field() {
	for i := 1; i < field_height + 1; i++ {
		for j := 1; j < field_width + 1; j++ {
			f := g.field[i]
			if f[j] > 0 {
				g.draw_block(i, j, f[j])
			}
		}
	}
}

fn (g &Game) draw_v_logo() {
	if isnil(g.sdl.tv_logo) {
		return
	}
	texw := 0
	texh := 0
	C.SDL_QueryTexture(g.sdl.tv_logo, 0, 0, &texw, &texh)
	dstrect := SDL_Rect{(win_width / 2) - (texw / 2), 20, texw, texh}

	// Currently we can't seem to use sdl.render_copy when we need to pass a nil pointer (eg: srcrect to be NULL)
	//	sdl.render_copy(g.sdl.renderer, tv_logo, 0, &dstrect)
	C.SDL_RenderCopy(g.sdl.renderer, g.sdl.tv_logo, voidptr(0), voidptr(&dstrect))
}

fn (g &Game) draw_text(x int, y int, text string, tcol SDL_Color) {
	_tcol := C.SDL_Color{tcol.r, tcol.g, tcol.b, tcol.a}
	tsurf := C.TTF_RenderText_Solid(g.font, text.str, _tcol)
	ttext := C.SDL_CreateTextureFromSurface(g.sdl.renderer, tsurf)
	texw := 0
	texh := 0
	C.SDL_QueryTexture(ttext, 0, 0, &texw, &texh)
	dstrect := SDL_Rect{x, y, texw, texh}

	//	sdl.render_copy(g.sdl.renderer, ttext, 0, &dstrect)
	C.SDL_RenderCopy(g.sdl.renderer, ttext, voidptr(0), voidptr(&dstrect))
	C.SDL_DestroyTexture(ttext)
	sdl.free_surface(tsurf)
}

[inline]
fn (g &Game) draw_ptext(x int, y int, text string, tcol SDL_Color) {
	g.draw_text(g.ofs_x + x, y, text, tcol)
}

[live]
fn (g &Game) draw_begin() {
	//	println('about to clear')
	C.SDL_RenderClear(g.sdl.renderer)
	mut rect := SDL_Rect{0, 0, g.sdl.w, g.sdl.h}
	col := SDL_Color{byte(0), byte(0), byte(0), byte(0)}

	//	sdl_fill_rect(g.sdl.screen, &rect, background_color)
	sdl_fill_rect(g.sdl.screen, &rect, col)

	rect = SDL_Rect{block_size * field_width + 2, 0, 2, g.sdl.h}
	sdl_fill_rect(g.sdl.screen, &rect, foreground_color)
	rect = SDL_Rect{win_width - block_size * field_width - 4, 0, 2, g.sdl.h}
	sdl_fill_rect(g.sdl.screen, &rect, foreground_color)

	mut idx := 0
	for st in g.tetro_stats {
		mut s := 10
		if g.tetro_total > 0 {
			s += 90 * st / g.tetro_total
		}
		w := block_size
		h := s * 4 * w / 100
		rect = SDL_Rect{(win_width - 7 * (w + 1)) / 2 + idx * (w + 1), win_height * 3 / 4 - h, w, h}
		sdl_fill_rect(g.sdl.screen, &rect, colors[idx + 1])
		idx++
	}
}

fn (g &Game) draw_middle() {
	C.SDL_UpdateTexture(g.sdl.texture, 0, g.sdl.screen.pixels, g.sdl.screen.pitch)

	//	sdl.render_copy(g.sdl.renderer, g.sdl.texture, voidptr(0), voidptr(0))
	C.SDL_RenderCopy(g.sdl.renderer, g.sdl.texture, voidptr(0), voidptr(0))
}

fn (g &Game) draw_score() {
	if g.font != voidptr(0) {
		g.draw_ptext(1, 2, 'score: ' + g.score.str() + ' nxt=' + g.tetro_next.str(), text_color)
		if g.state == .gameover {
			g.draw_ptext(1, win_height / 2 + 0 * text_size, 'Game Over', text_color)
			g.draw_ptext(1, win_height / 2 + 2 * text_size, 'FIRE to restart', text_color)
		} else if g.state == .paused {
			g.draw_ptext(1, win_height / 2 + 0 * text_size, 'Game Paused', text_color)
			g.draw_ptext(1, win_height / 2 + 2 * text_size, 'SPACE to resume', text_color)
		}
	}
}

fn (g &Game) draw_stats() {
	if g.font != voidptr(0) {
		g.draw_text(win_width / 3 + 10, win_height * 3 / 4 + 0 * text_size, 'stats: ' +
			g.tetro_total.str() + ' tetros', text_color)
		mut stats := ''
		for st in g.tetro_stats {
			mut s := 0
			if g.tetro_total > 0 {
				s = 100 * st / g.tetro_total
			}
			stats += ' '
			stats += s.str()
		}
		g.draw_text(win_width / 3 - 8, win_height * 3 / 4 + 2 * text_size, stats, text_color)
	}
}

fn (g &Game) draw_end() {
	C.SDL_RenderPresent(g.sdl.renderer)
}

fn parse_binary_tetro(t_ int) []Block {
	mut t := t_
	res := [Block{}].repeat(4)
	mut cnt := 0
	horizontal := t == 9 // special case for the horizontal line
	for i := 0; i <= 3; i++ {
		// Get ith digit of t
		p := int(math.pow(10, 3 - i))
		mut digit := t / p
		t %= p

		// Convert the digit to binary
		for j := 3; j >= 0; j-- {
			bin := digit % 2
			digit /= 2
			if bin == 1 || (horizontal && i == tetro_size - 1) {
				// TODO: res[cnt].x = j
				// res[cnt].y = i
				mut point := &res[cnt]
				point.x = j
				point.y = i
				cnt++
			}
		}
	}
	return res
}
