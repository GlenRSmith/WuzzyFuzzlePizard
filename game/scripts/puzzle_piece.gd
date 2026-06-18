class_name PuzzlePiece
extends Node2D

@export var target_position: Vector2 = Vector2.ZERO
@export var grid_index: Vector2i = Vector2i.ZERO
@export var snap_radius: float = 24.0
@export var piece_size: Vector2 = Vector2(96, 96)

@onready var _rect: ColorRect = $ColorRect

var _dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _snapped: bool = false
var _ghost: ColorRect


func _ready() -> void:
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.size = piece_size
	_spawn_ghost.call_deferred()
	GameState.fuzz_level_changed.connect(_on_fuzz_changed)
	_on_fuzz_changed(GameState.fuzz_level)


func _spawn_ghost() -> void:
	_ghost = ColorRect.new()
	_ghost.name = "%s_ghost" % name
	_ghost.size = piece_size
	var c := _rect.color
	_ghost.color = Color(c.r, c.g, c.b, 0.25)
	_ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ghost.position = target_position
	_ghost.z_index = -1
	get_parent().add_child(_ghost)


func _on_fuzz_changed(level: float) -> void:
	if _rect and _rect.material:
		_rect.material.set_shader_parameter("fuzz_amount", level)


func _input(event: InputEvent) -> void:
	if _snapped or GameState.mode != GameState.Mode.FUZZY:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse := get_global_mouse_position()
		var hit_rect := Rect2(global_position, piece_size)
		if event.pressed and hit_rect.has_point(mouse):
			_dragging = true
			_drag_offset = global_position - mouse
			get_viewport().set_input_as_handled()
		elif not event.pressed and _dragging:
			_dragging = false
			_try_snap()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() + _drag_offset


func _try_snap() -> void:
	if global_position.distance_to(target_position) <= snap_radius:
		global_position = target_position
		_snapped = true
		if _ghost:
			_ghost.queue_free()
			_ghost = null
		GameState.award(1)
