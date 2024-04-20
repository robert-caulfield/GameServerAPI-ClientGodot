extends Node

# Emitted when a multiplayer session ends,
# or could not be established
signal session_ended(reason : String)

var desired_game_server : GameServerResponseDTO

var join_token : String

@export var players = {}

func _ready():
	if desired_game_server: # Check if desired_game_server is populated, attempt to join
		join_server()
	else:
		_on_connection_fail("No server info provided")
		return
	
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connection_fail.bind("Connection failed"))
	multiplayer.server_disconnected.connect(_on_connection_fail.bind("Server disconnected"))
	

# Create multiplayer
func join_server():
	# Attempt to create connection
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(desired_game_server.ipAddress, desired_game_server.port)
	if error:
		_on_connection_fail("Error creating client")
		return
	multiplayer.multiplayer_peer = peer

# On successful connection, send PlayerJoinToken to game server
func _on_connected_ok():
	rpc_id(1, "_send_auth_token", join_token)

# Failed to connect to gameserver
func _on_connection_fail(reason: String):
	multiplayer.multiplayer_peer = null
	session_ended.emit(reason)
	queue_free()

#server rpc methods

#RPC method for server to recieve player join tokens
@rpc("any_peer", "reliable", "call_remote")
func _send_auth_token(token : String):
	pass
