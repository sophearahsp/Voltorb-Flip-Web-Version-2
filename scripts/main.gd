extends Control

signal level_cleared
signal mode_changed

# resources
const Util = preload("res://scripts/util.gd")
var GameBoard = preload("res://scenes/game_board.tscn")
const select_cursor = preload("res://assets/1x/PlayerControls/SelectCursorx1.png")
const mark_cursor = preload("res://assets/1x/PlayerControls/MarkCursorx1.png")

### PRIVATE VARIABLES
# shortcuts
onready var _scoreboard = get_node("HBoxContainer/MarginContainer/PlayerControls/Scoreboard")
onready var _marking_panel = get_node("HBoxContainer/MarginContainer/PlayerControls/CenterContainer/MarkingPanel")
onready var mark_button = get_node("HBoxContainer/MarginContainer/PlayerControls/ButtonBar/MarkButton")
onready var select_button = get_node("HBoxContainer/MarginContainer/PlayerControls/ButtonBar/SelectButton")

# script variables
var _board
var _is_select_mode = true

### FUNCTIONS
func _ready():
	randomize()
	# connect signals
	_scoreboard.connect("level_ended",self,"_on_level_ended")
	# change to custom cursor
	_change_cursor(select_cursor)
	# start game
	_play_level(1)
	
func _play_level(level):
	_new_board()
	
	var level_options = Util.LEVEL_SETTINGS[level][randi()%5]
	_place_tile_values(level_options[2],level_options[0],level_options[1])
	
	# clear 
	emit_signal("level_cleared", level_options[3])
	
func _on_level_ended(result, next_level):
	# results
	if result == "win":
		print("you won the level")
	else:
		print("you lost the level")
	
	# next level
	print("next play level "+str(next_level))
	_board.queue_free()
	yield(get_tree().create_timer(0.01), "timeout")
	_play_level(next_level)

func _place_tile_values(num_zeros, num_twos, num_threes):
	var tiles = _get_tiles()
	
	# what to place
	var zeros = num_zeros
	var twos = num_twos
	var threes = num_threes
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

func _new_board():
	_board = GameBoard.instance()
	get_node("HBoxContainer/CenterContainer").add_child(_board)

# Utils & helper functions
func _get_tiles():
	var grid = _board
	var tiles = []
	for t in grid.get_children():
		if t is TextureButton:
			tiles.append(t)
	return tiles

# Event handler
func _on_MarkButton_toggled(button_pressed):
	if button_pressed == true:
		emit_signal("mode_changed",false)
		_is_select_mode = false
		select_button.pressed = false
		_change_cursor(mark_cursor)
		_marking_panel.show()
	else:
		select_button.pressed = true
		_marking_panel.hide()

func _on_SelectButton_toggled(button_pressed):
	if button_pressed == true:
		emit_signal("mode_changed",true)
		_is_select_mode = true
		mark_button.pressed = false
		_change_cursor(select_cursor)
		_marking_panel.hide()
	else:
		mark_button.pressed = true
		_marking_panel.show()

func _change_cursor(cursor_texture):
	Input.set_custom_mouse_cursor(cursor_texture)
