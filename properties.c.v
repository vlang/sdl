// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_properties.h
//

// A property is a variable that can be created and retrieved by name at
// runtime.
//
// All properties are part of a property group (SDL_PropertiesID). A property
// group can be created with the SDL_CreateProperties function and destroyed
// with the SDL_DestroyProperties function.
//
// Properties can be added to and retrieved from a property group through the
// following functions:
//
// - SDL_SetPointerProperty and SDL_GetPointerProperty operate on `void*`
//   pointer types.
// - SDL_SetStringProperty and SDL_GetStringProperty operate on string types.
// - SDL_SetNumberProperty and SDL_GetNumberProperty operate on signed 64-bit
//   integer types.
// - SDL_SetFloatProperty and SDL_GetFloatProperty operate on floating point
//   types.
// - SDL_SetBooleanProperty and SDL_GetBooleanProperty operate on boolean
//   types.
//
// Properties can be removed from a group by using SDL_ClearProperty.

// SDL properties ID
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type PropertiesID = u32

// PropertyType is C.SDL_PropertyType
pub enum PropertyType {
	invalid = C.SDL_PROPERTY_TYPE_INVALID
	pointer = C.SDL_PROPERTY_TYPE_POINTER
	string  = C.SDL_PROPERTY_TYPE_STRING
	number  = C.SDL_PROPERTY_TYPE_NUMBER
	float   = C.SDL_PROPERTY_TYPE_FLOAT
	boolean = C.SDL_PROPERTY_TYPE_BOOLEAN
}

// C.SDL_GetGlobalProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetGlobalProperties)
fn C.SDL_GetGlobalProperties() PropertiesID

// get_global_properties gets the global SDL properties.
//
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_global_properties() PropertiesID {
	return C.SDL_GetGlobalProperties()
}

// C.SDL_CreateProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_CreateProperties)
fn C.SDL_CreateProperties() PropertiesID

// create_properties creates a group of properties.
//
// All properties are automatically destroyed when SDL_Quit() is called.
//
// returns an ID for a new group of properties, or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: destroy_properties (SDL_DestroyProperties)
pub fn create_properties() PropertiesID {
	return C.SDL_CreateProperties()
}

// C.SDL_CopyProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_CopyProperties)
fn C.SDL_CopyProperties(src PropertiesID, dst PropertiesID) bool

// copy_properties copys a group of properties.
//
// Copy all the properties from one group of properties to another, with the
// exception of properties requiring cleanup (set using
// SDL_SetPointerPropertyWithCleanup()), which will not be copied. Any
// property that already exists on `dst` will be overwritten.
//
// `src` src the properties to copy.
// `dst` dst the destination properties.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn copy_properties(src PropertiesID, dst PropertiesID) bool {
	return C.SDL_CopyProperties(src, dst)
}

// C.SDL_LockProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_LockProperties)
fn C.SDL_LockProperties(props PropertiesID) bool

// lock_properties locks a group of properties.
//
// Obtain a multi-threaded lock for these properties. Other threads will wait
// while trying to lock these properties until they are unlocked. Properties
// must be unlocked before they are destroyed.
//
// The lock is automatically taken when setting individual properties, this
// function is only needed when you want to set several properties atomically
// or want to guarantee that properties being queried aren't freed in another
// thread.
//
// `props` props the properties to lock.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: unlock_properties (SDL_UnlockProperties)
pub fn lock_properties(props PropertiesID) bool {
	return C.SDL_LockProperties(props)
}

// C.SDL_UnlockProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_UnlockProperties)
fn C.SDL_UnlockProperties(props PropertiesID)

// unlock_properties unlocks a group of properties.
//
// `props` props the properties to unlock.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: lock_properties (SDL_LockProperties)
pub fn unlock_properties(props PropertiesID) {
	C.SDL_UnlockProperties(props)
}

// CleanupPropertyCallback as callback used to free resources when a property is deleted.
//
// This should release any resources associated with `value` that are no
// longer needed.
//
// This callback is set per-property. Different properties in the same group
// can have different cleanup callbacks.
//
// This callback will be called _during_ SDL_SetPointerPropertyWithCleanup if
// the function fails for any reason.
//
// `userdata` userdata an app-defined pointer passed to the callback.
// `value` value the pointer assigned to the property to clean up.
//
// NOTE: (thread safety) This callback may fire without any locks held; if this is a
//               concern, the app should provide its own locking.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: set_pointer_property_with_cleanup (SDL_SetPointerPropertyWithCleanup)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_CleanupPropertyCallback)
pub type CleanupPropertyCallback = fn (userdata voidptr, value voidptr)

