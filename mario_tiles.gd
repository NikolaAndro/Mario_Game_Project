extends TileMap

var _tileset
var path = "res://level_one.csv"

func _ready():
	setMap()

func setMap():
#	var result = {}
#	var file = File.new()
#	file.open(path, file.READ)
#	var text = file.get_as_text()
#	validate_json(text)
#	var result_json = JSON.parse(text).result
#	file.close()
	#print(result_json["2"]["FIELD3"])
	#print(result_json)
	_tileset = get_tileset()
	var tile_pos  = Vector2()
	var mainData = {}
	var numRows = 0
	var numCols = 0
	var count = 0
	var tile_type
	var file = File.new()
	file.open(path, file.READ)
	while !file.eof_reached():
		var dataSet = Array(file.get_csv_line())
		numRows += 1
		mainData[mainData.size()] = dataSet;
	file.close()
	numCols = mainData[0].size() -1
	numRows -= 1
	for i in numRows:
		for j in numCols:
			if(mainData[i][j] == 'a'):
				tile_type = "Stone - color 1"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite13"))
			if(mainData[i][j] == 'b'):
				tile_type = "block - color 1"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite19"))
			if(mainData[i][j] == 'c'):
				tile_type = "Brick - color 1"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite6"))
			if(mainData[i][j] == 'd'):
				print("multi-coin box - c1")
			if(mainData[i][j] == 'e'):
				tile_type = "Power Up - c1"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite14"))
			if(mainData[i][j] == 'f'):
				tile_type = "star - c1"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite18"))
			if(mainData[i][j] == 'g'):
				tile_type = "1up - c1"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite15"))
			if(mainData[i][j] == 'h'):
				tile_type = "Dead Box - c1"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite4"))
			if(mainData[i][j] == 'i'):
				tile_type = "Vine - c1"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite5"))
			if(mainData[i][j] == 'j'):
				print("Stone - color 2")
			if(mainData[i][j] == 'k'):
				print("Block - color 2")
			if(mainData[i][j] == 'l'):
				print("Brick - color 2")
			if(mainData[i][j] == 'm'):
				print("multi-coin box - c2")
			if(mainData[i][j] == 'n'):
				print("Power Up - c2")
			if(mainData[i][j] == 'o'):
				print("star - c2")
			if(mainData[i][j] == 'p'):
				print("1up - c2")
			if(mainData[i][j] == 'q'):
				print("Dead Box - c2")
			if(mainData[i][j] == 'r'):
				print("Vine - c2")
			if(mainData[i][j] == 's'):
				print("Stone - color 3")
			if(mainData[i][j] == 't'):
				print("Stone - color 3")
			if(mainData[i][j] == 'u'):
				print("Brick - color 3")
			if(mainData[i][j] == 'v'):
				print("multi-coin box - c3")
			if(mainData[i][j] == 'w'):
				print("Power Up - c3")
			if(mainData[i][j] == 'x'):
				print("star - c3")
			if(mainData[i][j] == 'y'):
				print("1up - c3")
			if(mainData[i][j] == 'z'):
				print("Dead Box - c3")
			if(mainData[i][j] == '{'):
				print("Vine - c3")
			if(mainData[i][j] == '|'):
				print("Hidden Level Separator")	
			if(mainData[i][j] == '~'):
				tile_type = "Flagpole"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite20"))
			if(mainData[i][j] == "^"):
				tile_type = "flag"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite21"))
			if(mainData[i][j] == '_'):
				print("blank")
			if(mainData[i][j] == '1'):
				print("Enemy 1")
			if(mainData[i][j] == '2'):
				print("Enemy 2")
			if(mainData[i][j] == '3'):
				print("Enemy 3")
			if(mainData[i][j] == '4'):
				print("Enemy 4")
			if(mainData[i][j] == '5'):
				print("Enemy 5")
			if(mainData[i][j] == '@'):
				print("Dead Box")
			if(mainData[i][j] == 'A'):
				tile_type = "? - Single Coin Box"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite"))
			if(mainData[i][j] == 'B'):
				tile_type = "? - Power Up"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite"))
			if(mainData[i][j] == 'C'):
				tile_type = "? - Star"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite"))
			if(mainData[i][j] == 'D'):
				tile_type = "? - 1up"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite"))
			if(mainData[i][j] == 'E'):
				tile_type = "Coin"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite12"))
			if(mainData[i][j] == 'F'):
				print("hidden PowerUp")
			if(mainData[i][j] == 'G'):
				print("hideen Star")
			if(mainData[i][j] == 'H'):
				print("Hidden 1up")
			if(mainData[i][j] == 'I'):
				print("Platform - Falling")
			if(mainData[i][j] == 'J'):
				print("Platform - Drops")
			if(mainData[i][j] == 'K'):
				print("Platform - Scrolling Up")
			if(mainData[i][j] == 'L'):
				print("Platform - Scrolling Down")
			if(mainData[i][j] == 'M'):
				print("Platform U/D")
			if(mainData[i][j] == 'N'):
				print("Platform R/L")
			if(mainData[i][j] == 'O'):
				print("Fire Floor")
			if(mainData[i][j] == 'P'):
				tile_type = "Pipe"
				tile_pos = Vector2(j,i)
				set_cellv(tile_pos, _tileset.find_tile_by_name("Sprite10"))
			if(mainData[i][j] == 'Q'):
				print("Pipe Jump Out")
			if(mainData[i][j] == 'R'):
				print("Pipe Jump Back")
			if(mainData[i][j] == 'S'):
				print("Side Pipe")
			if(mainData[i][j] == 'T'):
				print("Side Pipe Jump Out")
			if(mainData[i][j] == 'U'):
				print("Side Pipe Jump Back")
			if(mainData[i][j] == 'W'):
				print("Checkpoint")
			if(mainData[i][j] == 'X'):
				print("Reentry Point for cloud world")
			if(mainData[i][j] == 'Y'):
				print("Reentry Fire Box - clockwise")
			if(mainData[i][j] == 'Z'):
				print("Rotating Fire Box - clockwise")
	return mainData
