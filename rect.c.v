// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_rect.h
//

// Point is the structure that defines a point (integer)
//
// See also: SDL_EnclosePoints
// See also: SDL_PointInRect
// Point is C.SDL_Point
@[typedef]
pub struct C.SDL_Point {
pub mut:
	x int
	y int
}

pub type Point = C.SDL_Point

// FPoint is the structure that defines a point (floating point)
//
// See also: SDL_EnclosePoints
// See also: SDL_PointInRect
// FPoint is C.SDL_FPoint
@[typedef]
pub struct C.SDL_FPoint {
pub mut:
	x f32
	y f32
}

pub type FPoint = C.SDL_FPoint

// Rect is a rectangle, with the origin at the upper left (integer).
//
// See also: SDL_RectEmpty
// See also: SDL_RectEquals
// See also: SDL_HasIntersection
// See also: SDL_IntersectRect
// See also: SDL_UnionRect
// See also: SDL_EnclosePoints
// Rect is C.SDL_Rect
@[typedef]
pub struct C.SDL_Rect {
pub mut:
	x int
	y int
	w int
	h int
}

pub type Rect = C.SDL_Rect

// FRect is a rectangle, with the origin at the upper left (floating point).
// FRect is C.SDL_FRect
@[typedef]
pub struct C.SDL_FRect {
pub mut:
	x f32
	y f32
	w f32
	h f32
}

pub type FRect = C.SDL_FRect

fn C.SDL_PointInRect(const_p &C.SDL_Point, const_r &C.SDL_Rect) bool

// point_in_rect returns true if point resides inside a rectangle.
pub fn point_in_rect(const_p &Point, const_r &Rect) bool {
	return C.SDL_PointInRect(const_p, const_r)
}

fn C.SDL_RectEmpty(r &C.SDL_Rect) bool

// rect_empty returns true if the rectangle has no area.
pub fn rect_empty(r &Rect) bool {
	return C.SDL_RectEmpty(r)
}

fn C.SDL_RectEquals(const_a &C.SDL_Rect, const_b &C.SDL_Rect) bool

// rect_equals returns true if the two rectangles are equal.
pub fn rect_equals(const_a &Rect, const_b &Rect) bool {
	return C.SDL_RectEquals(const_a, const_b)
}

fn C.SDL_HasIntersection(const_a &C.SDL_Rect, const_b &C.SDL_Rect) bool

// has_intersection determines whether two rectangles intersect.
//
// If either pointer is NULL the function will return SDL_FALSE.
//
// `A` an SDL_Rect structure representing the first rectangle
// `B` an SDL_Rect structure representing the second rectangle
// returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_IntersectRect
@[inline]
pub fn has_intersection(const_a &Rect, const_b &Rect) bool {
	return C.SDL_HasIntersection(const_a, const_b)
}

fn C.SDL_IntersectRect(const_a &C.SDL_Rect, const_b &C.SDL_Rect, result &C.SDL_Rect) bool

// intersect_rect calculates the intersection of two rectangles.
//
// If `result` is NULL then this function will return SDL_FALSE.
//
// `A` an SDL_Rect structure representing the first rectangle
// `B` an SDL_Rect structure representing the second rectangle
// `result` an SDL_Rect structure filled in with the intersection of
//               rectangles `A` and `B`
// returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_HasIntersection
pub fn intersect_rect(const_a &Rect, const_b &Rect, result &Rect) bool {
	return C.SDL_IntersectRect(const_a, const_b, result)
}

fn C.SDL_UnionRect(const_a &C.SDL_Rect, const_b &C.SDL_Rect, result &C.SDL_Rect)

// union_rect calculates the union of two rectangles.
//
// `A` an SDL_Rect structure representing the first rectangle
// `B` an SDL_Rect structure representing the second rectangle
// `result` an SDL_Rect structure filled in with the union of rectangles
//               `A` and `B`
//
// NOTE This function is available since SDL 2.0.0.
pub fn union_rect(const_a &Rect, const_b &Rect, result &Rect) {
	C.SDL_UnionRect(const_a, const_b, result)
}

fn C.SDL_EnclosePoints(const_points &C.SDL_Point, count int, const_clip &C.SDL_Rect, result &C.SDL_Rect) bool

// enclose_points calculates a minimal rectangle enclosing a set of points.
//
// If `clip` is not NULL then only points inside of the clipping rectangle are
// considered.
//
// `points` an array of SDL_Point structures representing points to be
//               enclosed
// `count` the number of structures in the `points` array
// `clip` an SDL_Rect used for clipping or NULL to enclose all points
// `result` an SDL_Rect structure filled in with the minimal enclosing
//               rectangle
// returns SDL_TRUE if any points were enclosed or SDL_FALSE if all the
//          points were outside of the clipping rectangle.
//
// NOTE This function is available since SDL 2.0.0.
pub fn enclose_points(const_points &Point, count int, const_clip &Rect, result &Rect) bool {
	return C.SDL_EnclosePoints(const_points, count, const_clip, result)
}

fn C.SDL_IntersectRectAndLine(rect &C.SDL_Rect, x1 &int, y1 &int, x2 &int, y2 &int) bool

// intersect_rect_and_line calculates the intersection of a rectangle and line segment.
//
// This function is used to clip a line segment to a rectangle. A line segment
// contained entirely within the rectangle or that does not intersect will
// remain unchanged. A line segment that crosses the rectangle at either or
// both ends will be clipped to the boundary of the rectangle and the new
// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
//
// `rect` an SDL_Rect structure representing the rectangle to intersect
// `X1` a pointer to the starting X-coordinate of the line
// `Y1` a pointer to the starting Y-coordinate of the line
// `X2` a pointer to the ending X-coordinate of the line
// `Y2` a pointer to the ending Y-coordinate of the line
// returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.0.
pub fn intersect_rect_and_line(rect &Rect, x1 &int, y1 &int, x2 &int, y2 &int) bool {
	return C.SDL_IntersectRectAndLine(rect, x1, y1, x2, y2)
}
