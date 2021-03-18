extends Node

onready var server_tree = SceneTree.new()

# Stores all the current player data
var player_info = {}

func _ready():
	server_tree.connect("network_peer_connected", self, "_player_connected")
	server_tree.connect("network_peer_disconnected", self, "_player_disconnected")


func _player_connected(id):
	print("player ",id," connected")

func _player_disconnected(id):
	print("player ",id," disconnected")
	pass

#Starts server using a different tree - Takes in a PORT and MAX PLAYERS
func start_server(port, max_players):
	server_tree.init()
	server_tree.get_root().set_update_mode(Viewport.UPDATE_DISABLED)
	print_tree_pretty()
	#This scene path has to be the same as client scene path!

	set_process(true)
	set_physics_process(true)

	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(port, max_players)
	server_tree.set_network_peer(peer)

	var rpc_handler = load("res://Networking_Framework/rpc_handler.gd").new()
	rpc_handler.set_name("rpc_handler")
	server_tree.root.add_child(rpc_handler)


func _process(delta):
	server_tree.idle(delta)
	  
func _physics_process(delta):
	server_tree.iteration(delta)	

func _exit_tree():
	server_tree.finish()
