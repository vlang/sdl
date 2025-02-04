// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

// C.SDL_GetAndroidJNIEnv [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAndroidJNIEnv)
fn C.SDL_GetAndroidJNIEnv() voidptr

// get_android_jni_env gets the Android Java Native Interface Environment of the current thread.
//
// This is the JNIEnv one needs to access the Java virtual machine from native
// code, and is needed for many Android APIs to be usable from C.
//
// The prototype of the function in SDL's code actually declare a void* return
// type, even if the implementation returns a pointer to a JNIEnv. The
// rationale being that the SDL headers can avoid including jni.h.
//
// returns a pointer to Java native interface object (JNIEnv) to which the
//          current thread is attached, or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_android_activity (SDL_GetAndroidActivity)
pub fn get_android_jni_env() voidptr {
	return C.SDL_GetAndroidJNIEnv()
}

// C.SDL_GetAndroidActivity [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAndroidActivity)
fn C.SDL_GetAndroidActivity() voidptr

// get_android_activity retrieves the Java instance of the Android activity class.
//
// The prototype of the function in SDL's code actually declares a void*
// return type, even if the implementation returns a jobject. The rationale
// being that the SDL headers can avoid including jni.h.
//
// The jobject returned by the function is a local reference and must be
// released by the caller. See the PushLocalFrame() and PopLocalFrame() or
// DeleteLocalRef() functions of the Java native interface:
//
// https://docs.oracle.com/javase/1.5.0/docs/guide/jni/spec/functions.html
//
// returns the jobject representing the instance of the Activity class of the
//          Android application, or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_android_jni_env (SDL_GetAndroidJNIEnv)
pub fn get_android_activity() voidptr {
	return C.SDL_GetAndroidActivity()
}

// C.SDL_GetAndroidSDKVersion [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAndroidSDKVersion)
fn C.SDL_GetAndroidSDKVersion() int

// get_android_sdk_version querys Android API level of the current device.
//
// - API level 35: Android 15 (VANILLA_ICE_CREAM)
// - API level 34: Android 14 (UPSIDE_DOWN_CAKE)
// - API level 33: Android 13 (TIRAMISU)
// - API level 32: Android 12L (S_V2)
// - API level 31: Android 12 (S)
// - API level 30: Android 11 (R)
// - API level 29: Android 10 (Q)
// - API level 28: Android 9 (P)
// - API level 27: Android 8.1 (O_MR1)
// - API level 26: Android 8.0 (O)
// - API level 25: Android 7.1 (N_MR1)
// - API level 24: Android 7.0 (N)
// - API level 23: Android 6.0 (M)
// - API level 22: Android 5.1 (LOLLIPOP_MR1)
// - API level 21: Android 5.0 (LOLLIPOP, L)
// - API level 20: Android 4.4W (KITKAT_WATCH)
// - API level 19: Android 4.4 (KITKAT)
// - API level 18: Android 4.3 (JELLY_BEAN_MR2)
// - API level 17: Android 4.2 (JELLY_BEAN_MR1)
// - API level 16: Android 4.1 (JELLY_BEAN)
// - API level 15: Android 4.0.3 (ICE_CREAM_SANDWICH_MR1)
// - API level 14: Android 4.0 (ICE_CREAM_SANDWICH)
// - API level 13: Android 3.2 (HONEYCOMB_MR2)
// - API level 12: Android 3.1 (HONEYCOMB_MR1)
// - API level 11: Android 3.0 (HONEYCOMB)
// - API level 10: Android 2.3.3 (GINGERBREAD_MR1)
//
// returns the Android API level.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_android_sdk_version() int {
	return C.SDL_GetAndroidSDKVersion()
}

// C.SDL_IsChromebook [official documentation](https://wiki.libsdl.org/SDL3/SDL_IsChromebook)
fn C.SDL_IsChromebook() bool

// is_chromebook querys if the application is running on a Chromebook.
//
// returns true if this is a Chromebook, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn is_chromebook() bool {
	return C.SDL_IsChromebook()
}

// C.SDL_IsDeXMode [official documentation](https://wiki.libsdl.org/SDL3/SDL_IsDeXMode)
fn C.SDL_IsDeXMode() bool

