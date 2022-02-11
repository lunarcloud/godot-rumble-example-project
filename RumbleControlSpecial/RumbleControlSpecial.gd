tool
extends RumbleControl

func _set_duration(value: float):
	duration = value
	if (duration < 2):
		duration = 2

func _set_mobile_duration(value: int):
	mobile_duration = value
	if (mobile_duration < 1000):
		mobile_duration = 1000

func _rumble_gamepad(id: int, weak_magnitude: float, strong_magnitude: float):
	var step_duration := duration / 9

	for _i in range(3):
		Input.start_joy_vibration(id, weak_magnitude * 0, strong_magnitude, step_duration)
		timer.start(step_duration)
		yield(timer, "timeout")

		Input.start_joy_vibration(id, weak_magnitude, strong_magnitude * 0, step_duration)
		timer.start(step_duration*2)
		yield(timer, "timeout")


func _rumble_phone():
	# warning-ignore:integer_division
	var step_duration : int = (mobile_duration - 250) / 9
	var step_duration_timer : float = mobile_duration / 9000.0

	for _i in range(3):
		Input.vibrate_handheld(step_duration)
		timer.start(step_duration_timer)
		yield(timer, "timeout")

		Input.vibrate_handheld(step_duration * 2)
		timer.start(step_duration_timer * 1.5)
		yield(timer, "timeout")
