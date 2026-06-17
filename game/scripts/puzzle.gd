class_name Puzzle
extends Resource

@export var display_name: String = "Untitled Puzzle"
@export var source_image: Texture2D
@export var grid_columns: int = 4
@export var grid_rows: int = 3
@export var base_score_per_piece: int = 10


func piece_count() -> int:
	return grid_columns * grid_rows
