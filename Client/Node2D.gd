extends Node2D
var IP
var register_ID
func _ready():
	$Button.connect("pressed",self,"_on_connect_button_pressed")
	$Button2.connect("pressed",self,"_on_disconnect_button_pressed")
	$Button3.connect("pressed",self,"_on_send_button_pressed")
	get_tree().connect("connected_to_server",self,"_on_connected_to_server")
	get_tree().connect("connection_failed",self,"_on_connection_failed")
	get_tree().connect("server_disconnected",self,"_on_server_disconnected")
	get_tree().multiplayer.connect("network_peer_packet", self, "_on_packet_recieved")
	pass
func _on_connect_button_pressed():
	IP=$LineEdit2.text
	register_ID=$LineEdit3.text
	var network=NetworkedMultiplayerENet.new()
	network.create_client(IP, 7576)
	get_tree().network_peer=network
	pass
func _on_disconnect_button_pressed():
	get_tree().network_peer=null
	$LineEdit3.editable=true
	$LineEdit2.editable=true
	$RichTextLabel.text=""
	$RichTextLabel.append_bbcode("[color=#A20019]You have disconnected![/color]")
func _on_send_button_pressed():
	var textToSend=$TextEdit.text
	get_tree().multiplayer.send_bytes(textToSend.to_ascii())
	$TextEdit.text=""
func _on_packet_recieved(id, packet):
	$RichTextLabel.append_bbcode(packet.get_string_from_ascii())
func _on_connected_to_server():
	$LineEdit3.editable=false
	$LineEdit2.editable=false
	$RichTextLabel.text=""
	var id = get_tree().multiplayer.get_network_unique_id()
	rpc_id(1,"register_user",id,register_ID)
func _on_connection_failed():
	$RichTextLabel.text=""
	$RichTextLabel.append_bbcode("[color=#A20019]Connection failed![/color]")
	$LineEdit3.editable=true
	$LineEdit2.editable=true
func _on_server_disconnected():
	$RichTextLabel.text=""
	$RichTextLabel.append_bbcode("[color=#A20019]Server disconnected![/color]")
	$LineEdit3.editable=true
	$LineEdit2.editable=true
func _input(event):
	if $TextEdit.has_focus():
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_ENTER:
				get_tree().set_input_as_handled()
				_on_send_button_pressed()
	else:
		pass
