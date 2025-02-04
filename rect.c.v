// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_rect.h
//

// Some helper functions for managing rectangles and 2D points, in both
// integer and floating point versions.

// The structure that defines a point (using integers).
//
// NOTE: This struct is available since SDL 3.2.0.
//
// See also: SDL_GetRectEnclosingPoints
// See also: SDL_PointInRect
@[typedef]
pub struct C.SDL_Point {
pub mut:
	x int
	y int
}

pub type Point = C.SDL_Point

// The structure that defines a point (using floating point values).
//
// NOTE: This struct is available since SDL 3.2.0.
//
// See also: SDL_GetRectEnclosingPointsFloat
// See also: SDL_PointInRectFloat
@[typedef]
pub struct C.SDL_FPoint {
pub mut:
	x f32
	y f32
}

pub type FPoint = C.SDL_FPoint

// A rectangle, with the origin at the upper left (using integers).
//
// NOTE: This struct is available since SDL 3.2.0.
//
// See also: SDL_RectEmpty
// See also: SDL_RectsEqual
// See also: SDL_HasRectIntersection
// See also: SDL_GetRectIntersection
// See also: SDL_GetRectAndLineIntersection
// See also: SDL_GetRectUnion
// See also: SDL_GetRectEnclosingPoints
@[typedef]
pub struct C.SDL_Rect {
pub mut:
	x int
	y int
	w int
	h int
}

pub type Rect = C.SDL_Rect

// A rectangle, with the origin at the upper left (using floating point
// values).
//
// NOTE: This struct is available since SDL 3.2.0.
//
// See also: SDL_RectEmptyFloat
// See also: SDL_RectsEqualFloat
// See also: SDL_RectsEqualEpsilon
// See also: SDL_HasRectIntersectionFloat
// See also: SDL_GetRectIntersectionFloat
// See also: SDL_GetRectAndLineIntersectionFloat
// See also: SDL_GetRectUnionFloat
// See also: SDL_GetRectEnclosingPointsFloat
// See also: SDL_PointInRectFloat
@[typedef]
pub struct C.SDL_FRect {
pub mut:
	x f32
	y f32
	w f32
	h f32
}

pub type FRect = C.SDL_FRect

// C.SDL_HasRectIntersection [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasRectIntersection)
fn C.SDL_HasRectIntersection(const_a &Rect, const_b &Rect) bool

// has_rect_intersection determines whether two rectangles intersect.
//
// If either pointer is NULL the function will return false.
//
// `a` A an SDL_Rect structure representing the first rectangle.
// `b` B an SDL_Rect structure representing the second rectangle.
// returns true if there is an intersection, false otherwise.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_rect_intersection (SDL_GetRectIntersection)
pub fn has_rect_intersection(const_a &Rect, const_b &Rect) bool {
	return C.SDL_HasRectIntersection(const_a, const_b)
}

// C.SDL_GetRectIntersection [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRectIntersection)
fn C.SDL_GetRectIntersection(const_a &Rect, const_b &Rect, result &Rect) bool

// get_rect_intersection calculates the intersection of two rectangles.
//
// If `result` is NULL then this function will return false.
//
// `a` A an SDL_Rect structure representing the first rectangle.
// `b` B an SDL_Rect structure representing the second rectangle.
// `result` result an SDL_Rect structure filled in with the intersection of
//               rectangles `A` and `B`.
// returns true if there is an intersection, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_rect_intersection (SDL_HasRectIntersection)
pub fn get_rect_intersection(const_a &Rect, const_b &Rect, result &Rect) bool {
	return C.SDL_GetRectIntersection(const_a, const_b, result)
}

// C.SDL_GetRectUnion [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRectUnion)
fn C.SDL_GetRectUnion(const_a &Rect, const_b &Rect, result &Rect) bool

// get_rect_union calculates the union of two rectangles.
//
// `a` A an SDL_Rect structure representing the first rectangle.
// `b` B an SDL_Rect structure representing the second rectangle.
// `result` result an SDL_Rect structure filled in with the union of rectangles
//               `A` and `B`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_rect_union(const_a &Rect, const_b &Rect, result &Rect) bool {
	return C.SDL_GetRectUnion(const_a, const_b, result)
}

// C.SDL_GetRectEnclosingPoints [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRectEnclosingPoints)
fn C.SDL_GetRectEnclosingPoints(const_points &Point, count int, const_clip &Rect, result &Rect) bool

// get_rect_enclosing_points calculates a minimal rectangle enclosing a set of points.
//
// If `clip` is not NULL then only points inside of the clipping rectangle are
// considered.
//
// `points` points an array of SDL_Point structures representing points to be
//               enclosed.
// `count` count the number of structures in the `points` array.
// `clip` clip an SDL_Rect used for clipping or NULL to enclose all points.
// `result` result an SDL_Rect structure filled in with the minimal enclosing
//               rectangle.
// returns true if any points were enclosed or false if all the points were
//          outside of the clipping rectangle.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_rect_enclosing_points(const_points &Point, count int, const_clip &Rect, result &Rect) bool {
	return C.SDL_GetRectEnclosingPoints(const_points, count, const_clip, result)
}

// C.SDL_GetRectAndLineIntersection [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRectAndLineIntersection)
fn C.SDL_GetRectAndLineIntersection(const_rect &Rect, x1 &int, y1 &int, x2 &int, y2 &int) bool

