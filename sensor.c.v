// Copyright(C) 2021 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_sensor.h
//

// In order to use these functions, SDL_Init() must have been called
// with the ::SDL_INIT_SENSOR flag.  This causes SDL to scan the system
// for sensors, and load appropriate drivers.
//
// Sensor is C.SDL_Sensor
@[typedef]
pub struct C.SDL_Sensor {
}

pub type Sensor = C.SDL_Sensor

// This is a unique ID for a sensor for the time it is connected to the system,
// and is never reused for the lifetime of the application.
//
// The ID value starts at 0 and increments from there. The value -1 is an invalid ID.
// `typedef Sint32 SDL_SensorID;`
pub type SensorID = int

// SensorType is C.SDL_SensorType
pub enum SensorType {
	invalid = C.SDL_SENSOR_INVALID // -1, Returned for an invalid sensor
	unknown = C.SDL_SENSOR_UNKNOWN // Unknown sensor type
	accel   = C.SDL_SENSOR_ACCEL // Accelerometer
	gyro    = C.SDL_SENSOR_GYRO // Gyroscope
}

// Accelerometer sensor
//
// The accelerometer returns the current acceleration in SI meters per
// second squared. This measurement includes the force of gravity, so
// a device at rest will have an value of SDL_STANDARD_GRAVITY away
// from the center of the earth.
//
// values[0]: Acceleration on the x axis
// values[1]: Acceleration on the y axis
// values[2]: Acceleration on the z axis
//
// For phones held in portrait mode and game controllers held in front of you,
// the axes are defined as follows:
// -X ... +X : left ... right
// -Y ... +Y : bottom ... top
// -Z ... +Z : farther ... closer
//
// The axis data is not changed when the phone is rotated.
//
// See also: SDL_GetDisplayOrientation()
const standard_gravity = C.SDL_STANDARD_GRAVITY

// 9.80665f

// Gyroscope sensor
//
// The gyroscope returns the current rate of rotation in radians per second.
// The rotation is positive in the counter-clockwise direction. That is,
// an observer looking from a positive location on one of the axes would
// see positive rotation on that axis when it appeared to be rotating
// counter-clockwise.
//
// values[0]: Angular speed around the x axis (pitch)
// values[1]: Angular speed around the y axis (yaw)
// values[2]: Angular speed around the z axis (roll)
//
// For phones held in portrait mode and game controllers held in front of you,
// the axes are defined as follows:
// -X ... +X : left ... right
// -Y ... +Y : bottom ... top
// -Z ... +Z : farther ... closer
//
// The axis data is not changed when the phone or controller is rotated.
//
// See also: SDL_GetDisplayOrientation()

fn C.SDL_LockSensors()

// lock_sensors provides locking for multi-threaded access to the sensor API
//
// If you are using the sensor API or handling events from multiple threads
// you should use these locking functions to protect access to the sensors.
//
// In particular, you are guaranteed that the sensor list won't change, so the
// API functions that take a sensor index will be valid, and sensor events
// will not be delivered.
pub fn lock_sensors() {
	C.SDL_LockSensors()
}

fn C.SDL_UnlockSensors()

// unlock_sensors provides unlocking for multi-threaded access to the sensor API
//
// If you are using the sensor API or handling events from multiple threads
// you should use these locking functions to protect access to the sensors.
//
// In particular, you are guaranteed that the sensor list won't change, so the
// API functions that take a sensor index will be valid, and sensor events
// will not be delivered.
pub fn unlock_sensors() {
	C.SDL_UnlockSensors()
}

fn C.SDL_NumSensors() int

// num_sensors counts the number of sensors attached to the system right now.
//
// returns the number of sensors detected.
pub fn num_sensors() int {
	return C.SDL_NumSensors()
}

fn C.SDL_SensorGetDeviceName(device_index int) &char

// sensor_get_device_name gets the implementation dependent name of a sensor.
//
// `device_index` The sensor to obtain name from
// returns the sensor name, or NULL if `device_index` is out of range.
pub fn sensor_get_device_name(device_index int) &char {
	return C.SDL_SensorGetDeviceName(device_index)
}

fn C.SDL_SensorGetDeviceType(device_index int) SensorType

// sensor_get_device_type gets the type of a sensor.
//
// `device_index` The sensor to get the type from
// returns the SDL_SensorType, or `SDL_SENSOR_INVALID` if `device_index` is
//          out of range.
pub fn sensor_get_device_type(device_index int) SensorType {
	return SensorType(C.SDL_SensorGetDeviceType(device_index))
}

