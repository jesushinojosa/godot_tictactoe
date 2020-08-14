extends Node2D
onready var ai = $AI
signal ai_turn
func _ready():
	if global.human_player == "O":
		emit_signal("ai_turn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ai.terminal(global.board):
		var winner = ai.winner(global.board)
		yield(get_tree().create_timer(1.0), "timeout")
		$modal.winner = winner
		$modal.popup_diag.popup()
						
