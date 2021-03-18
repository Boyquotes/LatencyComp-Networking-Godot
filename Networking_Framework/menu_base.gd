extends Control

# Server Constants
# Later will be abstracted into a better location, for configuration during game
const SERVER_PORT = 5001
const MAX_PLAYERS = 4
var SERVER_IP = "127.0.0.1"

onready var rpc_handler_c = null
var c_info = "Jesus"



# In order to have both a combination of Server and Client on one machine, 
# there should be second SCENE TREE -> Server tree initialized
# This will be the server function for EVERYONE, who will be connecting (including oneself)
# Issue -> How will the physics work? This server is just going to be client prediction + lag conciliation
# -> Attacks? Do we just use the main client as the baller?
# https://godotengine.org/qa/89743/how-use-two-scenetrees-run-both-server-and-client-one-project


func _ready():
	#get_tree().connect("network_peer_connected", self, "_player_connected")
	#get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")
	#get_tree().connect("server_disconnected", self, "_server_disconnected")
	set_process(false)
	set_physics_process(false)


func _connected_to_server():
	print("call rpc")
	
	rpc_handler_c.call_reg_pl(c_info)
	#rpc_id(1,"start_demo")

func _connection_failed():
	print("_connection_failed")
	#rpc_id(1,"start_demo")

#Create a new peer and start the SERVER on the defined SERVER_PORT with MAX_PLAYERS
func _CreatePeerAsServer():
	ServerBase.start_server(SERVER_PORT, MAX_PLAYERS)


#Create a new peer and start the CLIENT on the defined SERVER_PORT with MAX_PLAYERS
func _CreatePeerAsClient():
	#PROTOTYPICAL CODE
	c_info = get_node("CenterContainer/GridContainer/LineEdit").text
	#END PROTOTYPICAL CODE - AS IF LOL

	var peerC = NetworkedMultiplayerENet.new()
	peerC.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peerC)

	#Add RPC HANDLER as child of root
	var rpc_handler = load("res://Networking_Framework/rpc_handler.gd").new()
	rpc_handler.set_name("rpc_handler")
	get_node("/root").add_child(rpc_handler)
	rpc_handler_c = get_node("/root/rpc_handler")

	print("Created Client")