// C.SDL_SetPointerPropertyWithCleanup [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetPointerPropertyWithCleanup)
fn C.SDL_SetPointerPropertyWithCleanup(props PropertiesID, const_name &char, value voidptr, cleanup CleanupPropertyCallback, userdata voidptr) bool

// set_pointer_property_with_cleanup sets a pointer property in a group of properties with a cleanup function
// that is called when the property is deleted.
//
// The cleanup function is also called if setting the property fails for any
// reason.
//
// For simply setting basic data types, like numbers, bools, or strings, use
// SDL_SetNumberProperty, SDL_SetBooleanProperty, or SDL_SetStringProperty
// instead, as those functions will handle cleanup on your behalf. This
// function is only for more complex, custom data.
//
// `props` props the properties to modify.
// `name` name the name of the property to modify.
// `value` value the new value of the property, or NULL to delete the property.
// `cleanup` cleanup the function to call when this property is deleted, or NULL
//                if no cleanup is necessary.
// `userdata` userdata a pointer that is passed to the cleanup function.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_pointer_property (SDL_GetPointerProperty)
// See also: set_pointer_property (SDL_SetPointerProperty)
// See also: cleanup_property_callback (SDL_CleanupPropertyCallback)
pub fn set_pointer_property_with_cleanup(props PropertiesID, const_name &char, value voidptr, cleanup CleanupPropertyCallback, userdata voidptr) bool {
	return C.SDL_SetPointerPropertyWithCleanup(props, const_name, value, cleanup, userdata)
}

// C.SDL_SetPointerProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetPointerProperty)
fn C.SDL_SetPointerProperty(props PropertiesID, const_name &char, value voidptr) bool

// set_pointer_property sets a pointer property in a group of properties.
//
// `props` props the properties to modify.
// `name` name the name of the property to modify.
// `value` value the new value of the property, or NULL to delete the property.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_pointer_property (SDL_GetPointerProperty)
// See also: has_property (SDL_HasProperty)
// See also: set_boolean_property (SDL_SetBooleanProperty)
// See also: set_float_property (SDL_SetFloatProperty)
// See also: set_number_property (SDL_SetNumberProperty)
// See also: set_pointer_property_with_cleanup (SDL_SetPointerPropertyWithCleanup)
// See also: set_string_property (SDL_SetStringProperty)
pub fn set_pointer_property(props PropertiesID, const_name &char, value voidptr) bool {
	return C.SDL_SetPointerProperty(props, const_name, value)
}

// C.SDL_SetStringProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetStringProperty)
fn C.SDL_SetStringProperty(props PropertiesID, const_name &char, const_value &char) bool

// set_string_property sets a string property in a group of properties.
//
// This function makes a copy of the string; the caller does not have to
// preserve the data after this call completes.
//
// `props` props the properties to modify.
// `name` name the name of the property to modify.
// `value` value the new value of the property, or NULL to delete the property.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_string_property (SDL_GetStringProperty)
pub fn set_string_property(props PropertiesID, const_name &char, const_value &char) bool {
	return C.SDL_SetStringProperty(props, const_name, const_value)
}

// C.SDL_SetNumberProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetNumberProperty)
fn C.SDL_SetNumberProperty(props PropertiesID, const_name &char, value i64) bool

// set_number_property sets an integer property in a group of properties.
//
// `props` props the properties to modify.
// `name` name the name of the property to modify.
// `value` value the new value of the property.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_number_property (SDL_GetNumberProperty)
pub fn set_number_property(props PropertiesID, const_name &char, value i64) bool {
	return C.SDL_SetNumberProperty(props, const_name, value)
}

// C.SDL_SetFloatProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetFloatProperty)
fn C.SDL_SetFloatProperty(props PropertiesID, const_name &char, value f32) bool

// set_float_property sets a floating point property in a group of properties.
//
// `props` props the properties to modify.
// `name` name the name of the property to modify.
// `value` value the new value of the property.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_float_property (SDL_GetFloatProperty)
pub fn set_float_property(props PropertiesID, const_name &char, value f32) bool {
	return C.SDL_SetFloatProperty(props, const_name, value)
}

// C.SDL_SetBooleanProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_SetBooleanProperty)
fn C.SDL_SetBooleanProperty(props PropertiesID, const_name &char, value bool) bool

