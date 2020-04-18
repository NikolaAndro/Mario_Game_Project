extends Node
var current_scene
var invincible = 0		#Checking if Mario is invincible
var damage = 0  #Checking if mario is invincible after getting hit by enemy
var tile_pos = Vector2(0,0)#keeps the position of the tile the player colided with
var enemy1_tile_pos = Vector2(1,1) #keeps the position of the tile the enemy 1 colided with
var enemy2_tile_pos = Vector2(2,2) #keeps the position of the tile the enemy 2 colided with
var enemy3_tile_pos = Vector2(3,3) #keeps the position of the tile the enemy 3 colided with
var enemy4_tile_pos = Vector2(4,4) #keeps the position of the tile the enemy 4 colided with
var enemy5_tile_pos = Vector2(5,5) #keeps the position of the tile the flying enemy colided with
var lives = 3	#numbers of lives Mario has.
var score = 0	#Score the Mario reached.
var coins = 0	#Number of coins Mario collected
var counter = 300	#Counter for level's time limit
