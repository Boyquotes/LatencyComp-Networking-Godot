extends Control

# Server Constants
# Later will be abstracted into a better location, for configuration during game
const SERVER_PORT = 5001
const MAX_PLAYERS = 4
var SERVER_IP = "127.0.0.1"


func _custom_CreatePeerAsServer():
    
    #Create a new peer + start the server on the defined port
    var peer = NetworkedMultiplayerENet.new()
    peer.create_server(SERVER_PORT, MAX_PLAYERS)
    get_tree().set_network_peer(peer)

    #Provide a Debug?