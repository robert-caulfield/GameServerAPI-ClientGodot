# Helper class for making API requests
# and accessing/formatting the data obtained from responses
extends Node

# Base url to api
const API_URL = "https://localhost:7242/api/"

# Auth JWT token recieved from sign in
var auth_token = ""

# Print errors for a given response
func print_errors(response : APIResponse, base_error : String = ""):
	if base_error != "":
			print(base_error)
	if response.errors and len(response.errors) > 0:
		for error in response.errors:
			print("\t" + error)

# Gets string of concatenated errors from APIResponse
func get_errors_to_string(response : APIResponse, base_error : String = "") -> String:
	if response.errors and len(response.errors) > 0:
		for error in response.errors:
			base_error += "\n" + error
	return base_error

# Used for api calls, return authentication header if auth_token populated
func get_headers() -> Array[String]:
	var headers : Array[String] = ["Content-Type: application/json"]
	if auth_token != "":
		headers.append("Authorization: Bearer " + str(auth_token))
	return headers

# Provided by fenix-hub
# https://gist.github.com/fenix-hub/afeed0151f278e2b7c349be11f722765
# Converts dictionary to object
static func json_to_class(json: Dictionary, _class: Object) -> Object:
	var properties: Array = _class.get_property_list()
	for key in json.keys():
		for property in properties:
			if property.name == key and property.usage >= 4096:
				if String(property["class_name"]).is_empty():
					_class.set(key, json[key])
				elif property["class_name"] in ["RefCounted", "Object"]:
					_class.set(key, json_to_class(json[key], _class.get(key)))
				break
	return _class

# Gets JWT payload and returns it as a dictionary
func get_payload(token: String) -> Dictionary:
	var parts = token.split(".")
	if parts.size()!=3:
		print("Not valid JWT format")
		return {}
	var payload = parts[1]
	# Add padding
	while payload.length() % 4 != 0:
		payload += "="
	
	var json_str = Marshalls.base64_to_utf8(payload)
	var json_payload = JSON.parse_string(json_str)
	return json_payload
