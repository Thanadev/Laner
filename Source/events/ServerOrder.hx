package events;

import openfl.events.Event;
import enums.PlayerAction;
import enums.PlayerRequestStatus;

class ServerOrder extends Event {

    @:isVar public var status(get, null):PlayerRequestStatus;
    @:isVar public var playerId(get, null):Float;
    @:isVar public var order(get, null):PlayerAction;

    public function new(_playerId: Float, _status: PlayerRequestStatus, _order: PlayerAction) {
        super("ServerOrder");
        status = _status;
        order = _order;
        playerId = _playerId;
    }

    function get_status():PlayerRequestStatus {
        return status;
    }

    function get_playerId():Float {
        return playerId;
    }

    function get_order():PlayerAction {
        return order;
    }


}
