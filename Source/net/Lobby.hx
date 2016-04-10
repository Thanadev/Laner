package net;

/**
*   Pattern singleton
*   Used to manipulate rooms
**/
import Int;
class Lobby {

    private static var instance: Lobby;
    private var rooms: Array<Room>;
    private var availablePlayers: Array<PlayerIdentity>;

    public static function getInstance () {
        if (instance == null) {
            instance = new Lobby();
        }

        return instance;
    }

    private function new() {
        rooms = new Array<Room>();
    }

    public function createRoom (id: Int, name: String) {
        rooms.push(new Room(id, name));
    }

    /**
    * @brief removes him from room and availablePlayers
    **/
    public function playerDisconnectHandler (player: PlayerIdentity) {
        for (room in rooms) {
            room.onPlayerLeaves(player.idPlayer);
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
    }

    public function playerJoinRoomHandler (idRoom: Int, idPlayer: Int) {
        for (room in rooms) {
            if (room.idRoom == idRoom) {
                room.onPlayerEnter(idPlayer);
            }
        }
    }
}