// is_de_x_mode querys if the application is running on a Samsung DeX docking station.
//
// returns true if this is a DeX docking station, false otherwise.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn is_dex_mode() bool {
	return C.SDL_IsDeXMode()
}

// C.SDL_SendAndroidBackButton [official documentation](https://wiki.libsdl.org/SDL3/SDL_SendAndroidBackButton)
fn C.SDL_SendAndroidBackButton()

// send_android_back_button triggers the Android system back button behavior.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn send_android_back_button() {
	C.SDL_SendAndroidBackButton()
}

// See the official Android developer guide for more information:
// http://developer.android.com/guide/topics/data/data-storage.html
//
// NOTE: This macro is available since SDL 3.2.0.
pub const android_external_storage_read = C.SDL_ANDROID_EXTERNAL_STORAGE_READ // 0x01

// See the official Android developer guide for more information:
// http://developer.android.com/guide/topics/data/data-storage.html
//
// NOTE: This macro is available since SDL 3.2.0.
pub const android_external_storage_write = C.SDL_ANDROID_EXTERNAL_STORAGE_WRITE // 0x02

// C.SDL_GetAndroidInternalStoragePath [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAndroidInternalStoragePath)
fn C.SDL_GetAndroidInternalStoragePath() &char

// get_android_internal_storage_path gets the path used for internal storage for this Android application.
//
// This path is unique to your application and cannot be written to by other
// applications.
//
// Your internal storage path is typically:
// `/data/data/your.app.package/files`.
//
// This is a C wrapper over `android.content.Context.getFilesDir()`:
//
// https://developer.android.com/reference/android/content/Context#getFilesDir()
//
// returns the path used for internal storage or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_android_external_storage_path (SDL_GetAndroidExternalStoragePath)
// See also: get_android_cache_path (SDL_GetAndroidCachePath)
pub fn get_android_internal_storage_path() &char {
	return C.SDL_GetAndroidInternalStoragePath()
}

// C.SDL_GetAndroidExternalStorageState [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAndroidExternalStorageState)
fn C.SDL_GetAndroidExternalStorageState() u32

// get_android_external_storage_state gets the current state of external storage for this Android application.
//
// The current state of external storage, a bitmask of these values:
// `SDL_ANDROID_EXTERNAL_STORAGE_READ`, `SDL_ANDROID_EXTERNAL_STORAGE_WRITE`.
//
// If external storage is currently unavailable, this will return 0.
//
// returns the current state of external storage, or 0 if external storage is
//          currently unavailable.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_android_external_storage_path (SDL_GetAndroidExternalStoragePath)
pub fn get_android_external_storage_state() u32 {
	return C.SDL_GetAndroidExternalStorageState()
}

// C.SDL_GetAndroidExternalStoragePath [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAndroidExternalStoragePath)
fn C.SDL_GetAndroidExternalStoragePath() &char

// get_android_external_storage_path gets the path used for external storage for this Android application.
//
// This path is unique to your application, but is public and can be written
// to by other applications.
//
// Your external storage path is typically:
// `/storage/sdcard0/Android/data/your.app.package/files`.
//
// This is a C wrapper over `android.content.Context.getExternalFilesDir()`:
//
// https://developer.android.com/reference/android/content/Context#getExternalFilesDir()
//
// returns the path used for external storage for this application on success
//          or NULL on failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_android_external_storage_state (SDL_GetAndroidExternalStorageState)
// See also: get_android_internal_storage_path (SDL_GetAndroidInternalStoragePath)
// See also: get_android_cache_path (SDL_GetAndroidCachePath)
pub fn get_android_external_storage_path() &char {
	return C.SDL_GetAndroidExternalStoragePath()
}

// C.SDL_GetAndroidCachePath [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetAndroidCachePath)
fn C.SDL_GetAndroidCachePath() &char

// get_android_cache_path gets the path used for caching data for this Android application.
//
// This path is unique to your application, but is public and can be written
// to by other applications.
//
// Your cache path is typically: `/data/data/your.app.package/cache/`.
//
// This is a C wrapper over `android.content.Context.getCacheDir()`:
//
// https://developer.android.com/reference/android/content/Context#getCacheDir()
//
// returns the path used for caches for this application on success or NULL
//          on failure; call SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
//
// See also: get_android_internal_storage_path (SDL_GetAndroidInternalStoragePath)
// See also: get_android_external_storage_path (SDL_GetAndroidExternalStoragePath)
pub fn get_android_cache_path() &char {
	return C.SDL_GetAndroidCachePath()
}

