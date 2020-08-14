extends Area2D
export var board_action = [0,0]
var X = preload("res://assets/Xplayer.png")
var O = preload("res://assets/Oplayer.png")
var selected = false
signal ai_turn
func _ready():
	pass


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_player_cell_input_event(viewport, event, shape_idx):
	#print("PRESIONADO")
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && !selected:
		if(global.ai_playing):
			return
		var sprite = X if global.player == 'X' else O
		$player_sprite.set_texture(sprite)
		selected = true
		global.board[board_action[0]][board_action[1]] = global.player	
		if global.player == global.human_player:
			global.ai_playing = true
			print("emitir señal")
			emit_signal('ai_turn')
			print("Señal emitida")
		global.next_player()
		print("Action", board_action)
		
