extends Node2D

const PuzzlePieceScene := preload("res://scenes/puzzle_piece.tscn")

@export var puzzle: Puzzle
@export var round_duration: float = 60.0
@export var cell_size: Vector2 = Vector2(100, 100)
@export var preview_origin: Vector2 = Vector2(80, 140)
@export var solve_origin: Vector2 = Vector2(680, 140)

var _start_button: Button
var _score_label: Label
var _time_label: Label
var _timer: Timer
var _time_left: float = 0.0
var _running: bool = false
var _pieces: Array[PuzzlePiece] = []
var _preview_nodes: Array[ColorRect] = []


func _ready() -> void:
	_build_hud()
	GameState.score_changed.connect(_on_score_changed)
	GameState.score = 0
	GameState.mode = GameState.Mode.EXAMINING
	GameState.fuzz_level = 0.0
	_set_time_remaining(round_duration)
	_on_score_changed(GameState.score)
	_build_preview()


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	layer.name = "HUD"
	add_child(layer)

	var panel := PanelContainer.new()
	panel.anchor_right = 1.0
	panel.offset_left = 8.0
	panel.offset_top = 8.0
	panel.offset_right = -8.0
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	layer.add_child(panel)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 24)
	panel.add_child(hbox)

	_start_button = Button.new()
	_start_button.text = "START"
	_start_button.pressed.connect(_on_start_pressed)
	hbox.add_child(_start_button)

	_score_label = Label.new()
	_score_label.text = "Score: 0"
	hbox.add_child(_score_label)

	_time_label = Label.new()
	_time_label.text = "Time: %.1f" % round_duration
	hbox.add_child(_time_label)

	_timer = Timer.new()
	_timer.one_shot = false
	_timer.wait_time = 0.1
	_timer.timeout.connect(_on_tick)
	add_child(_timer)


func _build_preview() -> void:
	if puzzle == null:
		return
	for n in _preview_nodes:
		n.queue_free()
	_preview_nodes.clear()
	for r in puzzle.grid_rows:
		for c in puzzle.grid_columns:
			var tile := ColorRect.new()
			tile.size = cell_size - Vector2(4, 4)
			tile.position = preview_origin + Vector2(c, r) * cell_size
			tile.color = Color(0.8, 0.6, 0.4)
			tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
			add_child(tile)
			_preview_nodes.append(tile)


func _spawn_pieces() -> void:
	if puzzle == null:
		return
	for p in _pieces:
		p.queue_free()
	_pieces.clear()

	var targets: Array[Vector2] = []
	for r in puzzle.grid_rows:
		for c in puzzle.grid_columns:
			targets.append(solve_origin + Vector2(c, r) * cell_size)

	var starts := targets.duplicate()
	starts.shuffle()

	for i in targets.size():
		var p: PuzzlePiece = PuzzlePieceScene.instantiate()
		add_child(p)
		p.target_position = targets[i]
		p.global_position = starts[i]
		_pieces.append(p)


func _on_start_pressed() -> void:
	if _running:
		get_tree().reload_current_scene()
		return
	_running = true
	_start_button.text = "RESTART"
	GameState.score = 0
	_time_left = round_duration
	_set_time_remaining(_time_left)
	_spawn_pieces()
	GameState.mode = GameState.Mode.FUZZY
	var tw := create_tween()
	tw.tween_property(GameState, "fuzz_level", 1.0, 0.6)
	_timer.start()


func _on_tick() -> void:
	_time_left = max(0.0, _time_left - _timer.wait_time)
	_set_time_remaining(_time_left)
	if _time_left <= 0.0:
		_end_round()


func _end_round() -> void:
	_running = false
	_timer.stop()
	GameState.mode = GameState.Mode.SOLVED
	var tw := create_tween()
	tw.tween_property(GameState, "fuzz_level", 0.0, 0.4)
	_time_label.text = "Time's up!"


func _on_score_changed(s: int) -> void:
	if _score_label:
		_score_label.text = "Score: %d" % s


func _set_time_remaining(t: float) -> void:
	if _time_label:
		_time_label.text = "Time: %.1f" % t
