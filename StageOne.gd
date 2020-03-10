extends Node2D

var path = "res://Flat_World.csv"
var counter = 300

func _ready():
	getData()
	$player/VBoxContainer/Current_Time.text = str(counter)
	#MusicController.play("res://music/Super_Mario_Bros_Music.ogg")
	
func _on_Timer_timeout():
	counter -= 1
	$player/VBoxContainer/Current_Time.text = str(counter)

func getData():
#	var result = {}
#	var file = File.new()
#	file.open(path, file.READ)
#	var text = file.get_as_text()
#	validate_json(text)
#	var result_json = JSON.parse(text).result
#	file.close()
	#print(result_json["2"]["FIELD3"])
	#print(result_json)
	
	var mainData = {}
	var numRows = 0
	var numCols = 0
	var count = 0
	var file = File.new()
	file.open(path, file.READ)
	while !file.eof_reached():
		var dataSet = Array(file.get_csv_line())
		numRows += 1
		mainData[mainData.size()] = dataSet;
	file.close()
	numCols = mainData[0].size()
	print(mainData)
	#for i in result_json:
	#	for j in result_json:
	for i in numRows:
		for j in numCols:
			if(mainData[i][j] == 'a'):
				print("Stone - color 1")
				
#		if(mainData[i][j] == 'b'):
#			print("Block - color 1")
#		if(mainData[i][j] == 'c'):
#			print("Brick - color 1")
#		if(mainData[i][j] == 'd'):
#			print("multi-coin box - c1")
#		if(mainData[i][j] == 'e'):
#			print("Power Up - c1")
#		if(mainData[i][j] == 'f'):
#			print("star - c1")
#		if(mainData[i][j] == 'g'):
#			print("1up - c1")
#		if(mainData[i][j] == 'h'):
#			print("Dead Box - c1")
#		if(mainData[i][j] == 'i'):
#			print("Vine - c1")
#		if(mainData[i][j] == 'j'):
#			print("Stone - color 2")
#		if(mainData[i][j] == 'k'):
#			print("Block - color 2")
#		if(mainData[i][j] == 'l'):
#			print("Brick - color 2")
#		if(mainData[i][j] == 'm'):
#			print("multi-coin box - c2")
#		if(mainData[i][j] == 'n'):
#			print("Power Up - c2")
#		if(mainData[i][j] == 'o'):
#			print("star - c2")
#		if(mainData[i][j] == 'p'):
#			print("1up - c2")
#		if(mainData[i][j] == 'q'):
#			print("Dead Box - c2")
#		if(mainData[i][j] == 'r'):
#			print("Vine - c2")
#		if(mainData[i][j] == 's'):
#			print("Stone - color 3")
#		if(mainData[i][j] == 't'):
#			print("Stone - color 3")
#		if(mainData[i][j] == 'u'):
#			print("Brick - color 3")
#		if(mainData[i][j] == 'v'):
#			print("multi-coin box - c3")
#		if(mainData[i][j] == 'w'):
#			print("Power Up - c3")
#		if(mainData[i][j] == 'x'):
#			print("star - c3")
#		if(mainData[i][j] == 'y'):
#			print("1up - c3")
#		if(mainData[i][j] == 'z'):
#			print("Dead Box - c3")
#		if(mainData[i][j] == '{'):
#			print("Vine - c3")
#		if(mainData[i][j] == '|'):
#			print("Hidden Level Separator")	
#		if(mainData[i][j] == '~'):
#			print("Flagpole")
#		if(mainData[i][j] == '_'):
#			print("blank")
#		if(mainData[i][j] == '1'):
#			print("Enemy 1")
#		if(mainData[i][j] == '2'):
#			print("Enemy 2")
#		if(mainData[i][j] == '3'):
#			print("Enemy 3")
#		if(mainData[i][j] == '4'):
#			print("Enemy 4")
#		if(mainData[i][j] == '5'):
#			print("Enemy 5")
#		if(mainData[i][j] == '@'):
#			print("Dead Box")
#		if(mainData[i][j] == 'A'):
#			print("? - Single Coin Box")
#		if(mainData[i][j] == 'B'):
#			print("? - Power Up")
#		if(mainData[i][j] == 'C'):
#			print("? - Star")
#		if(mainData[i][j] == 'D'):
#			print("? - 1up")
#		if(mainData[i][j] == 'E'):
#			print("Coin")
#		if(mainData[i][j] == 'F'):
#			print("hidden PowerUp")
#		if(mainData[i][j] == 'G'):
#			print("hideen Star")
#		if(mainData[i][j] == 'H'):
#			print("Hidden 1up")
#		if(mainData[i][j] == 'I'):
#			print("Platform - Falling")
#		if(mainData[i][j] == 'J'):
#			print("Platform - Drops")
#		if(mainData[i][j] == 'K'):
#			print("Platform - Scrolling Up")
#		if(mainData[i][j] == 'L'):
#			print("Platform - Scrolling Down")
#		if(mainData[i][j] == 'M'):
#			print("Platform U/D")
#		if(mainData[i][j] == 'N'):
#			print("Platform R/L")
#		if(mainData[i][j] == 'O'):
#			print("Fire Floor")
#		if(mainData[i][j] == 'P'):
#			print("Pipe")
#		if(mainData[i][j] == 'Q'):
#			print("Pipe Jump Out")
#		if(mainData[i][j] == 'R'):
#			print("Pipe Jump Back")
#		if(mainData[i][j] == 'S'):
#			print("Side Pipe")
#		if(mainData[i][j] == 'T'):
#			print("Side Pipe Jump Out")
#		if(mainData[i][j] == 'U'):
#			print("Side Pipe Jump Back")
#		if(mainData[i][j] == 'W'):
#			print("Checkpoint")
#		if(mainData[i][j] == 'X'):
#			print("Reentry Point for cloud world")
#		if(mainData[i][j] == 'Y'):
#			print("Reentry Fire Box - clockwise")
#		if(mainData[i][j] == 'Z'):
#			print("Rotating Fire Box - clockwise")				
	#return mainData
	
	
	
		

