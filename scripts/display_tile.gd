extends TextureRect

export var _group_name =""
var _points = 0
var _voltorb = 0

func _ready():
	get_tree().get_root().get_node("Main").connect("level_cleared", self,"_on_level_cleared")

func _get_tile_values():
	var tiles_in_group = get_tree().get_nodes_in_group(_group_name)
	for tile in tiles_in_group:
		_points =  _points + tile._tile_value
		if tile._tile_value == 0:
			_voltorb += 1

# signal event
func _on_level_cleared(max_score):
	_points = 0
	_voltorb = 0
	_get_tile_values()
	self.get_node("PointsDisplay").set_text(str(_points))
	self.get_node("VoltorbDisplay").set_text(str(_voltorb))
