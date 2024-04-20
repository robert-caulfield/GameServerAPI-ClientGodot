class_name RegisterRequestDTO

var Username : String
var Password : String
var Email : String
func get_dict():
	var save_dict = {
		"Username" : Username,
		"Password" : Password,
		"Email" : Email
	}
	return save_dict
