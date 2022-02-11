tool
class_name RumbleControl
extends Control
# A control node for testing a rumble configuration.
# Both a gamepad and handheld variant of a particular rumble can be implemented.
# This provides a simple, single rumble - but may be overridden to do more.

export var label := "Rumble Control"  setget _set_label

export(float, 0, 1) var weak_magnitude_factor := 1.0

export(float, 0, 1) var strong_magnitude_factor := 1.0

export(float, 0.01, 10) var duration := 1.0 setget _set_duration

export(int, 10, 10000) var handheld_duration := 100 setget _set_handheld_duration

onready var timer : Timer = $Timer


func _ready() -> void:
	# warning-ignore:return_value_discarded
	$Button.connect("pressed", self, "_on_Button_pressed")


func _set_label(value) -> void:
	label = value
	$Label.text = value


func _set_duration(value: float) -> void:
	duration = value
	if (duration <= 0):
		duration = 0.01


func _set_handheld_duration(value: int) -> void:
	handheld_duration = value
	if (handheld_duration <= 0):
		handheld_duration = 1


func _get_amount() -> float:
	return $Slider.value


func _on_Button_pressed() -> void:
	var amount : = _get_amount()
	var weak_magnitude := amount * weak_magnitude_factor
	var strong_magnitude := amount * strong_magnitude_factor

	var gamepads : Array = Input.get_connected_joypads()
	if gamepads.size() > 0:
		for device_index in gamepads:
			#stop any previous rumbling
			Input.stop_joy_vibration(device_index)
			#perform the rumble
			_rumble_gamepad(device_index, weak_magnitude, strong_magnitude)

	elif OS.get_name() == "Android" or OS.get_name() == "iOS":
		_rumble_handheld()


func _rumble_gamepad(device_index: int, weak_magnitude: float, strong_magnitude: float) -> void:
	Input.start_joy_vibration(device_index, weak_magnitude, strong_magnitude, duration)


func _rumble_handheld() -> void:
	Input.vibrate_handheld(handheld_duration)
