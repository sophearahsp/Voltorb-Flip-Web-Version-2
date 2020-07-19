#snake_case for file names
extends Control# PascalCase for node names

# the_signals
signal display_updated
signal level_cleared

# for resetting level
var GameBoard = preload("res://scenes/game_board.tscn")

onready var scoreboard = get_node("HBoxContainer/MarginContainer/PlayerControls/Scoreboard")

var board

# const in all caps
const LEVEL_SETTINGS = {
	# level: [x2s,x3s,x0s, _max_score]...
	1:[
		[3,1,6,24],
		[0,3,6,27],
		[5,0,6,32],
		[2,2,6,36],
		[4,1,6,48]
	],
	2:[
		[1,3,7,54],
		[6,0,7,64],
		[3,2,7,72],
		[0,4,7,81],
		[5,1,7,96]
	],
	3:[
		[2,3,8,108],
		[7,0,8,128],
		[4,2,8,144],
		[1,4,8,162],
		[6,1,8,192]
	],
	4:[
		[3,3,8,216],
		[0,5,8,243],
		[8,0,10,256],
		[5,2,10,288],
		[2,4,10,324]
	],
	5:[
		[7,1,10,384],
		[4,3,10,432],
		[1,5,10,486],
		[9,0,10,512],
		[6,2,10,576]
	],
	6:[
		[3,4,10,648],
		[0,6,10,729],
		[8,1,10,768],
		[5,3,10,864],
		[2,5,10,972]
	],
	7:[
		[7,2,10,1152],
		[4,4,10,1296],
		[1,6,13,1458],
		[9,1,13,1536],
		[6,3,10,1728]
	],
	8:[
		[0,7,10,2187],
		[8,2,10,2304],
		[5,4,10,2592],
		[2,6,10,2916],
		[7,3,10,3456]]
}

func _ready():
	randomize()
	_play_level(1)
	scoreboard.connect("level_ended",self,"_on_level_ended")
	
func _play_level(level):
	# refesh board
	board = GameBoard.instance()
	get_node("HBoxContainer/CenterContainer").add_child(board)
	# set up level
	var _level_options = LEVEL_SETTINGS[level][randi()%5]
	_place_tile_values(_level_options[2],_level_options[0],_level_options[1])
	emit_signal("level_cleared", _level_options[3])
	emit_signal("display_updated")
	
func _place_tile_values(num_zeros, num_twos, num_threes):
	var tiles = _get_tiles()
	
	var zeros = num_zeros #6
	var twos = num_twos #3
	var threes = num_threes #1
	var ones = 25 - (num_zeros + num_twos + num_threes)
	
	var count = 25
	
	for t in tiles:
		var n = randi()%count+1
		count -= 1
		if n <= twos:
			t._tile_value = 2
			twos -= 1
		elif (twos < n) and (n <= twos + threes):
			t._tile_value = 3
			threes -= 1
		elif (twos + threes < n) and (n <= twos + threes + zeros):
			t._tile_value = 0
			zeros -= 1
		else:
			t._tile_value = 1
			ones -= 1

func _on_level_ended(result, next_level):
	if result == "win":
		print("you won the level")
	else:
		print("you lost the level")
	print("next play level "+str(next_level))
	board.queue_free()
	yield(get_tree().create_timer(0.01), "timeout")
	_play_level(next_level)


# Utils & helper functions
func _get_tiles():
	var grid = board
	var tiles = []
	for t in grid.get_children():
		if t is TextureButton:
			tiles.append(t)
	return tiles

