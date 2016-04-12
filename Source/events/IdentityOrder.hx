package events;

import enums.MessageType;
import net.PlayerIdentity;
import enums.OrderStatus;

class IdentityOrder extends Order {

    public var identity: PlayerIdentity;

    public function new(_status: OrderStatus, _playerIdentity: PlayerIdentity) {
        type = MessageType.IDENTITY;
        status = _status;
        identity = _playerIdentity;
    }
}
