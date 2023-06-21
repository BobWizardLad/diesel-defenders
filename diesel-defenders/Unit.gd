# Pawn on the game board
# The board will manage the unit's position, and the master will manage the unit's state.
# This is a visual representation of the game state that grid & master manipulates
class_name Unit
extends Path2D

@export var grid: Resource = load("res://Grid.tres")

@export var move_range = 6
@export var move_speed = 50.0
@export var skin: Texture

signal walk_finished

# Cell is location IN GRID not pixels
var cell = Vector2.ZERO
var points = []

var is_selected = false
var is_walking = false

@onready var _sprite: Sprite2D = $Path/Sprite
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _path_follow: PathFollow2D = $Path

@onready var _cursor: Node2D = load("res://Cursor.tscn").instantiate()

# Setter for unit sprite
func set_skin(texture: Texture) -> void:
	skin = texture

# Setter that places units on grid
# Ensures snap to grid and within bounds
func set_cell(coord: Vector2) -> void:
	cell = grid.is_within_bounds(coord)

# Setter for the is unit selected flag
func set_is_selected(value: bool) -> void:
	is_selected = value
	if is_selected:
		pass
	else:
		pass

# Setter for the is unit walking (move & animate) flag
func set_is_walking(value: bool) -> void:
	is_walking = value
	set_process(is_walking)

# Prepare the game
# Snap the unit into the grid system via functions from Grid
func _ready() -> void:
	# Delay the execution of _process so that we only move when we want to
	set_process(false)
	
	cell = grid.get_map_to_grid(position)
	position = grid.get_grid_snap(cell)
	
	curve = Curve2D.new()
	
	_cursor.connect("move_order", on_move_order, CONNECT_PERSIST)

func _process(delta: float) -> void:
	# Progress along the path curve
	_path_follow.progress += move_speed * delta
	
	# If we reach 100% of the path (complete the trip), reset at new cell
	if _path_follow.progress_ratio >= 1.0:
		self.set_is_walking(false)
		_path_follow.progress = 0.0
		position = grid.get_grid_snap(cell)
		curve.clear_points()
		
		emit_signal("walk_finished")

func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.get_grid_snap(point) - position)
	
	cell = path[-1]
	self.set_is_walking(true)

func on_move_order(cell) -> void:
	points.append(cell)
	walk_along(PackedVector2Array(points))
