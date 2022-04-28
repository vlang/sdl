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
[typedef]
struct C.SDL_Point {
pub mut:
	x int
	y int
}

pub type Point = C.SDL_Point

// FPoint is the structure that defines a point (floating point)
//
// See also: SDL_EncloseFPoints
// See also: SDL_PointInFRect
// FPoint is C.SDL_FPoint
[typedef]
struct C.SDL_FPoint {
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
// See also: SDL_IntersectRectAndLine
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

// FRect is a rectangle, with the origin at the upper left (floating point).
//
// See also: SDL_FRectEmpty
// See also: SDL_FRectEquals
// See also: SDL_FRectEqualsEpsilon
// See also: SDL_HasIntersectionF
// See also: SDL_IntersectFRect
// See also: SDL_IntersectFRectAndLine
// See also: SDL_UnionFRect
// See also: SDL_EncloseFPoints
// See also: SDL_PointInFRect
//
// FRect is C.SDL_FRect
[typedef]
struct C.SDL_FRect {
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
[inline]
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

// SDL_FRect versions...

fn C.SDL_PointInFRect(const_p &C.SDL_FPoint, const_r &C.SDL_FRect) bool

// point_in_frect returns true if point resides inside a rectangle.
pub fn point_in_frect(const_p &FPoint, const_r &FRect) bool {
	return C.SDL_PointInFRect(const_p, const_r)
}

fn C.SDL_FRectEmpty(const_r &C.SDL_FRect) bool

// frect_empty returns true if the rectangle has no area.
pub fn frect_empty(const_r &FRect) bool {
	return C.SDL_FRectEmpty(const_r)
}

fn C.SDL_FRectEqualsEpsilon(const_a &C.SDL_FRect, const_b &C.SDL_FRect, const_epsilon f32) bool

// frect_equals_epsilon returns true if the two rectangles are equal, within some given epsilon.
//
// NOTE This function is available since SDL 2.0.22.
pub fn frect_equals_epsilon(const_a &FRect, const_b &FRect, const_epsilon f32) bool {
	return C.SDL_FRectEqualsEpsilon(const_a, const_b, const_epsilon)
}

fn C.SDL_FRectEquals(const_a &C.SDL_FRect, const_b &C.SDL_FRect) bool

// frect_equals returns true if the two rectangles are equal, using a default epsilon.
//
// NOTE This function is available since SDL 2.0.22.
pub fn frect_equals(const_a &FRect, const_b &FRect) bool {
	return C.SDL_FRectEquals(const_a, const_b)
}

fn C.SDL_HasIntersectionF(const_a &C.SDL_FRect, const_b &C.SDL_FRect) bool

// has_intersection_f determines whether two rectangles intersect with float precision.
//
// If either pointer is NULL the function will return SDL_FALSE.
//
// `A` an SDL_FRect structure representing the first rectangle
// `B` an SDL_FRect structure representing the second rectangle
// returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.22.
//
// See also: SDL_IntersectRect
pub fn has_intersection_f(const_a &FRect, const_b &FRect) bool {
	return C.SDL_HasIntersectionF(const_a, const_b)
}

fn C.SDL_IntersectFRect(const_a &C.SDL_FRect, const_b &C.SDL_FRect, result &C.SDL_FRect) bool

// intersect_frect calculates the intersection of two rectangles with float precision.
//
// If `result` is NULL then this function will return SDL_FALSE.
//
// `A` an SDL_FRect structure representing the first rectangle
// `B` an SDL_FRect structure representing the second rectangle
// `result` an SDL_FRect structure filled in with the intersection of
//               rectangles `A` and `B`
// returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.22.
//
// See also: SDL_HasIntersectionF
pub fn intersect_frect(const_a &FRect, const_b &FRect, result &FRect) bool {
	return C.SDL_IntersectFRect(const_a, const_b, result)
}

fn C.SDL_UnionFRect(const_a &C.SDL_FRect, const_b &C.SDL_FRect, result &C.SDL_FRect)

// union_frect calculates the union of two rectangles with float precision.
//
// `A` an SDL_FRect structure representing the first rectangle
// `B` an SDL_FRect structure representing the second rectangle
// `result` an SDL_FRect structure filled in with the union of rectangles
//               `A` and `B`
//
// NOTE This function is available since SDL 2.0.22.
pub fn union_frect(const_a &FRect, const_b &FRect, result &FRect) {
	C.SDL_UnionFRect(const_a, const_b, result)
}

fn C.SDL_EncloseFPoints(const_points &C.SDL_FPoint, count int, const_clip &C.SDL_FRect, result &C.SDL_FRect) bool

// enclose_f_points calculates a minimal rectangle enclosing a set of points with float
// precision.
//
// If `clip` is not NULL then only points inside of the clipping rectangle are
// considered.
//
// `points` an array of SDL_FPoint structures representing points to be
//               enclosed
// `count` the number of structures in the `points` array
// `clip` an SDL_FRect used for clipping or NULL to enclose all points
// `result` an SDL_FRect structure filled in with the minimal enclosing
//               rectangle
// returns SDL_TRUE if any points were enclosed or SDL_FALSE if all the
//          points were outside of the clipping rectangle.
//
// NOTE This function is available since SDL 2.0.22.
pub fn enclose_f_points(const_points &FPoint, count int, const_clip &FRect, result &FRect) bool {
	return C.SDL_EncloseFPoints(const_points, count, const_clip, result)
}

fn C.SDL_IntersectFRectAndLine(const_rect &C.SDL_FRect, x1 &f32, y1 &f32, x2 &f32, y2 &f32) bool

// intersect_frect_and_line calculates the intersection of a rectangle and line segment with float
// precision.
//
// This function is used to clip a line segment to a rectangle. A line segment
// contained entirely within the rectangle or that does not intersect will
// remain unchanged. A line segment that crosses the rectangle at either or
// both ends will be clipped to the boundary of the rectangle and the new
// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
//
// `rect` an SDL_FRect structure representing the rectangle to intersect
// `X1` a pointer to the starting X-coordinate of the line
// `Y1` a pointer to the starting Y-coordinate of the line
// `X2` a pointer to the ending X-coordinate of the line
// `Y2` a pointer to the ending Y-coordinate of the line
// returns SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
//
// NOTE This function is available since SDL 2.0.22.
pub fn intersect_frect_and_line(const_rect &FRect, x1 &f32, y1 &f32, x2 &f32, y2 &f32) bool {
	return C.SDL_IntersectFRectAndLine(const_rect, x1, y1, x2, y2)
}
