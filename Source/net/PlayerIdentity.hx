package net;


class PlayerIdentity {

    public var idPlayer(get, null):Float;
    public var playerName(get, null):String;

    public function new(id: Float, name: String) {
        idPlayer = id;
        playerName = name;
    }

    function get_idPlayer():Float {
        return idPlayer;
    }

    function get_playerName():String {
        return playerName;
    }
}
