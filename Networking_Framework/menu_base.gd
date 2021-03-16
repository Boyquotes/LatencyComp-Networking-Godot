extends Control

# Server Constants
# Later will be abstracted into a better location, for configuration during game
const SERVER_PORT = 5001
const MAX_PLAYERS = 4
var SERVER_IP = "127.0.0.1"

# In order to have both a combination of Server and Client on one machine, 
# there should be second SCENE TREE -> Server tree initialized
# This will be the server function for EVERYONE, who will be connecting (including oneself)
# Issue -> How will the physics work? This server is just going to be client prediction + lag conciliation
# -> Attacks? Do we just use the main client as the baller?
# https://godotengine.org/qa/89743/how-use-two-scenetrees-run-both-server-and-client-one-project


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	#get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	#get_tree().connect("connection_failed", self, "_connection_failed")
	#get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(id):
    print("player ",id," connected")

func _connected_to_server():
	print("_connected_to_server")
	#rpc_id(1,"start_demo")
	   
#Create a new peer and start the SERVER on the defined SERVER_PORT with MAX_PLAYERS
func _CreatePeerAsServer():
    # Maybe pass in a tree, this will help with later?
    var peer = NetworkedMultiplayerENet.new()
    peer.create_server(SERVER_PORT, MAX_PLAYERS)
    get_tree().set_network_peer(peer)
    print("Created Server")
    #Provide a Debug?

#Create a new peer and start the CLIENT on the defined SERVER_PORT with MAX_PLAYERS
func _CreatePeerAsClient():
    var peer = NetworkedMultiplayerENet.new()
    peer.create_client(SERVER_IP, SERVER_PORT)
    get_tree().set_network_peer(peer)
    print("Created Client")

