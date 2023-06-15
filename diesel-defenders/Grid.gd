# Visual brain for game battle instance: Handle all mapping between logic and game board
# Gives state to GameMaster, Handles decisions from GameMaster, Maps onto TileMap, Updates Unit position
class_name Grid
extends Resource

# Size of the grid: AxB sized game board
@export var size: Vector2 = Vector2(16, 12)
# Size of offset from global root to grid
@export var grid_offset: Vector2 = Vector2(128, 128)
# Size of each cell in pixels: AxA cell dimension
@export var cell_size: Vector2 = Vector2(32, 32)
var _cell_half = cell_size / 2
var _tile_offset = grid_offset / cell_size

# Input the inner-grid position, get the map location by pixels
# Used to snap nodes into the grid system
func get_grid_snap(grid_position: Vector2) -> Vector2:
	return (grid_position * cell_size + _cell_half) + grid_offset

# Input a pixel position on map, get the grid tile it is in
# Used to relate map coordinates to grid tiles
# Used with get_grid_snap to place objects
func get_map_to_grid(map_position: Vector2) -> Vector2:
	return ((map_position + _tile_offset)/ cell_size).floor()

# Checker to see if inner-grid coordinate is within bounds of the play area
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out = cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y

# Get the integer index of a cell to bypass a 2D array
func as_index(cell: Vector2) -> int:
	return int(cell.x + size.x * cell.y)
