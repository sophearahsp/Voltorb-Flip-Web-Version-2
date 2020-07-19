extends TextureRect

export var _group_name =""
var _points = 0
var _voltorb = 0

func _ready():
	get_tree().get_root().get_node("Main").connect("display_updated", self,"_on_display_updated")
	_get_group_name()

func _get_group_name():
	if (self.name.ends_with("1")):
		_group_name = "red_"
	elif (self.name.ends_with("2")):
		_group_name = "green_"
	elif (self.name.ends_with("3")):
		_group_name = "orange_"
	elif (self.name.ends_with("4")):
		_group_name = "blue_"
	elif (self.name.ends_with("5")):
		_group_name = "purple_"
		
	if (self.name.begins_with("R")):
		_group_name = _group_name + "row"
	else:
		_group_name = _group_name + "col"

func _get_values():
	var tiles_in_group = get_tree().get_nodes_in_group(_group_name)
	for tile in tiles_in_group:
		_points =  _points + tile._tile_value
		if tile._tile_value == 0:
			_voltorb += 1

# signal event
func _on_display_updated():
	_points = 0
	_voltorb = 0
	_get_values()
	
	self.get_node("PointsDisplay").set_text(str(_points))
	self.get_node("VoltorbDisplay").set_text(str(_voltorb))

