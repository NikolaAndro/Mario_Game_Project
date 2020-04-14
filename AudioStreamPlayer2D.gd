extends AudioStreamPlayer2D

var coin = load("res://music/coin.wav")
var one_up = load("res://music/1-up.wav")
var powerup = load("res://music/powerup.wav")
var break_block = load("res://music/breakblock.wav")
var powerup_appeared = load("res://music/powerup_appears.wav")
var fireball = load("res://music/fireball.wav")
var flagpole = load("res://music/flagpole.wav")
var jumping_small = load("res://music/jump_small.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#this audio stream player is specifically used for sound effects
#this function uses essentially a Godot switch case to set the stream based on passed parameter
func playSound(soundName):
	match(soundName):
		"coin":
			stream = coin
		"one_up":
			stream = one_up
		"powerup":
			stream = powerup
		"break_block":
			stream = break_block
		"powerup_appeared":
			stream = powerup_appeared
		"fireball":
			stream = fireball
		"flagpole":
			stream = flagpole
		"jumping_small":
			stream = jumping_small
		
	play()
	   
