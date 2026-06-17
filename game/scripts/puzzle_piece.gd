class_name PuzzlePiece
extends Node2D

@export var target_position: Vector2 = Vector2.ZERO
@export var grid_index: Vector2i = Vector2i.ZERO
@export var snap_radius: float = 24.0

@onready var _rect: ColorRect = $ColorRect

var _dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _snapped: bool = false


func _ready() -> void:
	GameState.fuzz_level_changed.connect(_on_fuzz_changed)
	_on_fuzz_changed(GameState.fuzz_level)


func _on_fuzz_changed(level: float) -> void:
	if _rect and _rect.material:
		_rect.material.set_shader_parameter("fuzz_amount", level)


func _unhandled_input(event: InputEvent) -> void:
	if _snapped or GameState.mode != GameState.Mode.FUZZY:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var local := _rect.get_global_rect()
		if event.pressed and local.has_point(event.position):
			_dragging = true
			_drag_offset = global_position - event.position
			get_viewport().set_input_as_handled()
		elif not event.pressed and _dragging:
			_dragging = false
			_try_snap()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and _dragging:
		global_position = event.position + _drag_offset


func _try_snap() -> void:
	if global_position.distance_to(target_position) <= snap_radius:
		global_position = target_position
		_snapped = true
		GameState.award(1)
