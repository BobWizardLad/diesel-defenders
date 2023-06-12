# Visual brain for game battle instance: Handle all mapping between logic and game board
# Gives state to GameMaster, Handles decisions from GameMaster, Maps onto TileMap, Updates Unit position
class_name Grid
extends Resource

# Size of the grid: AxB sized game board
@export var size = Vector2(16, 12)
# Size of each cell in pixels: AxA cell dimension
@export var cell_size = 32
var cell_half = cell_size / 2

