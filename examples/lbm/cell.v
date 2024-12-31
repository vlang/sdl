module main

import math
import rand

// vfmt off
//
// This file contains Code and data structures for a Lattice-Boltzmann-Method (LBM)
// fluid flow simulation. The simulation is 2 Dimension, with 9 possible directions (D2Q9)
//
//  8     1     2
//
//  7     0     3
//
//  6     5     4

// Vi is an enum for direction vector of D2Q9 Lattice.
pub enum Vi as int {
	center =0
	north = 1
	north_east =2
	east=3
	south_east=4
	south= 5
	south_west = 6
	west=7
	north_west = 8
}

// opposite returns vector of opposite direction. Yes Enum can have methods in V.
// Warning: This array must be coherent with Vi enum order !
fn (v Vi) opposite() Vi {
	 opp :=[Vi.center, Vi.south, Vi.south_west,
				  Vi.west, Vi.north_west, Vi.north,
				  Vi.north_east, Vi.east, Vi.south_east]

	return opp[int(v)]
}

//Array defined here in order to loop over a Vi enum.
// Warning: This array must be coherent with Vi enum order !
const vi = [Vi.center, Vi.north, Vi.north_east,
                  Vi.east, Vi.south_east, Vi.south,
                  Vi.south_west, Vi.west, Vi.north_west]

// Discrete velocity vectors, by component, with respect to SDL display orientation (North is negative on y axis)
// f64 and int are provided to avoid unnecessary casts.
// Warning: These vectors must be coherent with Vi enum order !
const dvx_f = [0.0, 0.0, 1.0, 1.0, 1.0, 0.0, -1.0, -1.0, -1.0]
const dvy_f = [0.0, -1.0, -1.0, 0.0, 1.0, 1.0, 1.0, 0.0, -1.0]
const dvx_i = [0, 0, 1, 1, 1, 0, -1, -1, -1]
const dvy_i = [0, -1, -1, 0, 1, 1, 1, 0, -1]

// wi is the weight of mini-cells.
// Warning: This array must be coherent with Vi enum order !
const wi = [f64(16.0 / 36.0), 4.0 / 36.0, 1.0 / 36.0,
	                   4.0 / 36.0,   1.0 / 36.0, 4.0 / 36.0,
		 	           1.0 / 36.0,   4.0 / 36.0, 1.0 / 36.0
]

// vfmt on

struct Cell {
mut:
	obstacle bool
	sp       [9]f64
}

// Cell.new built, and initializes a default Cell.
// Warning: sp values must be coherent with Vi enum order !
fn Cell.new(o bool) Cell {
	return Cell{
		obstacle: o
		sp:       [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]!
	} // ! means fixed size array ! Will change a day !
}

// Return a Cell with all mini-cell set to Zero
fn Cell.zero(o bool) Cell {
	return Cell{
		obstacle: o
		sp:       [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]!
	}
}

// normalize perform a normalisation on the cell so that average desnsity is rho0
fn (mut c Cell) normalize() {
	rho := c.rho()
	for mut v in c.sp {
		v *= (rho0 / rho)
	}
}

// randomize add some randomness on the cell.
fn (mut c Cell) randomize(i f64) {
	for v in vi {
		r := rand.f64() * i
		c.sum(v, r)
	}
}

// get returns mini-cell depending on the given speed vector.
fn (c &Cell) get(v Vi) f64 {
	return c.sp[int(v)]
}

// set forces a mini-cell value given its speed vector.
fn (mut c Cell) set(v Vi, value f64) {
	c.sp[int(v)] = value
}

// increase (add value) to a mini-cell value given its speed vector.
fn (mut c Cell) sum(v Vi, value f64) {
	c.sp[int(v)] += value
}

// rho computes whole cell's density
fn (c &Cell) rho() f64 {
	mut sum := 0.0
	for v in c.sp {
		sum += v
	}
	assert math.is_nan(sum) == false
	return sum
}

// ux computes x (horizontal) component of cell speed vector.
fn (c &Cell) ux() f64 {
	rho := c.rho()
	r := 1.0 / rho * (c.sp[Vi.north_east] + c.sp[Vi.east] + c.sp[Vi.south_east] - c.sp[Vi.south_west] - c.sp[Vi.west] - c.sp[Vi.north_west])
	assert math.is_nan(r) == false
	return r
}

// uy computes y (vertical) component of cell speed vector.
fn (c &Cell) uy() f64 {
	rho := c.rho()
	r := 1.0 / rho * (-c.sp[Vi.north] - c.sp[Vi.north_east] - c.sp[Vi.north_west] +
		c.sp[Vi.south_east] + c.sp[Vi.south] + c.sp[Vi.south_west])
	assert math.is_nan(r) == false
	return r
}

// ux_no_rho computes x (horizontal) component of cell speed vector, when rho is already known and passed as param.
fn (c &Cell) ux_no_rho(rho f64) f64 {
	r := 1.0 / rho * (c.sp[Vi.north_east] + c.sp[Vi.east] + c.sp[Vi.south_east] - c.sp[Vi.south_west] - c.sp[Vi.west] - c.sp[Vi.north_west])
	return r
}

// uy_no_rho computes y (vertical) component of cell speed vector, when rho is already known and passed as param.
fn (c &Cell) uy_no_rho(rho f64) f64 {
	r := 1.0 / rho * (-c.sp[Vi.north] - c.sp[Vi.north_east] - c.sp[Vi.north_west] +
		c.sp[Vi.south_east] + c.sp[Vi.south] + c.sp[Vi.south_west])
	return r
}

// equ computes result of equilibrium function.
fn (c &Cell) equ(i Vi) f64 {
	rho := c.rho()
	ux := c.ux_no_rho(rho)
	uy := c.uy_no_rho(rho)

	t1 := 3.0 * (ux * dvx_f[i] + uy * dvy_f[i])
	mut t2 := (ux * dvx_f[i] + uy * dvy_f[i])

	t2 *= t2 // t2^2
	t2 *= (9.0 / 2.0)
	t3 := (3.0 / 2.0) * (ux * ux + uy * uy)
	r := wi[i] * rho * (1.0 + t1 + t2 - t3)
	return r
}
