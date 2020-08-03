extends Control

signal level_cleared
signal mode_changed

# resources
const Util = preload("res://scripts/util.gd")
var GameBoard = preload("res://scenes/game_board.tscn")
const select_cursor = preload("res://assets/1x/PlayerControls/SelectCursorx1.png")
const mark_cursor = preload("res://assets/1x/PlayerControls/MarkCursorx1.png")

const select_hover = preload("res://assets/1x/PlayerControls/ToggleSelectHoverx1.png")
const select_pressed = preload("res://assets/1x/PlayerControls/ToggleSelectPressedx1.png")
const mark_hover = preload("res://assets/1x/PlayerControls/ToggleMarkHoverx1.png")
const mark_pressed = preload("res://assets/1x/PlayerControls/ToggleMarkPressedx1.png")


### PRIVATE VARIABLES
# shortcuts
onready var _scoreboard = get_node("HBoxContainer/MarginContainer/PlayerControls/Scoreboard")
onready var _marking_panel = get_node("HBoxContainer/MarginContainer/PlayerControls/CenterContainer/MarkingPanel")
onready var toggle_button = get_node("HBoxContainer/MarginContainer/PlayerControls/ToggleButton")
onready var color_background = get_node("ColorBackground")
onready var anim = get_node("AnimationPlayer")
onready var lvl_end_bg = get_node("LevelEndBackground")
onready var lvl_end_label = get_node("LevelEndBackground/LevelEndLabel")


# script variables
var _board
var _is_select_mode = true

### FUNCTIONS
func _ready():
	set_process_input(true)
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
		end_level_anim("WON LEVEL "+str(next_level))
	else:
		end_level_anim("LOST LEVEL "+str(next_level))
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

func _change_cursor(cursor_texture):
	Input.set_custom_mouse_cursor(cursor_texture)

func _on_ToggleButton_button_down():
	toggle_mode()

func _process(delta):
	if Input.is_action_just_pressed("toggle_mode"):
		toggle_mode()

func toggle_mode():
	if _is_select_mode: # change to mark mode
		emit_signal("mode_changed",false)
		_is_select_mode = false
		_change_cursor(mark_cursor)
		_marking_panel.show()
		
		toggle_button.set_normal_texture(mark_hover)
		toggle_button.set_pressed_texture(mark_pressed)
		
	else: # change to select mode
		emit_signal("mode_changed",true)
		_is_select_mode = true
		_change_cursor(select_cursor)
		_marking_panel.hide()
		toggle_button.set_normal_texture(select_hover)
		toggle_button.set_pressed_texture(select_pressed)

func end_level_anim(contents):
	$ColorBackground.show()
	anim.play("intro")
	lvl_end_label.set_text(contents)
	
	yield(get_tree().create_timer(.8), "timeout")
	
	anim.play("outro")
	yield(anim, "animation_finished")
	$ColorBackground.hide()
