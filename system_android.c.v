// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_system.h
//

fn C.SDL_AndroidGetJNIEnv() voidptr

// android_get_jni_env gets the JNI environment for the current thread
//
// returns JNIEnv*, but the prototype is void* so we don't need jni.h
pub fn android_get_jni_env() voidptr {
	return C.SDL_AndroidGetJNIEnv()
}

fn C.SDL_AndroidGetActivity() voidptr

// android_get_activity gets the SDL Activity object for the application
//
// returns jobject, but the prototype is void* so we don't need jni.h
// The jobject returned by SDL_AndroidGetActivity is a local reference.
// It is the caller's responsibility to properly release it
// (using env->Push/PopLocalFrame or manually with env->DeleteLocalRef)
pub fn android_get_activity() voidptr {
	return C.SDL_AndroidGetActivity()
}

fn C.SDL_GetAndroidSDKVersion() int

// get_android_sdk_version returns the API level of the current device
//
//    API level 30: Android 11
//    API level 29: Android 10
//    API level 28: Android 9
//    API level 27: Android 8.1
//    API level 26: Android 8.0
//    API level 25: Android 7.1
//    API level 24: Android 7.0
//    API level 23: Android 6.0
//    API level 22: Android 5.1
//    API level 21: Android 5.0
//    API level 20: Android 4.4W
//    API level 19: Android 4.4
//    API level 18: Android 4.3
//    API level 17: Android 4.2
//    API level 16: Android 4.1
//    API level 15: Android 4.0.3
//    API level 14: Android 4.0
//    API level 13: Android 3.2
//    API level 12: Android 3.1
//    API level 11: Android 3.0
//    API level 10: Android 2.3.3
pub fn get_android_sdk_version() int {
	return C.SDL_GetAndroidSDKVersion()
}

fn C.SDL_IsAndroidTV() bool

// is_android_tv returns true if the application is running on Android TV
pub fn is_android_tv() bool {
	return C.SDL_IsAndroidTV()
}

fn C.SDL_IsChromebook() bool

// is_chromebook returns true if the application is running on a Chromebook
pub fn is_chromebook() bool {
	return C.SDL_IsChromebook()
}

fn C.SDL_IsDeXMode() bool

// is_dex_mode returns true is the application is running on a Samsung DeX docking station
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
// This path is unique to your application and cannot be written to
// by other applications.
pub fn android_get_internal_storage_path() string {
	return unsafe { cstring_to_vstring(C.SDL_AndroidGetInternalStoragePath()) }
}

fn C.SDL_AndroidGetExternalStorageState() int

// android_get_external_storage_state gets the current state of external storage, a bitmask of these values:
// SDL_ANDROID_EXTERNAL_STORAGE_READ
// SDL_ANDROID_EXTERNAL_STORAGE_WRITE
//
// If external storage is currently unavailable, this will return 0.
pub fn android_get_external_storage_state() int {
	return C.SDL_AndroidGetExternalStorageState()
}

fn C.SDL_AndroidGetExternalStoragePath() &char

// android_get_external_storage_path gets the path used for external storage for this application.
//
// This path is unique to your application, but is public and can be
// written to by other applications.
pub fn android_get_external_storage_path() string {
	return unsafe { cstring_to_vstring(C.SDL_AndroidGetExternalStoragePath()) }
}

fn C.SDL_AndroidRequestPermission(permission &char) bool

// android_request_permission requests permissions at runtime.
//
// This blocks the calling thread until the permission is granted or
// denied. Returns SDL_TRUE if the permission was granted.
pub fn android_request_permission(permission string) bool {
	return C.SDL_AndroidRequestPermission(permission.str)
}
