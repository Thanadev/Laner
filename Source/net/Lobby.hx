package net;

/**
*   Pattern singleton
*   Used to manipulate rooms
**/
class Lobby {

    private static var instance: Lobby;
    private var players: Array<PlayerIdentity>;
    private var server: Server;
    private var rooms: Array<Room>;
    private var roomTable: Map<String, Room>;

    public static function getInstance (_server: Server) {
        if (instance == null) {
            instance = new Lobby(_server);
        }

        return instance;
    }

    private function new(_server: Server) {
        rooms = new Array<Room>();
        players = new Array<PlayerIdentity>();
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

        players.remove(player);
    }

    /**
    *   @brief called when player connects on lobby
    **/
    public function playerConnectHandler (player: PlayerIdentity) {
        if (players.indexOf(player) == -1) {
            players.push(player);
        }

        var room: Room = createRoom(Date.now().getTime(), "DefaultRoomName");
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

    public function getPlayers(): Array<PlayerIdentity> {
        return players;
    }

    public function addPlayer(player: PlayerIdentity): Lobby {
        this.players.push(player);

        return this;
    }

}
