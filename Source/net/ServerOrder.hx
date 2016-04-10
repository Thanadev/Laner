package net;

import enums.PlayerAction;
import enums.PlayerRequestStatus;

class ServerOrder {

    private var status: PlayerRequestStatus;
    private var playerId: Int;
    private var order: PlayerAction;

    public function new(_playerId: Int, _status: PlayerRequestStatus, _order: PlayerAction) {
        status = _status;
        order = _order;
        playerId = _playerId;
    }
}