// get_rect_and_line_intersection calculates the intersection of a rectangle and line segment.
//
// This function is used to clip a line segment to a rectangle. A line segment
// contained entirely within the rectangle or that does not intersect will
// remain unchanged. A line segment that crosses the rectangle at either or
// both ends will be clipped to the boundary of the rectangle and the new
// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
//
// `rect` rect an SDL_Rect structure representing the rectangle to intersect.
// `x1` X1 a pointer to the starting X-coordinate of the line.
// `y1` Y1 a pointer to the starting Y-coordinate of the line.
// `x2` X2 a pointer to the ending X-coordinate of the line.
// `y2` Y2 a pointer to the ending Y-coordinate of the line.
// returns true if there is an intersection, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_rect_and_line_intersection(const_rect &Rect, x1 &int, y1 &int, x2 &int, y2 &int) bool {
	return C.SDL_GetRectAndLineIntersection(const_rect, x1, y1, x2, y2)
}

// C.SDL_HasRectIntersectionFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasRectIntersectionFloat)
fn C.SDL_HasRectIntersectionFloat(const_a &FRect, const_b &FRect) bool

// has_rect_intersection_float determines whether two rectangles intersect with float precision.
//
// If either pointer is NULL the function will return false.
//
// `a` A an SDL_FRect structure representing the first rectangle.
// `b` B an SDL_FRect structure representing the second rectangle.
// returns true if there is an intersection, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_rect_intersection (SDL_GetRectIntersection)
pub fn has_rect_intersection_float(const_a &FRect, const_b &FRect) bool {
	return C.SDL_HasRectIntersectionFloat(const_a, const_b)
}

// C.SDL_GetRectIntersectionFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRectIntersectionFloat)
fn C.SDL_GetRectIntersectionFloat(const_a &FRect, const_b &FRect, result &FRect) bool

// get_rect_intersection_float calculates the intersection of two rectangles with float precision.
//
// If `result` is NULL then this function will return false.
//
// `a` A an SDL_FRect structure representing the first rectangle.
// `b` B an SDL_FRect structure representing the second rectangle.
// `result` result an SDL_FRect structure filled in with the intersection of
//               rectangles `A` and `B`.
// returns true if there is an intersection, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_rect_intersection_float (SDL_HasRectIntersectionFloat)
pub fn get_rect_intersection_float(const_a &FRect, const_b &FRect, result &FRect) bool {
	return C.SDL_GetRectIntersectionFloat(const_a, const_b, result)
}

// C.SDL_GetRectUnionFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRectUnionFloat)
fn C.SDL_GetRectUnionFloat(const_a &FRect, const_b &FRect, result &FRect) bool

// get_rect_union_float calculates the union of two rectangles with float precision.
//
// `a` A an SDL_FRect structure representing the first rectangle.
// `b` B an SDL_FRect structure representing the second rectangle.
// `result` result an SDL_FRect structure filled in with the union of rectangles
//               `A` and `B`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_rect_union_float(const_a &FRect, const_b &FRect, result &FRect) bool {
	return C.SDL_GetRectUnionFloat(const_a, const_b, result)
}

// C.SDL_GetRectEnclosingPointsFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRectEnclosingPointsFloat)
fn C.SDL_GetRectEnclosingPointsFloat(const_points &FPoint, count int, const_clip &FRect, result &FRect) bool

// get_rect_enclosing_points_float calculates a minimal rectangle enclosing a set of points with float
// precision.
//
// If `clip` is not NULL then only points inside of the clipping rectangle are
// considered.
//
// `points` points an array of SDL_FPoint structures representing points to be
//               enclosed.
// `count` count the number of structures in the `points` array.
// `clip` clip an SDL_FRect used for clipping or NULL to enclose all points.
// `result` result an SDL_FRect structure filled in with the minimal enclosing
//               rectangle.
// returns true if any points were enclosed or false if all the points were
//          outside of the clipping rectangle.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_rect_enclosing_points_float(const_points &FPoint, count int, const_clip &FRect, result &FRect) bool {
	return C.SDL_GetRectEnclosingPointsFloat(const_points, count, const_clip, result)
}

// C.SDL_GetRectAndLineIntersectionFloat [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetRectAndLineIntersectionFloat)
fn C.SDL_GetRectAndLineIntersectionFloat(const_rect &FRect, x1 &f32, y1 &f32, x2 &f32, y2 &f32) bool

// get_rect_and_line_intersection_float calculates the intersection of a rectangle and line segment with float
// precision.
//
// This function is used to clip a line segment to a rectangle. A line segment
// contained entirely within the rectangle or that does not intersect will
// remain unchanged. A line segment that crosses the rectangle at either or
// both ends will be clipped to the boundary of the rectangle and the new
// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
//
// `rect` rect an SDL_FRect structure representing the rectangle to intersect.
// `x1` X1 a pointer to the starting X-coordinate of the line.
// `y1` Y1 a pointer to the starting Y-coordinate of the line.
// `x2` X2 a pointer to the ending X-coordinate of the line.
// `y2` Y2 a pointer to the ending Y-coordinate of the line.
// returns true if there is an intersection, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_rect_and_line_intersection_float(const_rect &FRect, x1 &f32, y1 &f32, x2 &f32, y2 &f32) bool {
	return C.SDL_GetRectAndLineIntersectionFloat(const_rect, x1, y1, x2, y2)
}
