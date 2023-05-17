extends Node2D

var selected = [] # array of active units
var dragging = false # is mouse selection active
var drag_start = Vector2.ZERO # Initial pos for drag action
var select_rect = RectangleShape2D.new() # Collision shape for drag box

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(delta):
	if Input.is_action_pressed("Lclick"):
		print("ha")
		if selected.size() == 0:
			drag_start = get_global_mouse_position()
			dragging = true
		pass
	elif dragging:
		dragging = false # Release drag if action is not pressed
	
	if Input.is_action_pressed("Rclick"):
		# Give selection of units a new target position
		pass

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
			Color(.5,.5,.5), false)
