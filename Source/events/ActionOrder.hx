package events;

import enums.OrderType;
import enums.PlayerAction;
import enums.OrderStatus;

class ActionOrder extends ServerOrder {
    @:isVar public var playerId(get, null):Float;
    @:isVar public var order(get, null):PlayerAction;

    public function new(_playerId: Float, _status: OrderStatus, _order: PlayerAction) {
        type = OrderType.ACTION;
        status = _status;
        order = _order;
        playerId = _playerId;
    }

    function get_playerId():Float {
        return playerId;
    }

    function get_order():PlayerAction {
        return order;
    }


}