// set_boolean_property sets a boolean property in a group of properties.
//
// `props` props the properties to modify.
// `name` name the name of the property to modify.
// `value` value the new value of the property.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_boolean_property (SDL_GetBooleanProperty)
pub fn set_boolean_property(props PropertiesID, const_name &char, value bool) bool {
	return C.SDL_SetBooleanProperty(props, const_name, value)
}

// C.SDL_HasProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_HasProperty)
fn C.SDL_HasProperty(props PropertiesID, const_name &char) bool

// has_property returns whether a property exists in a group of properties.
//
// `props` props the properties to query.
// `name` name the name of the property to query.
// returns true if the property exists, or false if it doesn't.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_property_type (SDL_GetPropertyType)
pub fn has_property(props PropertiesID, const_name &char) bool {
	return C.SDL_HasProperty(props, const_name)
}

// C.SDL_GetPropertyType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPropertyType)
fn C.SDL_GetPropertyType(props PropertiesID, const_name &char) PropertyType

// get_property_type gets the type of a property in a group of properties.
//
// `props` props the properties to query.
// `name` name the name of the property to query.
// returns the type of the property, or SDL_PROPERTY_TYPE_INVALID if it is
//          not set.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: has_property (SDL_HasProperty)
pub fn get_property_type(props PropertiesID, const_name &char) PropertyType {
	return C.SDL_GetPropertyType(props, const_name)
}

// C.SDL_GetPointerProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetPointerProperty)
fn C.SDL_GetPointerProperty(props PropertiesID, const_name &char, default_value voidptr) voidptr

// get_pointer_property gets a pointer property from a group of properties.
//
// By convention, the names of properties that SDL exposes on objects will
// start with "SDL.", and properties that SDL uses internally will start with
// "SDL.internal.". These should be considered read-only and should not be
// modified by applications.
//
// `props` props the properties to query.
// `name` name the name of the property to query.
// `default_value` default_value the default value of the property.
// returns the value of the property, or `default_value` if it is not set or
//          not a pointer property.
//
// NOTE: (thread safety) It is safe to call this function from any thread, although
//               the data returned is not protected and could potentially be
//               freed if you call SDL_SetPointerProperty() or
//               SDL_ClearProperty() on these properties from another thread.
//               If you need to avoid this, use SDL_LockProperties() and
//               SDL_UnlockProperties().
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_boolean_property (SDL_GetBooleanProperty)
// See also: get_float_property (SDL_GetFloatProperty)
// See also: get_number_property (SDL_GetNumberProperty)
// See also: get_property_type (SDL_GetPropertyType)
// See also: get_string_property (SDL_GetStringProperty)
// See also: has_property (SDL_HasProperty)
// See also: set_pointer_property (SDL_SetPointerProperty)
pub fn get_pointer_property(props PropertiesID, const_name &char, default_value voidptr) voidptr {
	return C.SDL_GetPointerProperty(props, const_name, default_value)
}

// C.SDL_GetStringProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetStringProperty)
fn C.SDL_GetStringProperty(props PropertiesID, const_name &char, const_default_value &char) &char

// get_string_property gets a string property from a group of properties.
//
// `props` props the properties to query.
// `name` name the name of the property to query.
// `default_value` default_value the default value of the property.
// returns the value of the property, or `default_value` if it is not set or
//          not a string property.
//
// NOTE: (thread safety) It is safe to call this function from any thread, although
//               the data returned is not protected and could potentially be
//               freed if you call SDL_SetStringProperty() or
//               SDL_ClearProperty() on these properties from another thread.
//               If you need to avoid this, use SDL_LockProperties() and
//               SDL_UnlockProperties().
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_property_type (SDL_GetPropertyType)
// See also: has_property (SDL_HasProperty)
// See also: set_string_property (SDL_SetStringProperty)
pub fn get_string_property(props PropertiesID, const_name &char, const_default_value &char) &char {
	return C.SDL_GetStringProperty(props, const_name, const_default_value)
}

// C.SDL_GetNumberProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetNumberProperty)
fn C.SDL_GetNumberProperty(props PropertiesID, const_name &char, default_value i64) i64

