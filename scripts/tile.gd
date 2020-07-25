extends TextureButton

signal level_score_updated
signal panel_updated

export var _tile_value = -1
export var _revealed = false

var _mode = true
var _select_border = preload("res://assets/1x/GameBoard/SelectBorderx1.png")
var _mark_border = preload("res://assets/1x/GameBoard/MarkBorderx1.png")

var _tile_marks = [false, false, false, false]

func _ready():
	get_node("/root/Main").connect("mode_changed", self,"_on_mode_changed")

func _on_Tile_button_down():
	if (_mode == true) and (_revealed == false):
		_revealed = true
		emit_signal("level_score_updated", _tile_value)
		
		# set textures
		self.set_hover_texture(null)
		if _tile_value == 0:
			self.set_normal_texture(load("res://assets/1x/GameBoard/RevealTileVx1.png"))
		elif _tile_value == 1:
			self.set_normal_texture(load("res://assets/1x/GameBoard/RevealTile1x1.png"))
		elif _tile_value == 2:
			self.set_normal_texture(load("res://assets/1x/GameBoard/RevealTile2x1.png"))
		elif _tile_value == 3:
			self.set_normal_texture(load("res://assets/1x/GameBoard/RevealTile3x1.png"))
		
		$Mark0.hide()
		$Mark1.hide()
		$Mark2.hide()
		$Mark3.hide()
		
	
func _on_mode_changed(mode):
	_mode = mode
	if (_mode == true):
		$Border.set_texture(_select_border)
	elif (_mode == false):
		$Border.set_texture(_mark_border)
		if get_focus_owner() == self:
			_signal_panel()
	
func _update_tile_markings():
	for i in _tile_marks.size():
		if _tile_marks[i] == true:
			get_node("Mark"+str(i)).show()
		else:
			get_node("Mark"+str(i)).hide()

func _on_Tile_mouse_entered():
	_tile_focus()

func _on_Tile_focus_entered():
	_tile_focus()

func _on_Tile_focus_exited():
	$Border.hide()

func _tile_focus():
	self.grab_focus()
	$Border.show()
	if _mode == false:
		_signal_panel()
		
func _signal_panel():
	emit_signal("panel_updated", self)
