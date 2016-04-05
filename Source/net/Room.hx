package net;


class Room {

    @:isVar public var idRoom(get, null):Int;
    @:isVar public var nameRoom(get, null):String;
    @:isVar public var playerNb(get, null):Int;
    @:isVar public var players(get, null):Array<Int>;

    public function new(id: Int, name: String) {
        idRoom = id;
        name = nameRoom;
        playerNb = 0;
        players = [0,0];
    }

    public function onPlayerEnter (playerId: Int) {
        if (players.indexOf(playerId) == -1 && playerNb < 2) {
            players[playerNb] = playerId;
            playerNb++;

            if (playerNb == 2) {
                onReadyToLaunch();
            }
        }
    }

    public function onPlayerLeaves (playerId: Int) {
        if (players.remove(playerId)) {
            if (players.length > 0) {
                // TODO on player wins
            }
        }
    }

    public function onReadyToLaunch () {
        // TODO Start a game giving the ids of the two players
    }

    function get_idRoom():Int {
        return idRoom;
    }

    function get_nameRoom():String {
        return nameRoom;
    }

    function get_playerNb():Int {
        return playerNb;
    }

    function get_players():Array<Int> {
        return players;
    }


}
