extends Control
class_name ServerBrowser
@onready var ServerBrowserAPIClient : APIClient = $ServerBrowserApiClient
@onready var PlayerTokenApiClient : APIClient = $PlayerTokenApiClient

@onready var serverContainer = $ScrollContainer/ServerVBoxContainer
@onready var join_server_button = $JoinServerButton
@onready var refresh_button = $RefreshButton

signal join_server(game_server : GameServerResponseDTO, join_token : String)

var server_entry_scene = preload("res://Scenes/UI_Components/ServerBrowser/ServerEntry.tscn")

var game_servers : Array[GameServerResponseDTO]
var game_server : GameServerResponseDTO

func _ready():
	ServerBrowserAPIClient.response_complete.connect(_on_request_servers_complete)
	PlayerTokenApiClient.response_complete.connect(_on_request_token_complete)
	fetch_servers()

# Calls ServerBrowserController GET
func fetch_servers():
	refresh_button.disabled = true
	game_servers.clear()
	ServerBrowserAPIClient.api_request("server-browser", HTTPClient.METHOD_GET, {})

# Reponse from ServerBrowserController GET
func _on_request_servers_complete(response : APIResponse):
	game_servers.clear()
	if response.isSuccess:
		for item in response.result:
			var gameServer : GameServerResponseDTO = APIHelper.json_to_class(item, GameServerResponseDTO.new())
			if gameServer:
				game_servers.append(gameServer)
	else:
		APIHelper.print_errors(response, "Unable to get server from API")
	refresh_button.disabled = false
	if !game_servers.is_empty():
		populate_server_vbox()
		pass

# Clear all entries, and repopulate them with current data
func populate_server_vbox():
	_on_server_v_box_container_server_selected(null)
	for child in serverContainer.get_children():
		child.queue_free()
		
	for game_server : GameServerResponseDTO in game_servers:
		var entry = server_entry_scene.instantiate()
		entry.game_server = game_server
		serverContainer.add_child(entry)
	

func _on_server_v_box_container_server_selected(game_server):
	join_server_button.disabled = game_server == null
	self.game_server = game_server

# Return player join token
func _on_request_token_complete(response : APIResponse):
	if response.isSuccess:
		var payload = APIHelper.get_payload(response.result)
		if (game_server.id == payload["serverid"]):
			join_server.emit(game_server,response.result)
	else:
		APIHelper.print_errors(response, "Unable to generate player join token.")
		join_server_button.disabled = false

# Calls GenerateToken api endpoint to retrieve join token
func _on_join_server_button_pressed():
	if game_server:
		PlayerTokenApiClient.api_request("player-tokens/generate-token", HTTPClient.METHOD_POST, {"serverID" : game_server.id})
		join_server_button.disabled = true

func _on_refresh_button_pressed():
	fetch_servers()
