package net;

/**
*   Pattern singleton
*   Used to manipulate rooms
**/
class Lobby {

    private static var instance: Lobby;
    private var server: Server;
    private var rooms: Array<Room>;
    private var availablePlayers: Array<PlayerIdentity>;
    private var roomTable: Map<String, Room>;

    public static function getInstance (_server: Server) {
        if (instance == null) {
            instance = new Lobby(_server);
        }

        return instance;
    }

    private function new(_server: Server) {
        rooms = new Array<Room>();
        availablePlayers = new Array<PlayerIdentity>();
        roomTable = new Map<String, Room>();
        server = _server;
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
    public function playerDisconnectHandler (player: PlayerIdentity) {
        for (room in rooms) {
            room.onPlayerLeaves(player.idPlayer);
            roomTable.remove("" + player.idPlayer);
        }

        availablePlayers.remove(player);
    }

    /**
    *   @brief called when player connects on lobby
    **/
    public function playerConnectHandler (player: PlayerIdentity) {
        if (availablePlayers.indexOf(player) == -1) {
            availablePlayers.push(player);
        }

        var room: Room = createRoom(Date.now().getTime(), "DefaultRoomName");
        playerJoinRoomHandler(room, player.idPlayer);
    }

    public function playerJoinRoomHandler (room: Room, idPlayer: Float) {
        room.onPlayerEnter(idPlayer);
        roomTable.arrayWrite("" + idPlayer, room);
    }
}
