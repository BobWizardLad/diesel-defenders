# Cursor for interacting with the gameboard.
# Operates with signals and no direct dependencies beyond the singleton.
class_name Cursor
extends Node2D

@export var grid: Resource = load("res://Grid.tres")

# Get the game master singleton
@onready var gameMaster = get_node("/root/GameMaster")

@onready var _timer: Timer = $Cooldown

var ui_cooldown = 0.1
var cell = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	_timer.wait_time = ui_cooldown
	position = grid.get_grid_snap(cell)
	
func _unhandled_input(event):
	# Handle cursor movement
	if event.is_action_pressed("ui_up"):
		set_cell(self.cell + Vector2.UP)
	elif event.is_action_pressed("ui_down"):
		set_cell(self.cell + Vector2.DOWN)
	elif event.is_action_pressed("ui_right"):
		set_cell(self.cell + Vector2.RIGHT)
	elif event.is_action_pressed("ui_left"):
		set_cell(self.cell + Vector2.LEFT)
	
	if event.is_action("ui_select") && _timer.is_stopped():
		gameMaster.emit_signal("move_order", cell)
		_timer.start()

# We use the draw callback to a rectangular outline the size of a grid cell, with a width of two
# pixels.
func _draw() -> void:
	# Rect2 is built from the position of the rectangle's top-left corner and its size. To draw the
	# square around the cell, the start position needs to be `-grid.cell_size / 2`.
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.SKY_BLUE, false, 2.0)

func set_cell(value: Vector2) -> void:
	var new_cell: Vector2 = value
	# Stop the function if there was no cell change 
	# or if the timer is running
	if new_cell.is_equal_approx(cell) || !_timer.is_stopped():
		return
	
	cell = new_cell
	# If we move to a new cell, we update the cursor's position, emit a signal, and start the
	# cooldown timer that will limit the rate at which the cursor moves when we keep the direction
	# key down.
	position = grid.get_grid_snap(cell)
	gameMaster.emit_signal("moved", cell)
	_timer.start()
	
