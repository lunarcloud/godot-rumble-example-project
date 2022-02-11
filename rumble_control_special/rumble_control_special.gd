tool
extends RumbleControl
# An example of rumble control with a custom rumble pattern.
# A series of three weak-then-strong rumbles.

func _set_duration(value: float) -> void:
	duration = value
	if (duration < 2):
		duration = 2


func _set_handheld_duration(value: int) -> void:
	handheld_duration = value
	if (handheld_duration < 1000):
		handheld_duration = 1000


func _rumble_gamepad(device_index: int, weak_magnitude: float, strong_magnitude: float) -> void:
	var step_duration := duration / 9

	for _i in range(3):
		Input.start_joy_vibration(device_index, weak_magnitude * 0, strong_magnitude, step_duration)
		timer.start(step_duration)
		yield(timer, "timeout")

		Input.start_joy_vibration(device_index, weak_magnitude, strong_magnitude * 0, step_duration)
		timer.start(step_duration*2)
		yield(timer, "timeout")


func _rumble_handheld() -> void:
	# warning-ignore:integer_division
	var step_duration : int = (handheld_duration - 250) / 9
	var step_duration_timer : float = handheld_duration / 9000.0

	for _i in range(3):
		Input.vibrate_handheld(step_duration)
		timer.start(step_duration_timer)
		yield(timer, "timeout")

		Input.vibrate_handheld(step_duration * 2)
		timer.start(step_duration_timer * 1.5)
		yield(timer, "timeout")
