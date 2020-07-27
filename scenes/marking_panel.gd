extends TextureRect

signal mark_changed

var _tile

func _ready():
	get_tree().get_root().get_node("Main").connect("level_cleared",self,"_on_level_cleared")

func _on_level_cleared(max_score):
	_connect_tiles()
	for button in get_node("CenterContainer/GridContainer").get_children():
		button.pressed = false

func _on_panel_updated(tile):
	_tile = tile
	_update_buttons()

func _update_buttons():
	for setting in _tile._tile_marks.size():
		get_node("CenterContainer/GridContainer").get_children()[setting].pressed = _tile._tile_marks[setting]

# connect all tiles
func _connect_tiles():
	var tiles = _get_tiles()
	for i in range(0,tiles.size()):
		tiles[i].connect("panel_updated", self, "_on_panel_updated")
		
func _get_tiles():
	var grid = get_tree().get_root().get_node("Main/HBoxContainer/CenterContainer/GameBoard")
	var tiles = []
	for t in grid.get_children():
		if t is TextureButton:
			tiles.append(t)
	return tiles

func _mark_button_toggle(button):
	_tile._tile_marks[button] = !_tile._tile_marks[button]
	get_node("CenterContainer/GridContainer/Mark"+str(button)+"Button").pressed = !_tile._tile_marks[button] 
		
	if _tile._tile_marks[button] == true:
		_tile.get_node("Mark"+str(button)).show()
	else:
		_tile.get_node("Mark"+str(button)).hide()

func _on_MarkVButton_button_down():
	_toggle_mark0()

func _on_Mark1Button_button_down():
	_toggle_mark1()

func _on_Mark2Button_button_down():
	_toggle_mark2()

func _on_Mark3Button_button_down():
	_toggle_mark3()

func _process(delta):
	if Input.is_action_just_pressed("toggle_mark0"):
		_toggle_mark0()
	elif Input.is_action_just_pressed("toggle_mark1"):
		_toggle_mark1()
	elif Input.is_action_just_pressed("toggle_mark2"):
		_toggle_mark2()	
	elif Input.is_action_just_pressed("toggle_mark3"):
		_toggle_mark3()	
		
func _toggle_mark0():
	if _tile != null:
		if _tile._revealed == true:
			$CenterContainer/GridContainer/Mark0Button.pressed = true
		else:
			_mark_button_toggle(0)

func _toggle_mark1():
	if _tile != null:
		if _tile._revealed == true:
			$CenterContainer/GridContainer/Mark1Button.pressed = true
		else:
			_mark_button_toggle(1)

func _toggle_mark2():
	if _tile != null:
		if _tile._revealed == true:
			$CenterContainer/GridContainer/Mark2Button.pressed = true
		else:
			_mark_button_toggle(2)

func _toggle_mark3():
	if _tile != null:
		if _tile._revealed == true:
			$CenterContainer/GridContainer/Mark3Button.pressed = true
		else:
			_mark_button_toggle(3)
