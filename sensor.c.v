// Copyright(C) 2025 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module sdl

//
// SDL_sensor.h
//

// SDL sensor management.
//
// These APIs grant access to gyros and accelerometers on various platforms.
//
// In order to use these functions, SDL_Init() must have been called with the
// SDL_INIT_SENSOR flag. This causes SDL to scan the system for sensors, and
// load appropriate drivers.

// This is a unique ID for a sensor for the time it is connected to the
// system, and is never reused for the lifetime of the application.
//
// The value 0 is an invalid ID.
//
// NOTE: This datatype is available since SDL 3.2.0.
pub type SensorID = u32

@[noinit; typedef]
pub struct C.SDL_Sensor {
	// NOTE: Opaque type
}

pub type Sensor = C.SDL_Sensor

pub const standard_gravity = C.SDL_STANDARD_GRAVITY // 9.80665f

// SensorType is C.SDL_SensorType
pub enum SensorType {
	invalid = C.SDL_SENSOR_INVALID // -1, Returned for an invalid sensor
	unknown = C.SDL_SENSOR_UNKNOWN // `unknown` Unknown sensor type
	accel   = C.SDL_SENSOR_ACCEL   // `accel` Accelerometer
	gyro    = C.SDL_SENSOR_GYRO    // `gyro` Gyroscope
	accel_l = C.SDL_SENSOR_ACCEL_L // `accel_l` Accelerometer for left Joy-Con controller and Wii nunchuk
	gyro_l  = C.SDL_SENSOR_GYRO_L  // `gyro_l` Gyroscope for left Joy-Con controller
	accel_r = C.SDL_SENSOR_ACCEL_R // `accel_r` Accelerometer for right Joy-Con controller
	gyro_r  = C.SDL_SENSOR_GYRO_R  // `gyro_r` Gyroscope for right Joy-Con controller
}

// C.SDL_GetSensors [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensors)
fn C.SDL_GetSensors(count &int) &SensorID

// get_sensors gets a list of currently connected sensors.
//
// `count` count a pointer filled in with the number of sensors returned, may
//              be NULL.
// returns a 0 terminated array of sensor instance IDs or NULL on failure;
//          call SDL_GetError() for more information. This should be freed
//          with SDL_free() when it is no longer needed.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensors(count &int) &SensorID {
	return C.SDL_GetSensors(count)
}

// C.SDL_GetSensorNameForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorNameForID)
fn C.SDL_GetSensorNameForID(instance_id SensorID) &char

// get_sensor_name_for_id gets the implementation dependent name of a sensor.
//
// This can be called before any sensors are opened.
//
// `instance_id` instance_id the sensor instance ID.
// returns the sensor name, or NULL if `instance_id` is not valid.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_name_for_id(instance_id SensorID) &char {
	return C.SDL_GetSensorNameForID(instance_id)
}

// C.SDL_GetSensorTypeForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorTypeForID)
fn C.SDL_GetSensorTypeForID(instance_id SensorID) SensorType

// get_sensor_type_for_id gets the type of a sensor.
//
// This can be called before any sensors are opened.
//
// `instance_id` instance_id the sensor instance ID.
// returns the SDL_SensorType, or `SDL_SENSOR_INVALID` if `instance_id` is
//          not valid.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_type_for_id(instance_id SensorID) SensorType {
	return C.SDL_GetSensorTypeForID(instance_id)
}

// C.SDL_GetSensorNonPortableTypeForID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorNonPortableTypeForID)
fn C.SDL_GetSensorNonPortableTypeForID(instance_id SensorID) int

// get_sensor_non_portable_type_for_id gets the platform dependent type of a sensor.
//
// This can be called before any sensors are opened.
//
// `instance_id` instance_id the sensor instance ID.
// returns the sensor platform dependent type, or -1 if `instance_id` is not
//          valid.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_non_portable_type_for_id(instance_id SensorID) int {
	return C.SDL_GetSensorNonPortableTypeForID(instance_id)
}

// C.SDL_OpenSensor [official documentation](https://wiki.libsdl.org/SDL3/SDL_OpenSensor)
fn C.SDL_OpenSensor(instance_id SensorID) &Sensor

// open_sensor opens a sensor for use.
//
// `instance_id` instance_id the sensor instance ID.
// returns an SDL_Sensor object or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn open_sensor(instance_id SensorID) &Sensor {
	return C.SDL_OpenSensor(instance_id)
}

