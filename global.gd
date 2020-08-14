extends Node

var player = ""
var winner = ""
var human_player = ""
var ai_playing = false
var board = [
	[null, null, null],
	[null, null, null],
	[null, null, null]
]
func next_player():
	player = 'X' if player == 'O' else 'O'
func reset():
	player = ""
	winner = ""
	human_player = ""
	ai_playing = false
	board = [
		[null, null, null],
		[null, null, null],
		[null, null, null]
	]
