extends Node2D
var IP
var User_inform = {}
func _ready():
	IP="192.168.1.2"
	var network = NetworkedMultiplayerENet.new()
	network.create_server(7576, 10)
	get_tree().network_peer=network
	network.connect("peer_connected",self,"_on_peer_connected")
	network.connect("peer_disconnected",self,"_on_peer_disconnected")
	get_tree().multiplayer.connect("network_peer_packet", self, "_on_packet_recieved")
func _on_peer_connected(id):
	$RichTextLabel.append_bbcode("\nUser "+str(id)+" [color=#00B200]connected[/color]")
	get_tree().multiplayer.send_bytes(("[color=#00DDDD]Host server[/color] "+IP+": "+"["+str(id)+"] "+"[color=#DD9900]Welcome to this server![/color]").to_ascii())
func _on_peer_disconnected(id):
	$RichTextLabel.append_bbcode("\nUser "+str(id)+" [color=#A20019]disconnected[/color]")
	User_inform.erase(id)
	_update_itemList()
func _on_packet_recieved(id, packet):
	var Messages = get_child(1)
	var recieved_str="[color=#00B200]\nUser[/color] [color=#FFFF10]"+User_inform[id]+"[/color] ["+str(id)+"]: "+packet.get_string_from_ascii()
	Messages.append_bbcode(recieved_str)
	get_tree().multiplayer.send_bytes((recieved_str).to_ascii())
remote func register_user(id, inform):
	User_inform[id]=inform
	print(str(id)+": "+inform)
	_update_itemList()
func _update_itemList():
	$ItemList.clear()
	for key in User_inform.keys():
		$ItemList.add_item(User_inform[key]+" ["+str(key)+"]")
func fix_shader_scaling():
	$ColorRect.material.set_shader_param("scalingx",scale.x)
	$ColorRect.material.set_shader_param("scalingy",scale.y)
