package net;


class PlayerIdentity {

    public var idPlayer(get, null):Float;
    public var namePlayer(get, null):String;

    public function new(id: Float, name: String) {
        idPlayer = id;
        namePlayer = name;
    }

    function get_idPlayer():Float {
        return idPlayer;
    }

    function get_namePlayer():String {
        return namePlayer;
    }
}
