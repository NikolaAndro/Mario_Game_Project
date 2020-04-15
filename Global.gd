extends Node
var current_scene
var invincible = 0
var tile_pos = Vector2(0,0)#keeps the position of the tile the player colided with
var enemy1_tile_pos = Vector2(1,1) #keeps the position of the tile the enemy 1 colided with
var enemy2_tile_pos = Vector2(2,2) #keeps the position of the tile the enemy 2 colided with
var enemy3_tile_pos = Vector2(3,3) #keeps the position of the tile the enemy 3 colided with
var enemy4_tile_pos = Vector2(4,4) #keeps the position of the tile the enemy 4 colided with
var enemy5_tile_pos = Vector2(5,5) #keeps the position of the tile the flying enemy colided with
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lives = 3
var score = 0
var coins = 0
var counter = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
