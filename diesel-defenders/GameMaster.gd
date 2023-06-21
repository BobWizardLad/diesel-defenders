# Main controller for the game's systems and shareextends Node2D
extends Node2D

signal accept_pressed(cell)
signal moved(new_cell)
signal move_order(cell)
signal selection(cell)
signal walk_finished
