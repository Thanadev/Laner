package net;
class PlayerEntity {

    @:isVar public var idPlayer(get, null):Int;
    @:isVar public var namePlayer(get, null):String;

    public function new(id: Int, name: String) {
        idPlayer = id;
        namePlayer = name;
    }

    function get_idPlayer():Int {
        return idPlayer;
    }

    function get_namePlayer():String {
        return namePlayer;
    }

}
