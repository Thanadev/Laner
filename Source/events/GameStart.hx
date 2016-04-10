package events;

import openfl.events.Event;

class GameStart extends Event {

    @:isVar public var idRoom(get, null):Float;

    public function new (_idRoom: Float) {
        super("GameStart");
        idRoom = _idRoom;
    }

    function get_idRoom():Float {
        return idRoom;
    }
}
