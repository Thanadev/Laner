package net;

/**
*   Pattern singleton
*   Used to manipulate rooms
**/
class Lobby {

    private static var instance: Lobby;
    private var players: Array<PlayerData>;
    private var server: Server;
    private var rooms: Array<Room>;
    private var roomTable: Map<String, Room>;

    public static function getInstance ():Lobby {
        if (instance == null) {
            instance = new Lobby();
        }

        return instance;
    }

    private function new() {
        rooms = new Array<Room>();
        players = new Array<PlayerData>();
        roomTable = new Map<String, Room>();
    }

    public function setServer(server: Server) {
        this.server = server;
    }

    public function findPlayer (idPlayer: Float): Room {
        return roomTable.get("" + idPlayer);
    }

    public function createRoom (id: Float, name: String): Room {
        var room: Room = new Room(id, name, server);
        rooms.push(room);
        return room;
    }

    /**
    * @brief removes him from room and availablePlayers
    **/
    public function playerDisconnectHandler (player: PlayerData) {
        for (room in rooms) {
            room.onPlayerLeaves(player.identity.idPlayer);
            roomTable.remove("" + player.identity.idPlayer);
        }

        players.remove(player);
    }

    /**
    *   @brief called when player connects on lobby
    **/
    public function playerConnectHandler (player: PlayerIdentity) {
        var room: Room = null;

        for (checkedRoom in rooms) {
            if (checkedRoom.playerNb < GameSettings.playerNbToStart) {
                room = checkedRoom;
                break;
            }
        }

        if (room == null || rooms.length == 0) {
            room = createRoom(Date.now().getTime(), "DefaultRoomName");
    }


        playerJoinRoomHandler(room, player.idPlayer);
    }

    public function playerJoinRoomHandler (room: Room, idPlayer: Float) {
        room.onPlayerEnter(idPlayer);
        roomTable.arrayWrite("" + idPlayer, room);
    }

    public function gameFinishedHandler (room: Room) {
        var room2: Room = createRoom(Date.now().getTime(), "DefaultRoomName");

        for (playerId in room.players) {
            roomTable.remove("" + playerId);
            playerJoinRoomHandler(room2, playerId);
        }

        rooms.remove(room);

    }

    public function calcAvailablePlayers (): Int {
        var takenPlayers = 0;
        for (room in rooms) {
            takenPlayers += room.playerNb;
        }

        return players.length - takenPlayers;
    }

    public function getPlayers(): Array<PlayerData> {
        return players;
    }

    public function addPlayer(player: PlayerData): Lobby {
        this.players.push(player);
        playerConnectHandler(player.identity);

        return this;
    }

}
