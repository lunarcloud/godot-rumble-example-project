tool
extends Control
class_name RumbleControl

export var label := "Rumble Control"  setget _set_label
export(float, 0, 1) var weak_magnitude_factor := 1.0
export(float, 0, 1) var strong_magnitude_factor := 1.0
export(float, 0.01, 10) var duration := 1.0 setget _set_duration
export(int, 10, 10000) var mobile_duration := 100 setget _set_mobile_duration

onready var timer := $Timer

func _ready():
	# warning-ignore:return_value_discarded
	$Button.connect("pressed", self, "_on_Button_pressed")

func _set_label(value):
	label = value
	$Label.text = value

func _set_duration(value: float):
	duration = value
	if (duration <= 0):
		duration = 0.01

func _set_mobile_duration(value: int):
	mobile_duration = value
	if (mobile_duration <= 0):
		mobile_duration = 1

func _get_amount() -> float:
	return $Slider.value

func _on_Button_pressed():
	var amount : = _get_amount()
	var weak_magnitude := amount * weak_magnitude_factor
	var strong_magnitude := amount * strong_magnitude_factor

	var gamepads : Array = Input.get_connected_joypads()
	if gamepads.size() > 0:
		for id in gamepads:
			# stop any previous rumbling
			Input.stop_joy_vibration(id)
			# perform the rumble
			_rumble_gamepad(id, weak_magnitude, strong_magnitude)

	elif OS.get_name() == "Android" || OS.get_name() == "iOS":
		_rumble_phone()

func _rumble_gamepad(id: int, weak_magnitude: float, strong_magnitude: float):
	Input.start_joy_vibration(id, weak_magnitude, strong_magnitude, duration)

func _rumble_phone():
	Input.vibrate_handheld(mobile_duration)