// C.SDL_GetSensorFromID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorFromID)
fn C.SDL_GetSensorFromID(instance_id SensorID) &Sensor

// get_sensor_from_id returns the SDL_Sensor associated with an instance ID.
//
// `instance_id` instance_id the sensor instance ID.
// returns an SDL_Sensor object or NULL on failure; call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_from_id(instance_id SensorID) &Sensor {
	return C.SDL_GetSensorFromID(instance_id)
}

// C.SDL_GetSensorProperties [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorProperties)
fn C.SDL_GetSensorProperties(sensor &Sensor) PropertiesID

// get_sensor_properties gets the properties associated with a sensor.
//
// `sensor` sensor the SDL_Sensor object.
// returns a valid property ID on success or 0 on failure; call
//          SDL_GetError() for more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_properties(sensor &Sensor) PropertiesID {
	return C.SDL_GetSensorProperties(sensor)
}

// C.SDL_GetSensorName [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorName)
fn C.SDL_GetSensorName(sensor &Sensor) &char

// get_sensor_name gets the implementation dependent name of a sensor.
//
// `sensor` sensor the SDL_Sensor object.
// returns the sensor name or NULL on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_name(sensor &Sensor) &char {
	return C.SDL_GetSensorName(sensor)
}

// C.SDL_GetSensorType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorType)
fn C.SDL_GetSensorType(sensor &Sensor) SensorType

// get_sensor_type gets the type of a sensor.
//
// `sensor` sensor the SDL_Sensor object to inspect.
// returns the SDL_SensorType type, or `SDL_SENSOR_INVALID` if `sensor` is
//          NULL.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_type(sensor &Sensor) SensorType {
	return C.SDL_GetSensorType(sensor)
}

// C.SDL_GetSensorNonPortableType [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorNonPortableType)
fn C.SDL_GetSensorNonPortableType(sensor &Sensor) int

// get_sensor_non_portable_type gets the platform dependent type of a sensor.
//
// `sensor` sensor the SDL_Sensor object to inspect.
// returns the sensor platform dependent type, or -1 if `sensor` is NULL.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_non_portable_type(sensor &Sensor) int {
	return C.SDL_GetSensorNonPortableType(sensor)
}

// C.SDL_GetSensorID [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorID)
fn C.SDL_GetSensorID(sensor &Sensor) SensorID

// get_sensor_id gets the instance ID of a sensor.
//
// `sensor` sensor the SDL_Sensor object to inspect.
// returns the sensor instance ID, or 0 on failure; call SDL_GetError() for
//          more information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_id(sensor &Sensor) SensorID {
	return C.SDL_GetSensorID(sensor)
}

// C.SDL_GetSensorData [official documentation](https://wiki.libsdl.org/SDL3/SDL_GetSensorData)
fn C.SDL_GetSensorData(sensor &Sensor, data &f32, num_values int) bool

// get_sensor_data gets the current state of an opened sensor.
//
// The number of values and interpretation of the data is sensor dependent.
//
// `sensor` sensor the SDL_Sensor object to query.
// `data` data a pointer filled with the current sensor state.
// `num_values` num_values the number of values to write to data.
// returns true on success or false on failure; call SDL_GetError() for more
//          information.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn get_sensor_data(sensor &Sensor, data &f32, num_values int) bool {
	return C.SDL_GetSensorData(sensor, data, num_values)
}

// C.SDL_CloseSensor [official documentation](https://wiki.libsdl.org/SDL3/SDL_CloseSensor)
fn C.SDL_CloseSensor(sensor &Sensor)

// close_sensor closes a sensor previously opened with SDL_OpenSensor().
//
// `sensor` sensor the SDL_Sensor object to close.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn close_sensor(sensor &Sensor) {
	C.SDL_CloseSensor(sensor)
}

// C.SDL_UpdateSensors [official documentation](https://wiki.libsdl.org/SDL3/SDL_UpdateSensors)
fn C.SDL_UpdateSensors()

// update_sensors updates the current state of the open sensors.
//
// This is called automatically by the event loop if sensor events are
// enabled.
//
// This needs to be called from the thread that initialized the sensor
// subsystem.
//
// NOTE: This function is available since SDL 3.2.0.
pub fn update_sensors() {
	C.SDL_UpdateSensors()
}
