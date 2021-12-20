// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_rect.h
//


/**
 *  \brief  The structure that defines a point
 *
 *  \sa SDL_EnclosePoints
 *  \sa SDL_PointInRect
 */
[typedef]
struct C.SDL_Point {
	x int
	y int
}
pub type Point = C.SDL_Point


/**
 *  \brief A rectangle, with the origin at the upper left.
 *
 *  \sa SDL_RectEmpty
 *  \sa SDL_RectEquals
 *  \sa SDL_HasIntersection
 *  \sa SDL_IntersectRect
 *  \sa SDL_UnionRect
 *  \sa SDL_EnclosePoints
 */
[typedef]
struct C.SDL_Rect {
	x int
	y int
	w int
	h  int
}
pub type Rect = C.SDL_Rect



/**
 *  \brief Determine whether two rectangles intersect.
 *
 *  \return SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 */
fn C.SDL_HasIntersection(a &C.SDL_Rect, b &C.SDL_Rect) bool
[inline]
pub fn has_intersection(a &Rect, b &Rect) bool{
	return C.SDL_HasIntersection(a, b)
}

/**
 *  \brief Calculate the intersection of two rectangles.
 *
 *  \return SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 */
fn C.SDL_IntersectRect(a &C.SDL_Rect, b &C.SDL_Rect, result &C.SDL_Rect) bool
pub fn intersect_rect(a &Rect, b &Rect, result &Rect) bool{
	return C.SDL_IntersectRect(a, b, result)
}

/**
 *  \brief Calculate the union of two rectangles.
 */
fn C.SDL_UnionRect(a &C.SDL_Rect, b &C.SDL_Rect, result &C.SDL_Rect)
pub fn union_rect(a &Rect, b &Rect, result &Rect){
	 C.SDL_UnionRect(a, b, result)
}

/**
 *  \brief Calculate a minimal rectangle enclosing a set of points
 *
 *  \return SDL_TRUE if any points were within the clipping rect
 */
fn C.SDL_EnclosePoints(points &C.SDL_Point, count int, clip &C.SDL_Rect, result &C.SDL_Rect) bool
pub fn enclose_points(points &Point, count int, clip &Rect, result &Rect) bool{
	return C.SDL_EnclosePoints(points, count, clip, result)
}

/**
 *  \brief Calculate the intersection of a rectangle and line segment.
 *
 *  \return SDL_TRUE if there is an intersection, SDL_FALSE otherwise.
 */
fn C.SDL_IntersectRectAndLine(rect &C.SDL_Rect, x1 &int, y1 &int, x2 &int, y2 &int) bool
pub fn intersect_rect_and_line(rect &Rect, x1 &int, y1 &int, x2 &int, y2 &int) bool{
	return C.SDL_IntersectRectAndLine(rect, x1, y1, x2, y2)
}
