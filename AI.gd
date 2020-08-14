extends Node
var board_mapping = null
var game_over = false
const DEPTH = INF
signal ai_turn

func filled(board):
	var counter = 0
	for i in range(3):
		for j in range(3):
			if board[i][j]:
				counter+=1
	return counter

func player(board):
	return 'O' if filled(board)%2 == 1 else 'X'
	
func actions(board):
	var posible_actions = []
	for i in range(3):
		for j in range(3):
			if not board[i][j]:
				posible_actions.append([i,j])
	return posible_actions
	
func result(board,action):
	var current_player = player(board)
	var board2 = board.duplicate(true)
	board2[action[0]][action[1]] = current_player
	return board2

func winner_row(board):
	if board[0][0] && (board[0][0] == board[0][1] && board[0][1] == board[0][2]):
		return board[0][0]
	if board[1][0] && (board[1][0] == board[1][1] && board[1][1] == board[1][2]):
		return board[1][0]
	if board[2][0] && (board[2][0] == board[2][1] && board[2][1] == board[2][2]):
		return board[2][0]
	return null
	
func winner_col(board):
	if board[0][0] && (board[0][0] == board[1][0] && board[1][0] == board[2][0]):
		return board[0][0]
	if board[0][1] && (board[0][1] == board[1][1] && board[1][1] == board[2][1]):
		return board[0][1]
	if board[0][2] && (board[0][2] == board[1][2] && board[1][2] == board[2][2]):
		return board[0][2]
	return null
	
func winner_diag(board):
	if board[0][0] && (board[0][0] == board[1][1] && board[1][1] == board[2][2]):
		return board[0][0]
	if board[0][2] && (board[0][2] == board[1][1] && board[1][1] == board[2][0]):
		return board[0][2]
	return null

func winner(board):	
	var game_winner = winner_row(board)
	game_winner = game_winner if game_winner else winner_col(board)
	game_winner = game_winner if game_winner else winner_diag(board)
	return game_winner
	
func terminal(board):
	var has_winner = winner(board) != null
	var board_is_filled = filled(board) == 9
	#print("winner ",has_winner)
	#print("board_filled",board_is_filled)
	return has_winner || board_is_filled

func utility(board):
	var scores = {"X":1,"O":-1}
	var game_winner = winner(board)
	return scores[game_winner] if game_winner else 0

func max_value(board, alpha, beta,depth=DEPTH):
	if terminal(board) or depth == 0:
		return utility(board)
	var v = -INF
	for action in actions(board):
		v = max(v, min_value(result(board, action), alpha, beta, depth-1))
		if v >= beta:
			return v
		alpha = max(alpha, v)
	return v

func min_value(board, alpha, beta, depth=DEPTH):
	if terminal(board) or depth == 0:
		return utility(board)
	var v = INF
	for action in actions(board):
		v = min(v, max_value(result(board, action), alpha, beta,depth-1))
		if v <= alpha:
			return v
		beta = min(beta, v)
	return v
#func iterative_mini_max(board,apha,beta):
#	var frontier = []
	
func minimax(board):
	#print("inicio minimax")
	if terminal(board):
		print("FIN...")
		return null
	#print("comienzo minimax")
	var _player = player(board)
	print("AI Player ",_player)

	var min_or_max = funcref(self, "min_value" if _player == "X" else "max_value")
	var actions_board = []
	for act in actions(board):
		actions_board.append([act,result(board,act)])
	var _moves= []
	for act_b in actions_board:
		var act = act_b[0]
		var b = act_b[1]
		_moves.append([act,min_or_max.call_func(b, -INF, INF)])
	
	_moves.sort_custom(self,"sortMoves")
	var action = _moves[-1][0] if _player == "X" else _moves[0][0]
	print("MOVES ORDER", _moves)
	return action 

func sortMoves(item1,item2):
	return item1[1] < item2[1]
	
func _ready():
	print("AI READY")
	board_mapping = [
		[$"../player_cell0",$"../player_cell1",$"../player_cell2"],
		[$"../player_cell3",$"../player_cell4",$"../player_cell5"],
		[$"../player_cell6",$"../player_cell7",$"../player_cell8"]
	]
	var cells = get_tree().get_nodes_in_group("Cells")
	print("cells ",cells)
	for cell in cells:
		cell.connect("ai_turn",self,"_on_ai_turn")
	get_parent().connect("ai_turn",self,"_on_ai_turn")
	print("board mapping",board_mapping)

func _on_ai_turn():
	print("Signal received")
	yield(get_tree().create_timer(1.0), "timeout")
	if !game_over :
		print("EMPIEZO EL PROCESO")
		var action = minimax(global.board)
		if action :
			#global.board[action[0]][action[1]] = global.player #"X" if global.human_player == "O" else "O"
			print("ACCION ",action)
			var evt = InputEventMouseButton.new()
			evt.button_index = BUTTON_LEFT
			var cell = board_mapping[action[0]][action[1]]
			global.ai_playing = false
			cell.emit_signal("input_event",null, evt, null)
		else:
			game_over = true