// RequestAndroidPermissionCallback callbacks that presents a response from a SDL_RequestAndroidPermission call.
//
// `userdata` userdata an app-controlled pointer that is passed to the callback.
// `permission` permission the Android-specific permission name that was requested.
// `granted` granted true if permission is granted, false if denied.
//
// NOTE: This datatype is available since SDL 3.2.0.
//
// See also: request_android_permission (SDL_RequestAndroidPermission)
//
// [Official documentation](https://wiki.libsdl.org/SDL3/SDL_RequestAndroidPermissionCallback)
pub type RequestAndroidPermissionCallback = fn (userdata voidptr, const_permission &char, granted bool)

// C.SDL_RequestAndroidPermission [official documentation](https://wiki.libsdl.org/SDL3/SDL_RequestAndroidPermission)
fn C.SDL_RequestAndroidPermission(const_permission &char, cb RequestAndroidPermissionCallback, userdata voidptr) bool

// request_android_permission requests permissions at runtime, asynchronously.
//
// You do not need to call this for built-in functionality of SDL; recording
// from a microphone or reading images from a camera, using standard SDL APIs,
// will manage permission requests for you.
//
// This function never blocks. Instead, the app-supplied callback will be
// called when a decision has been made. This callback may happen on a
// different thread, and possibly much later, as it might wait on a user to
// respond to a system dialog. If permission has already been granted for a
// specific entitlement, the callback will still fire, probably on the current
// thread and before this function returns.
//
// If the request submission fails, this function returns -1 and the callback
// will NOT be called, but this should only happen in catastrophic conditions,
// like memory running out. Normally there will be a yes or no to the request
// through the callback.
//
// For the `permission` parameter, choose a value from here:
//
// https://developer.android.com/reference/android/Manifest.permission
//
// `permission` permission the permission to request.
// `cb` cb the callback to trigger when the request has a response.
// `userdata` userdata an app-controlled pointer that is passed to the callback.
// returns true if the request was submitted, false if there was an error
//          submitting. The result of the request is only ever reported
//          through the callback, not this return value.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn request_android_permission(const_permission &char, cb RequestAndroidPermissionCallback, userdata voidptr) bool {
	return C.SDL_RequestAndroidPermission(const_permission, cb, userdata)
}

// C.SDL_ShowAndroidToast [official documentation](https://wiki.libsdl.org/SDL3/SDL_ShowAndroidToast)
fn C.SDL_ShowAndroidToast(const_message &char, duration int, gravity int, xoffset int, yoffset int) bool

// show_android_toast shows an Android toast notification.
//
// Toasts are a sort of lightweight notification that are unique to Android.
//
// https://developer.android.com/guide/topics/ui/notifiers/toasts
//
// Shows toast in UI thread.
//
// For the `gravity` parameter, choose a value from here, or -1 if you don't
// have a preference:
//
// https://developer.android.com/reference/android/view/Gravity
//
// `message` message text message to be shown.
// `duration` duration 0=short, 1=long.
// `gravity` gravity where the notification should appear on the screen.
// `xoffset` xoffset set this parameter only when gravity >=0.
// `yoffset` yoffset set this parameter only when gravity >=0.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn show_android_toast(const_message &char, duration int, gravity int, xoffset int, yoffset int) bool {
	return C.SDL_ShowAndroidToast(const_message, duration, gravity, xoffset, yoffset)
}

// C.SDL_SendAndroidMessage [official documentation](https://wiki.libsdl.org/SDL3/SDL_SendAndroidMessage)
fn C.SDL_SendAndroidMessage(command u32, param int) bool

// send_android_message sends a user command to SDLActivity.
//
// Override "boolean onUnhandledMessage(Message msg)" to handle the message.
//
// `command` command user command that must be greater or equal to 0x8000.
// `param` param user parameter.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: (thread safety) It is safe to call this function from any thread.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn send_android_message(command u32, param int) bool {
	return C.SDL_SendAndroidMessage(command, param)
}
