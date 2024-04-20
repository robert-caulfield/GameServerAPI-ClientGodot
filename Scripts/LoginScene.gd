extends Node2D

@onready var successLabel = $Login/VBoxContainer/SuccessLabel
@onready var usernameEdit = $Login/VBoxContainer/UsernameEdit
@onready var emailEdit = $Login/VBoxContainer/EmailEdit
@onready var passwordEdit = $Login/VBoxContainer/PasswordEdit
@onready var authRequestButton = $Login/VBoxContainer/AuthRequestButton
@onready var errorLabel = $Login/VBoxContainer/ErrorLabel
@onready var switchOperationButton = $Login/SwitchOperation


@onready var logInClient : APIClient = $LogInAPIClient
@onready var registerClient : APIClient = $RegisterAPIClient

signal signed_in()


var is_registering := false

func _ready():
	# Connect login api request completed
	logInClient.response_complete.connect(_on_login_request_completed)
	registerClient.response_complete.connect(_on_register_request_completed)

# Toggles ui elements based on is_registering
func operation_changed():
	successLabel.text = ""
	errorLabel.text = ""
	if not is_registering: # Toggle ui elements to sign in mode
		emailEdit.visible = false
		authRequestButton.text = "Sign In"
		switchOperationButton.text = "New user"
	else: # Toggle ui elements to register mode
		emailEdit.visible = true 
		authRequestButton.text = "Register"
		switchOperationButton.text = "Back to Sign In"
	

# Register request complete
func _on_register_request_completed(response : APIResponse):
	# Allow sending another request by re-enabling button
	authRequestButton.disabled = false
	
	if response.isSuccess: # Register request successful
		# Return to sign in
		is_registering = false
		operation_changed()
		# Set success label
		successLabel.text = "Account Created!"
		return
	if !response.errors.is_empty(): # Register request fail, populate error label
		errorLabel.text = APIHelper.get_errors_to_string(response, "Unable to register new user.")

# LogIn request complete
func _on_login_request_completed(response : APIResponse):
	if response.isSuccess: # Successful login
		# Emit successful login signal, set api auth token
		APIHelper.auth_token = response.result["token"]
		signed_in.emit()
		self.visible = false
		return
	# Unsuccessful login, populate error label
	if !response.errors.is_empty() and !response.errors.is_empty():
		errorLabel.text = APIHelper.get_errors_to_string(response, "Unable to sign in.")
	# Allow sending another request by re-enabling button
	authRequestButton.disabled = false


# Auth request button pressed
func _on_auth_button_pressed():
	# Disable button until request is completed
	authRequestButton.disabled = true
	# Clear error and success label text
	errorLabel.text = ""
	successLabel.text = ""
	
	if !is_registering: # Sign in
		# Initialize request dto data
		var loginRequestDTO = LoginRequestDTO.new()
		loginRequestDTO.Username = usernameEdit.text
		loginRequestDTO.Password = passwordEdit.text
		
		# Send login post request to api
		logInClient.api_request("auth/login", HTTPClient.METHOD_POST, loginRequestDTO.get_dict())
	else: # Register
		# Create and populate register dto
		var registerRequestDTO = RegisterRequestDTO.new()
		registerRequestDTO.Username = usernameEdit.text
		registerRequestDTO.Password = passwordEdit.text
		registerRequestDTO.Email = emailEdit.text
		
		# Send register post request to api
		registerClient.api_request("auth/register", HTTPClient.METHOD_POST, registerRequestDTO.get_dict())
		

# Connected to SwitchOperation button pressed
func _on_switch_operation_pressed():
	is_registering =! is_registering
	operation_changed()
