module main

import math

pub struct Lattice {
	w int
	h int
mut:
	m []Cell
}

// Allocate x*y Cells Lattice
pub fn Lattice.new(x int, y int, profile &u8) Lattice {
	mut ret := Lattice{x, y, []Cell{cap: x * y}}

	for i in 0 .. (x * y) {
		e := unsafe { profile[i] != 0 }
		mut c := Cell.new(e)
		ret.m << c
	}
	return ret
}

pub fn (l Lattice) str() string {
	return 'Lattice[${l.w}x${l.h}]'
}

// total_rho compute the total density on the Lattice. This value is conserved.
pub fn (l Lattice) total_rho() f64 {
	mut t := 0.0
	for c in l.m {
		if c.obstacle {
			continue
		}
		t += c.rho()
	}
	return t
}

// clear the Lattice : File fields with zeros.
pub fn (mut l Lattice) clear() {
	unsafe { vmemset(l.m.data, 0, u32(l.m.len) * sizeof(Cell)) }
}

// add_flow create an artificial flow of i intensity in v direction
// It impacts all lattice cells. It's usually a good thing to call normalize()
// method after that.
pub fn (mut l Lattice) add_flow(i f64, v Vi) {
	for mut c in l.m {
		if c.obstacle {
			continue
		}
		c.sum(v, i)
	}
}

// normalize normalizes all lattice cells against rho0 so that average density
// is equal to rho0.
pub fn (mut l Lattice) normalize() {
	for mut c in l.m {
		if c.obstacle {
			continue
		}
		c.normalize()
	}
}

// max_ux returns maximal horizontal speed  in the whole lattice
pub fn (l Lattice) max_ux() f64 {
	mut ux := 0.0

	for c in l.m {
		if c.obstacle {
			continue
		}
		u := c.ux()

		if u > ux {
			ux = u
		}
	}
	return ux
}

// min_ux returns minimal horizontal speed  in the whole lattice
pub fn (l Lattice) min_ux() f64 {
	mut ux := 0.0

	for c in l.m {
		if c.obstacle {
			continue
		}
		u := c.ux()

		if u < ux {
			ux = u
		}
	}
	return ux
}

// max_uy returns maximal horizontal speed  in the whole lattice
pub fn (l Lattice) max_uy() f64 {
	mut uy := 0.0

	for c in l.m {
		if c.obstacle {
			continue
		}
		u := c.uy()

		if u > uy {
			uy = u
		}
	}
	return uy
}

// min_uy returns minimal horizontal speed  in the whole lattice
pub fn (l Lattice) min_uy() f64 {
	mut uy := 0.0

	for c in l.m {
		if c.obstacle {
			continue
		}
		u := c.uy()

		if u < uy {
			uy = u
		}
	}
	return uy
}

// max_rho returns maximal cell density  in the whole lattice
pub fn (l Lattice) max_rho() f64 {
	mut r := 0.0

	for c in l.m {
		if c.obstacle {
			continue
		}
		rho := c.rho()

		if rho > r {
			r = rho
		}
	}
	return r
}

// min_rho returns maximal cell density  in the whole lattice
pub fn (l Lattice) min_rho() f64 {
	mut r := 1_000_000.0

	for c in l.m {
		if c.obstacle {
			continue
		}
		rho := c.rho()

		if rho < r {
			r = rho
		}
	}
	return r
}

// mean_rho returns the mean rho value over all lattice
fn (l Lattice) mean_rho() f64 {
	mut i := 0.0
	for c in l.m {
		if c.obstacle {
			continue
		}
		i += c.rho()
	}

	return i / l.m.len
}

// vorticity computes vorticity at given position.
fn (l Lattice) vorticity(x int, y int) f64 {
	if x > 0 && x < l.w - 1 {
		if y > 0 && y < l.h - 1 {
			ind := y * l.w + x
			omega := (l.m[ind + 1].uy() - l.m[ind - 1].uy()) - (l.m[ind + l.w].ux() - l.m[ind - l.w].ux())
			return omega
		}
	}
	return 0
}

// randomize add random noise everywhere given i intensity.
// It's usually a good thing to call normalize()  method after that.
pub fn (mut l Lattice) randomize(i f64) {
	for mut c in l.m {
		if c.obstacle {
			continue
		}
		c.randomize(i)
	}
}

// move applies simulation movements handling borders and profile collisions.
// Note that the rightmost column is handled differently, and outgoing mini-particle
// are re-injected on the left.
pub fn (l Lattice) move(mut output Lattice) {
	mut index := 0
	output.clear()

	for y in 0 .. l.h {
		for x in 0 .. l.w {
			output.m[index].obstacle = l.m[index].obstacle // Copy src reachable state to output
			for m in vi { // For this cell, for all direction vectors or mini particles
				mini_part := l.m[index].get(m)
				if dst_ind := l.reachable(x, y, m) {
					output.m[dst_ind].sum(m, mini_part) // move mini-particle
				} else {
					output.m[index].sum(m.opposite(), mini_part) // rebound mini-particle, don't move but invert direction vector.
				}
			}
			index++
		}
	}
}

// collide performs the most sensible step: Collision between mini-particles.
pub fn (mut l Lattice) collide() {
	for mut c in l.m {
		if c.obstacle == false {
			mut new_cell := Cell.zero(false)

			for m in vi {
				f := c.get(m)
				feq := c.equ(m)
				assert math.is_nan(feq) == false
				assert math.is_nan(f) == false
				new_cell.set(m, f - ((1.0 / tau) * (f - feq)))
			}
			c = new_cell
		}
	}
}

// reachable test if destination Cell (base on x,y and Direction vector)
// is cross-able or reachable. Lattice edge is limiting, as the profile as
// well,  none is returned on these case. For reachable, index of the
// reachable Cell (in Lattice) is returned, for an easy update.
fn (l Lattice) reachable(x int, y int, v Vi) ?int {
	assert x >= 0
	assert y >= 0

	// Add direction vector to current position to get destination position.
	mut nx := x + dvx_i[int(v)]
	ny := y + dvy_i[int(v)]

	if ny < 0 || ny >= l.h {
		return none
	}

	if nx < 0 {
		nx = nx + l.w
	}

	if nx >= l.w {
		nx = nx - l.w
	}

	ind := nx + (l.w * ny) // Get 1D index in lattice.

	return if l.m[ind].obstacle {
		none
	} else {
		ind // Destination cell is obstacle free. Return it's index.
	}
}