// get_number_property gets a number property from a group of properties.
//
// You can use SDL_GetPropertyType() to query whether the property exists and
// is a number property.
//
// `props` props the properties to query.
// `name` name the name of the property to query.
// `default_value` default_value the default value of the property.
// returns the value of the property, or `default_value` if it is not set or
//          not a number property.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_property_type (SDL_GetPropertyType)
// See also: has_property (SDL_HasProperty)
// See also: set_number_property (SDL_SetNumberProperty)
pub fn get_number_property(props PropertiesID, const_name &char, default_value i64) i64 {
	return C.SDL_GetNumberProperty(props, const_name, default_value)
}

// C.SDL_GetFloatProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetFloatProperty)
fn C.SDL_GetFloatProperty(props PropertiesID, const_name &char, default_value f32) f32

// get_float_property gets a floating point property from a group of properties.
//
// You can use SDL_GetPropertyType() to query whether the property exists and
// is a floating point property.
//
// `props` props the properties to query.
// `name` name the name of the property to query.
// `default_value` default_value the default value of the property.
// returns the value of the property, or `default_value` if it is not set or
//          not a float property.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_property_type (SDL_GetPropertyType)
// See also: has_property (SDL_HasProperty)
// See also: set_float_property (SDL_SetFloatProperty)
pub fn get_float_property(props PropertiesID, const_name &char, default_value f32) f32 {
	return C.SDL_GetFloatProperty(props, const_name, default_value)
}

// C.SDL_GetBooleanProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetBooleanProperty)
fn C.SDL_GetBooleanProperty(props PropertiesID, const_name &char, default_value bool) bool

// get_boolean_property gets a boolean property from a group of properties.
//
// You can use SDL_GetPropertyType() to query whether the property exists and
// is a boolean property.
//
// `props` props the properties to query.
// `name` name the name of the property to query.
// `default_value` default_value the default value of the property.
// returns the value of the property, or `default_value` if it is not set or
//          not a boolean property.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_property_type (SDL_GetPropertyType)
// See also: has_property (SDL_HasProperty)
// See also: set_boolean_property (SDL_SetBooleanProperty)
pub fn get_boolean_property(props PropertiesID, const_name &char, default_value bool) bool {
	return C.SDL_GetBooleanProperty(props, const_name, default_value)
}

// C.SDL_ClearProperty [official documentation](https://wiki.libsdl.org/SDL3/SDL_ClearProperty)
fn C.SDL_ClearProperty(props PropertiesID, const_name &char) bool

// clear_property clears a property from a group of properties.
//
// `props` props the properties to modify.
// `name` name the name of the property to clear.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn clear_property(props PropertiesID, const_name &char) bool {
	return C.SDL_ClearProperty(props, const_name)
}

// EnumeratePropertiesCallback as callback used to enumerate all the properties in a group of properties.
//
// This callback is called from SDL_EnumerateProperties(), and is called once
// per property in the set.
//
// `userdata` userdata an app-defined pointer passed to the callback.
// `props` props the SDL_PropertiesID that is being enumerated.
// `name` name the next property name in the enumeration.
//
// NOTE: (thread safety) SDL_EnumerateProperties holds a lock on `props` during this
//               callback.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: enumerate_properties (SDL_EnumerateProperties)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_EnumeratePropertiesCallback)
pub type EnumeratePropertiesCallback = fn (userdata voidptr, props PropertiesID, const_name &char)

// C.SDL_EnumerateProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_EnumerateProperties)
fn C.SDL_EnumerateProperties(props PropertiesID, callback EnumeratePropertiesCallback, userdata voidptr) bool

// enumerate_properties enumerates the properties contained in a group of properties.
//
// The callback function is called for each property in the group of
// properties. The properties are locked during enumeration.
//
// `props` props the properties to query.
// `callback` callback the function to call for each property.
// `userdata` userdata a pointer that is passed to `callback`.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn enumerate_properties(props PropertiesID, callback EnumeratePropertiesCallback, userdata voidptr) bool {
	return C.SDL_EnumerateProperties(props, callback, userdata)
}

// C.SDL_DestroyProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_DestroyProperties)
fn C.SDL_DestroyProperties(props PropertiesID)

// destroy_properties destroys a group of properties.
//
// All properties are deleted and their cleanup functions will be called, if
// any.
//
// `props` props the properties to destroy.
//
// NOTE: (thread safety) This function should not be called while these properties are
//               locked or other threads might be setting or getting values
//               from these properties.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: create_properties (SDL_CreateProperties)
pub fn destroy_properties(props PropertiesID) {
	C.SDL_DestroyProperties(props)
}
