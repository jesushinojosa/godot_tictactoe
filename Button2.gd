extends Button
var next_scene = preload("res://grid.tscn")
func _on_Button2_pressed():
	global.player = 'O'
	global.human_player = 'O'
	get_tree().change_scene_to(next_scene)
