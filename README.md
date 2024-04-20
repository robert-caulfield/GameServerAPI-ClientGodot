# GameServerAPI-ClientGodot

 This Godot game client consumes the [GameServerAPI](https://github.com/robert-caulfield/GameServerAPI) to provide a multiplayer gaming environment. Designed for seamless integration with the API, it features a user interface that allows players to authenticate, discover game servers, and securely authenticate themselves to them.

 A Game Server implementation in Godot can be found [here](https://github.com/robert-caulfield/GameServerAPI-ServerGodot).
 
## Key Features

### User Authentication
- **Login/Registration Interface**: Players are able to interact with the APIs Auth Controller through a login user interface.
<p align="center">
  <img src="https://github.com/robert-caulfield/GameServerAPI-ClientGodot/assets/113054389/efcdf0b6-7d2a-4a65-ba26-214922470ee7" />
</p>

- **JWT Authorization**: Upon successful sign in, player’s are provided a JWT which is used to authorize future requests.

### Game Server Discovery:
- **Server Retrieval**: Communicates with the API’s Server Browser Controller to fetch the list of active game servers.
- **Server Browser Interface**: Displays available game servers in server browser interface, allowing player to select and join a game.
<p align="center">
  <img src="https://github.com/robert-caulfield/GameServerAPI-ClientGodot/assets/113054389/a1fe95e7-e116-480a-9d8e-340e575111b2" width="500" height="auto" />
</p>

### Secure Connection to Game Servers
- **PlayerJoinToken Acquisition**:  Requests a PlayerJoinToken from the API’s Player Token Controller before attempting to join a game server.

- **Token Handoff**: Upon successful connection to a game server, the client provides the PlayerJoinToken, which the server then validates with the API to authenticate the player and fetch relevant player information.

- **Game Server Interaction**: This project provides a simple environment where players are labeled with their username and are able to move around using WASD keys.

## Installation Guide
<details>
<summary><strong>Installation Guide</strong></summary>
<p>
 
1. **Download the Source Code**
   - Visit the GitHub repository at `https://github.com/robert-caulfield/GameServerAPI-ClientGodot`.
   - Click on `Code` and select `Download ZIP`, or clone the repository using:
     ```
     git clone [https://github.com/robert-caulfield/GameServerAPI-ClientGodot]
     ```

2. **Open the Project in Godot**
   - Open the Godot Engine.
   - Select `Import Project` from the Godot Project Manager.
   - Navigate to the downloaded directory and select the `project.godot` file.
   - Click `Import & Edit` to open the project.

3. **Configure the API Endpoint**
   - Navigate to the `api_helper.gd` script in the Godot Editor.
   - Locate the `API_URL` variable and set it to the correct endpoint URL for your GameServerAPI:
     ```gdscript
     # Base url to api
     const API_URL = "https://localhost:7242/api/"
     ```
   - Save the script.

4. **Run the Project**
   - Ensure the API is running, and run the project.


</p>
</details>

## Technologies Used
- Godot v4.21

