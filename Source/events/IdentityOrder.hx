package events;

import net.PlayerIdentity;
import enums.OrderStatus;

class IdentityOrder extends ServerOrder{

    private var identity;

    public function new(_status: OrderStatus, _playerIdentity: PlayerIdentity) {
        status = _status;
        identity = _playerIdentity;
    }
}
