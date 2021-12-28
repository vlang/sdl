// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_rect.h
//

// Point is the structure that defines a point
//
// See also: SDL_EnclosePoints
// See also: SDL_PointInRect
// Point is C.SDL_Point
[typedef]
struct C.SDL_Point {
pub mut:
	x int
	y int
}

pub type Point = C.SDL_Point

// Rect is a rectangle, with the origin at the upper left.
//
// See also: SDL_RectEmpty
// See also: SDL_RectEquals
// See also: SDL_HasIntersection
// See also: SDL_IntersectRect
// See also: SDL_UnionRect
// See also: SDL_EnclosePoints
// Rect is C.SDL_Rect
[typedef]
struct C.SDL_Rect {
pub mut:
	x int
	y int
	w int
	h int
}

pub type Rect = C.SDL_Rect

fn C.SDL_PointInRect(p &C.SDL_Point, r &C.SDL_Rect) bool

// point_in_rect returns true if point resides inside a rectangle.
pub fn point_in_rect(p &C.SDL_Point, r &C.SDL_Rect) bool {
	return C.SDL_PointInRect(p, r)
}

fn C.SDL_RectEmpty(r &C.SDL_Rect) bool

// rect_empty returns true if the rectangle has no area.
pub fn rect_empty(r &C.SDL_Rect) bool {
	return C.SDL_RectEmpty(r)
}

fn C.SDL_RectEquals(a &C.SDL_Rect, b &C.SDL_Rect) bool

// rect_equals returns true if the two rectangles are equal.
pub fn rect_equals(a &C.SDL_Rect, b &C.SDL_Rect) bool {
	return C.SDL_RectEquals(a, b)
}

fn C.SDL_HasIntersection(a &C.SDL_Rect, b &C.SDL_Rect) bool

// has_intersection determine whether two rectangles intersect.
//
// returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
[inline]
pub fn has_intersection(a &Rect, b &Rect) bool {
	return C.SDL_HasIntersection(a, b)
}

fn C.SDL_IntersectRect(a &C.SDL_Rect, b &C.SDL_Rect, result &C.SDL_Rect) bool

// intersect_rect calculate the intersection of two rectangles.
//
// returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
pub fn intersect_rect(a &Rect, b &Rect, result &Rect) bool {
	return C.SDL_IntersectRect(a, b, result)
}

fn C.SDL_UnionRect(a &C.SDL_Rect, b &C.SDL_Rect, result &C.SDL_Rect)

// union_rect calculates the union of two rectangles.
pub fn union_rect(a &Rect, b &Rect, result &Rect) {
	C.SDL_UnionRect(a, b, result)
}

fn C.SDL_EnclosePoints(points &C.SDL_Point, count int, clip &C.SDL_Rect, result &C.SDL_Rect) bool

// enclose_points calculates a minimal rectangle enclosing a set of points
//
// returns SDL_TRUE if any points were within the clipping rect
pub fn enclose_points(points &Point, count int, clip &Rect, result &Rect) bool {
	return C.SDL_EnclosePoints(points, count, clip, result)
}

fn C.SDL_IntersectRectAndLine(rect &C.SDL_Rect, x1 &int, y1 &int, x2 &int, y2 &int) bool

// intersect_rect_and_line calculates the intersection of a rectangle and line segment.
//
// returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
pub fn intersect_rect_and_line(rect &Rect, x1 &int, y1 &int, x2 &int, y2 &int) bool {
	return C.SDL_IntersectRectAndLine(rect, x1, y1, x2, y2)
}
