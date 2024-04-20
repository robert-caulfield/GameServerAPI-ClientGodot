extends Node


var server_browser_scene = preload("res://Scenes/ServerBrowser.tscn")
var lobby_scene = preload("res://Scenes/Lobby.tscn")
var server_browser : ServerBrowser

var lobby = null

# Called when LoginScene.signed_in is emitted
func start_server_browser():
	server_browser = server_browser_scene.instantiate()
	# Connect join_server signal
	server_browser.join_server.connect(_join_game)
	add_child(server_browser)

# Called when a join game button is pressed in server browser
# And a join token was retrieved
func _join_game(game_server : GameServerResponseDTO, join_token : String):
	server_browser.hide()
	lobby = lobby_scene.instantiate()
	lobby.desired_game_server = game_server
	lobby.join_token = join_token
	lobby.session_ended.connect(_on_connect_fail)
	add_child(lobby)

# Connected to lobby.session_ended
func _on_connect_fail(error : String):
	lobby.session_ended.disconnect(_on_connect_fail)
	lobby.queue_free()
	
	print("Conneciton Failed:\n\t" + error)
	server_browser.show()
	server_browser.fetch_servers()
	
