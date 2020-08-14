extends Button
var next_scene = preload("res://grid.tscn")

func _on_Button_pressed():
	global.player = 'X'
	global.human_player = 'X'
	get_tree().change_scene_to(next_scene)
