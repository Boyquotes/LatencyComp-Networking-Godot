extends "res://Networking_Framework/Server/server_base.gd"


remote func register_player_server(info):
	# Get the id of the RPC sender.
	var id = server_tree.get_rpc_sender_id()
	# Store the info
	player_info[id] = info
	print("rpc call")
	print(player_info)

func call_reg_pl(c_info):
	rpc_id(1, "register_player_server", c_info)
