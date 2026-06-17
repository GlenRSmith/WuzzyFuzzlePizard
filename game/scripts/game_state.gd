extends Node

enum Mode { BROWSING, EXAMINING, PUFFING_PIPE, FUZZY, SURRENDERING, SOLVED }

signal mode_changed(new_mode: Mode, old_mode: Mode)
signal fuzz_level_changed(level: float)
signal score_changed(score: int)

var mode: Mode = Mode.BROWSING:
	set(value):
		if value == mode:
			return
		var old := mode
		mode = value
		mode_changed.emit(mode, old)

var fuzz_level: float = 0.0:
	set(value):
		value = clamp(value, 0.0, 1.0)
		if is_equal_approx(value, fuzz_level):
			return
		fuzz_level = value
		fuzz_level_changed.emit(fuzz_level)

var score: int = 0:
	set(value):
		if value == score:
			return
		score = value
		score_changed.emit(score)


func multiplier() -> float:
	return 1.0 + 3.0 * fuzz_level


func award(base_points: int) -> void:
	score += int(round(float(base_points) * multiplier()))


func request_puff() -> void:
	if mode == Mode.EXAMINING:
		mode = Mode.PUFFING_PIPE


func puff_animation_finished() -> void:
	if mode == Mode.PUFFING_PIPE:
		mode = Mode.FUZZY


func request_surrender() -> void:
	if mode == Mode.FUZZY:
		mode = Mode.SURRENDERING


func surrender_animation_finished() -> void:
	if mode == Mode.SURRENDERING:
		fuzz_level = 0.0
		mode = Mode.EXAMINING


func mark_solved() -> void:
	if mode == Mode.FUZZY:
		mode = Mode.SOLVED
