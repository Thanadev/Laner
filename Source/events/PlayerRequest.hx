package events;

import enums.MessageType;
import net.PlayerIdentity;
import enums.PlayerAction;

class PlayerRequest extends Request {

    public var player:PlayerIdentity;
    public var action:PlayerAction;

    public function new(_player: PlayerIdentity, _action: PlayerAction) {
        type = MessageType.PLAYER;
        player = _player;
        action = _action;
    }
}
