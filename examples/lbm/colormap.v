module main

import arrays

struct Colormap {}

// build a linear color map ARGB8888 from color c1 to c2, of steps colors
pub fn Colormap.build(c1 u32, c2 u32, steps int) []u32 {
	assert steps > 1, 'Error, generating colormap needs at least two steps.'
	mut cm := []u32{cap: steps}

	// split c1 & c2 to RGB channels.
	mut c1_r := f64((c1 & 0xFF0000) >> 16)
	mut c1_g := f64((c1 & 0xFF00) >> 8)
	mut c1_b := f64((c1 & 0xFF))

	c2_r := f64((c2 & 0xFF0000) >> 16)
	c2_g := f64((c2 & 0xFF00) >> 8)
	c2_b := f64((c2 & 0xFF))

	delta_r := (c2_r - c1_r) / f64(steps - 1)
	delta_g := (c2_g - c1_g) / f64(steps - 1)
	delta_b := (c2_b - c1_b) / f64(steps - 1)

	cm << (0xFF000000 | c1) // Emit exact start color.
	for _ in 1 .. steps - 1 {
		c1_r += delta_r
		c1_g += delta_g
		c1_b += delta_b

		// Recompose 3 channels to ARGB8888 color.
		mut c := u32(0xFF_00_00_00)
		c |= u32(c1_r) << 16
		c |= u32(c1_g) << 8
		c |= u32(c1_b)
		cm << c
	}
	cm << (0xFF000000 | c2) // Emit exact end color.
	return cm
}



// dual creates a color map with start color, intermediate color and final color, equaly sized.
fn Colormap.dual(c1 u32, c2 u32, c3 u32, steps int) []u32 {
	assert steps > 2, 'Error, generating dual-colormap needs at least three steps.'
	return arrays.append(Colormap.build(c1, c2, steps / 2), Colormap.build(c2, c3, steps - (steps / 2)))
}
