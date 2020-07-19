extends TextureButton

signal level_score_updated

export var _tile_value = -1
export var _revealed = false

func _ready():
	pass

func _on_Tile_button_down():
	if _revealed == false:
		_revealed = true
		emit_signal("level_score_updated", _tile_value)
		self.set_hover_texture(load(""))
		if _tile_value == 0:
			self.set_normal_texture(load("res://assets/1x/RevealTileVx1.png"))
		elif _tile_value == 1:
			self.set_normal_texture(load("res://assets/1x/RevealTile1x1.png"))
		elif _tile_value == 2:
			self.set_normal_texture(load("res://assets/1x/RevealTile2x1.png"))
		elif _tile_value == 3:
			self.set_normal_texture(load("res://assets/1x/RevealTile3x1.png"))

