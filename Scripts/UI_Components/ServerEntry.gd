extends PanelContainer
class_name ServerEntry

@onready var name_label : Label = $HBoxContainer/NameLabel
@onready var players_label : Label = $HBoxContainer/PlayersLabel
@onready var server_vbox_container : ServerVboxContainer = get_parent()

var style_box_selected : StyleBox = load("res://Scenes/UI_Themes/server_entry_selected.tres")
var style_box_unselected : StyleBox = load("res://Scenes/UI_Themes/server_entry_unselected.tres")
var game_server : GameServerResponseDTO

func _ready():
	populate_data()

# Populate data inside entry based on game_server
func populate_data():
	name_label.text = game_server.name
	if game_server.playerCount != -1:
		players_label.text = str(game_server.playerCount) + "/" + str(game_server.maxPlayers) + " players"
	else:
		players_label.text = "N/A"

# On click on entry
func _on_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			server_vbox_container.select_entry(get_index())

# Change style depending on if selected
func set_selected(selected : bool):
	add_theme_stylebox_override("panel", style_box_selected if selected else style_box_unselected)
	
