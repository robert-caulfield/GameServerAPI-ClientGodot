extends VBoxContainer
class_name ServerVboxContainer

signal server_selected(game_server : GameServerResponseDTO)

func select_entry(child_id):
	for child : ServerEntry in get_children():
		child.set_selected(child.get_index() == child_id)
	var child : ServerEntry = get_child(child_id)
	if child and child.game_server:
		server_selected.emit(child.game_server)
