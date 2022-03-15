// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

fn C.SDL_AndroidGetJNIEnv() voidptr

// android_get_jni_env gets the Android Java Native Interface Environment of the current thread.
//
// This is the JNIEnv one needs to access the Java virtual machine from native
// code, and is needed for many Android APIs to be usable from C.
//
// The prototype of the function in SDL's code actually declare a void* return
// type, even if the implementation returns a pointer to a JNIEnv. The
// rationale being that the SDL headers can avoid including jni.h.
//
// returns a pointer to Java native interface object (JNIEnv) to which the
//          current thread is attached, or 0 on error.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AndroidGetActivity
pub fn android_get_jni_env() voidptr {
	return C.SDL_AndroidGetJNIEnv()
}

fn C.SDL_AndroidGetActivity() voidptr

// android_get_activity retrieves the Java instance of the Android activity class.
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
//          Android application, or NULL on error.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AndroidGetJNIEnv
pub fn android_get_activity() voidptr {
	return C.SDL_AndroidGetActivity()
}

fn C.SDL_GetAndroidSDKVersion() int

// get_android_sdk_version queries Android API level of the current device.
//
// - API level 30: Android 11
// - API level 29: Android 10
// - API level 28: Android 9
// - API level 27: Android 8.1
// - API level 26: Android 8.0
// - API level 25: Android 7.1
// - API level 24: Android 7.0
// - API level 23: Android 6.0
// - API level 22: Android 5.1
// - API level 21: Android 5.0
// - API level 20: Android 4.4W
// - API level 19: Android 4.4
// - API level 18: Android 4.3
// - API level 17: Android 4.2
// - API level 16: Android 4.1
// - API level 15: Android 4.0.3
// - API level 14: Android 4.0
// - API level 13: Android 3.2
// - API level 12: Android 3.1
// - API level 11: Android 3.0
// - API level 10: Android 2.3.3
//
// returns the Android API level.
pub fn get_android_sdk_version() int {
	return C.SDL_GetAndroidSDKVersion()
}

fn C.SDL_IsAndroidTV() bool

// is_android_tv queries if the application is running on Android TV.
//
// returns SDL_TRUE if this is Android TV, SDL_FALSE otherwise.
pub fn is_android_tv() bool {
	return C.SDL_IsAndroidTV()
}

fn C.SDL_IsChromebook() bool

// is_chromebook queries if the application is running on a Chromebook.
//
// returns SDL_TRUE if this is a Chromebook, SDL_FALSE otherwise.
pub fn is_chromebook() bool {
	return C.SDL_IsChromebook()
}

fn C.SDL_IsDeXMode() bool

// is_dex_mode queries if the application is running on a Samsung DeX docking station.
//
// returns SDL_TRUE if this is a DeX docking station, SDL_FALSE otherwise.
pub fn is_dex_mode() bool {
	return C.SDL_IsDeXMode()
}

fn C.SDL_AndroidBackButton()

// android_back_button triggers the Android system back button behavior.
pub fn android_back_button() {
	C.SDL_AndroidBackButton()
}

// See the official Android developer guide for more information:
// http://developer.android.com/guide/topics/data/data-storage.html
pub const (
	android_external_storage_read  = C.SDL_ANDROID_EXTERNAL_STORAGE_READ //  0x01
	android_external_storage_write = C.SDL_ANDROID_EXTERNAL_STORAGE_WRITE // 0x02
)

fn C.SDL_AndroidGetInternalStoragePath() &char

// android_get_internal_storage_path gets the path used for internal storage for this application.
//
// This path is unique to your application and cannot be written to by other
// applications.
//
// Your internal storage path is typically:
// `/data/data/your.app.package/files`.
//
// returns the path used for internal storage or NULL on failure; call
//          SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AndroidGetExternalStorageState
pub fn android_get_internal_storage_path() &char {
	return C.SDL_AndroidGetInternalStoragePath()
}

fn C.SDL_AndroidGetExternalStorageState() int

// android_get_external_storage_state gets the current state of external storage.
//
// The current state of external storage, a bitmask of these values:
// `SDL_ANDROID_EXTERNAL_STORAGE_READ`, `SDL_ANDROID_EXTERNAL_STORAGE_WRITE`.
//
// If external storage is currently unavailable, this will return 0.
//
// returns the current state of external storage on success or 0 on failure;
//          call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AndroidGetExternalStoragePath
pub fn android_get_external_storage_state() int {
	return C.SDL_AndroidGetExternalStorageState()
}

fn C.SDL_AndroidGetExternalStoragePath() &char

// android_get_external_storage_path gets the path used for external storage for this application.
//
// This path is unique to your application, but is public and can be written
// to by other applications.
//
// Your external storage path is typically:
// `/storage/sdcard0/Android/data/your.app.package/files`.
//
// returns the path used for external storage for this application on success
//          or NULL on failure; call SDL_GetError() for more information.
//
// NOTE This function is available since SDL 2.0.0.
//
// See also: SDL_AndroidGetExternalStorageState
pub fn android_get_external_storage_path() &char {
	return C.SDL_AndroidGetExternalStoragePath()
}

fn C.SDL_AndroidRequestPermission(permission &char) bool

// android_request_permission requests permissions at runtime.
//
// This blocks the calling thread until the permission is granted or denied.
//
// `permission` The permission to request.
// returns SDL_TRUE if the permission was granted, SDL_FALSE otherwise.
pub fn android_request_permission(permission &char) bool {
	return C.SDL_AndroidRequestPermission(permission)
}

fn C.SDL_AndroidShowToast(const_message &char, duration int, gravity int, xoffset int, yoffset int) int

// android_show_toast shows an Android toast notification.
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
// `message` text message to be shown
// `duration` 0=short, 1=long
// `gravity` where the notification should appear on the screen.
// `xoffset` set this parameter only when gravity >=0
// `yoffset` set this parameter only when gravity >=0
// returns 0 if success, -1 if any error occurs.
pub fn android_show_toast(const_message &char, duration int, gravity int, xoffset int, yoffset int) int {
	return C.SDL_AndroidShowToast(const_message, duration, gravity, xoffset, yoffset)
}