fn C.SDL_SensorGetDeviceNonPortableType(device_index int) int

// sensor_get_device_non_portable_type gets the platform dependent type of a sensor.
//
// `device_index` The sensor to check
// returns the sensor platform dependent type, or -1 if `device_index` is out
//          of range.
pub fn sensor_get_device_non_portable_type(device_index int) int {
	return C.SDL_SensorGetDeviceNonPortableType(device_index)
}

fn C.SDL_SensorGetDeviceInstanceID(device_index int) SensorID

// sensor_get_device_instance_id gets the instance ID of a sensor.
//
// `device_index` The sensor to get instance id from
// returns the sensor instance ID, or -1 if `device_index` is out of range.
pub fn sensor_get_device_instance_id(device_index int) SensorID {
	return SensorID(int(C.SDL_SensorGetDeviceInstanceID(device_index)))
}

fn C.SDL_SensorOpen(device_index int) &C.SDL_Sensor

// sensor_open opens a sensor for use.
//
// `device_index` The sensor to open
// returns an SDL_Sensor sensor object, or NULL if an error occurred.
pub fn sensor_open(device_index int) &Sensor {
	return C.SDL_SensorOpen(device_index)
}

fn C.SDL_SensorFromInstanceID(instance_id SensorID) &Sensor

// sensor_from_instance_id returns the SDL_Sensor associated with an instance id.
//
// `instance_id` The sensor from instance id
// returns an SDL_Sensor object.
pub fn sensor_from_instance_id(instance_id SensorID) &Sensor {
	return C.SDL_SensorFromInstanceID(instance_id)
}

fn C.SDL_SensorGetName(sensor &C.SDL_Sensor) &char

// sensor_get_name gets the implementation dependent name of a sensor
//
// `sensor` The SDL_Sensor object
// returns the sensor name, or NULL if `sensor` is NULL.
pub fn sensor_get_name(sensor &Sensor) &char {
	return C.SDL_SensorGetName(sensor)
}

fn C.SDL_SensorGetType(sensor &C.SDL_Sensor) SensorType

// sensor_get_type gets the type of a sensor.
//
// `sensor` The SDL_Sensor object to inspect
// returns the SDL_SensorType type, or `SDL_SENSOR_INVALID` if `sensor` is
//          NULL.
pub fn sensor_get_type(sensor &Sensor) SensorType {
	return SensorType(C.SDL_SensorGetType(sensor))
}

fn C.SDL_SensorGetNonPortableType(sensor &C.SDL_Sensor) int

// sensor_get_non_portable_type gets the platform dependent type of a sensor.
//
// `sensor` The SDL_Sensor object to inspect
// returns the sensor platform dependent type, or -1 if `sensor` is NULL.
pub fn sensor_get_non_portable_type(sensor &Sensor) int {
	return C.SDL_SensorGetNonPortableType(sensor)
}

fn C.SDL_SensorGetInstanceID(sensor &C.SDL_Sensor) SensorID

// sensor_get_instance_id gets the instance ID of a sensor.
//
// `sensor` The SDL_Sensor object to inspect
// returns the sensor instance ID, or -1 if `sensor` is NULL.
pub fn sensor_get_instance_id(sensor &Sensor) SensorID {
	return SensorID(int(C.SDL_SensorGetInstanceID(sensor)))
}

fn C.SDL_SensorGetData(sensor &C.SDL_Sensor, data &f32, num_values int) int

// sensor_get_data gets the current state of an opened sensor.
//
// The number of values and interpretation of the data is sensor dependent.
//
// `sensor` The SDL_Sensor object to query
// `data` A pointer filled with the current sensor state
// `num_values` The number of values to write to data
// returns 0 or -1 if an error occurred.
pub fn sensor_get_data(sensor &Sensor, data &f32, num_values int) int {
	return C.SDL_SensorGetData(sensor, data, num_values)
}

fn C.SDL_SensorClose(sensor &C.SDL_Sensor)

// sensor_close closes a sensor previously opened with SDL_SensorOpen().
//
// `sensor` The SDL_Sensor object to close
pub fn sensor_close(sensor &Sensor) {
	C.SDL_SensorClose(sensor)
}

fn C.SDL_SensorUpdate()

// sensor_update updates the current state of the open sensors.
//
// This is called automatically by the event loop if sensor events are
// enabled.
//
// This needs to be called from the thread that initialized the sensor
// subsystem.
pub fn sensor_update() {
	C.SDL_SensorUpdate()
}
