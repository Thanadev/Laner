package events;

import enums.OrderType;
import net.PlayerIdentity;
import enums.OrderStatus;

class IdentityOrder extends ServerOrder {

    public var identity;

    public function new(_status: OrderStatus, _playerIdentity: PlayerIdentity) {
        type = OrderType.IDENTITY;
        status = _status;
        identity = _playerIdentity;
    }
}
