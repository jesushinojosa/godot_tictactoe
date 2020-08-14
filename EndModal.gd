extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var winner = null
onready var popup_diag = $PopupDialog
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var text = "It's a tie!"
	if winner:
		text = "PLAYER WINS!" if winner == "X" else "AI WINS!"
	$PopupDialog/Panel/Winner.text = text


func _on_Button_pressed():
	global.reset()
	get_tree().change_scene("res://InitialScreen.tscn")
