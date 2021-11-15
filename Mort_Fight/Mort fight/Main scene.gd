extends Node2D
var Tauren=preload("res://Tauren.tscn")
var playercount=0
var SERVER_PORT=7576
var MAX_PLAYERS=2
var mplayer
var splayer
var id
func add_main_player():
	var player1 = Tauren.instance()
	self.add_child(player1)
	player1.set_player()
	player1.set_team("team1")
	return player1
func add_player(position):
	playercount+=1
	var player2 = Tauren.instance()
	self.add_child(player2)
	player2.set_team("team2")
	player2.position=position
	return player2
func _ready():
	mplayer=add_main_player()
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	pass
func _player_connected(id):
	print("player"+str(id)+" connected to server")
	rpc_id(id, "add_remote_player", mplayer.position)
	self.id=id
func _player_disconnected(id):
	print("player"+str(id)+" disconnected to server")
func _process(_delta):
	if mplayer.is_player==0:
		return
	if id==null:
		return
	if Input.is_key_pressed(KEY_A):
		mplayer.emit_signal("walk_left")
		rpc_id(id,"walk_left")
	if Input.is_key_pressed(KEY_D):
		mplayer.emit_signal("walk_right")
		rpc_id(id,"walk_right")
	if Input.is_key_pressed(KEY_J):
		mplayer.emit_signal("chop_down")
		rpc_id(id,"chop_down")
	if Input.is_key_pressed(KEY_K):
		mplayer.emit_signal("stab")
		rpc_id(id,"stab")
	if Input.is_key_pressed(KEY_L):
		mplayer.emit_signal("slash_around")
		rpc_id(id,"slash_around")
remote func add_remote_player(pos):
	splayer = add_player(pos)
remote func walk_left():
	splayer.emit_signal("walk_left")
remote func walk_right():
	splayer.emit_signal("walk_right")
remote func chop_down():
	splayer.emit_signal("chop_down")
remote func stab():
	splayer.emit_signal("stab")
remote func slash_around():
	splayer.emit_signal("slash_around")
