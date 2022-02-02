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

fn C.SDL_IsAndroidTV() bool

// is_android_tv returns true if the application is running on Android TV
pub fn is_android_tv() bool {
	return C.SDL_IsAndroidTV()
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
pub fn android_get_internal_storage_path() &char {
	return C.SDL_AndroidGetInternalStoragePath()
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
pub fn android_get_external_storage_path() &char {
	return C.SDL_AndroidGetExternalStoragePath()
}
