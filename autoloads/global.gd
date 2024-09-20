extends Node

var texture_resource : Texture2D
var grid_size : int

func _simulate_test_data():
	texture_resource = load("res://assets/sprites/images/icon1.svg")
	grid_size = 3
