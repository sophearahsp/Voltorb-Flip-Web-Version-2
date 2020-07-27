extends TextureRect

signal level_ended

var _current_level = 1
var _level_score = 0
var _max_score = 0

var _total_score = 0

func _ready():
	# connect main's "level_ready" signal to setup new level
	get_tree().get_root().get_node("Main").connect("level_cleared",self,"_on_level_cleared")

func _on_level_cleared(max_score):
	_connect_tiles()
	_max_score = max_score
	_level_score = 0
	$LevelLabel.set_text("level: "+str(_current_level))
	display_scores()
	get_tree().get_root().get_node("Main/HBoxContainer/CenterContainer/GameBoard/11").grab_focus()

# connect tiles
func _connect_tiles():
	var tiles = _get_tiles()
	for i in range(0,tiles.size()):
		tiles[i].connect("level_score_updated", self, "_on_level_score_updated")
		
# signal handler for level_score_updated
func _on_level_score_updated(score):
	if _level_score == 0:
		_level_score = score
	else:
		_level_score = _level_score * score
	$ScoreLabel.set_text(str(_total_score + _level_score))
	
	# level ends
	if score == 0:
		if not _current_level == 1:	
			_current_level -= 1
		emit_signal("level_ended", "lose", _current_level)
	elif _level_score == _max_score:# if win level
		_total_score = _total_score + _level_score # make new total score
		if _current_level < 8:
			print("won level "+str(_current_level))
			_current_level = _current_level + 1
			emit_signal("level_ended", "win", _current_level)
		elif _current_level >= 9:
			print("win entire game")
	display_scores()

# util
func _get_tiles():
	var grid = get_tree().get_root().get_node("Main/HBoxContainer/CenterContainer/GameBoard")
	var tiles = []
	for t in grid.get_children():
		if t is TextureButton:
			tiles.append(t)
	return tiles

# TESTING PURPOSES ONLY
func display_scores():
	var label = get_tree().get_root().get_node("Main/HBoxContainer/MarginContainer/PlayerControls/Label")
	label.set_text("level: "+str(_current_level)+"\n"+"total_score: "+str(_total_score)+"\n"+"level_score: "+str(_level_score)+"\n"+"max_score: "+str(_max_score))
	
