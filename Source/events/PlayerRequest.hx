package events;

import net.PlayerIdentity;
import enums.PlayerAction;

class PlayerRequest extends Request {

    @:isVar public var player(get, null):PlayerIdentity;
    @:isVar public var action(get, null):PlayerAction;

    public function new(_player: PlayerIdentity, _action: PlayerAction) {
        player = _player;
        action = _action;
    }

    function get_player():PlayerIdentity {
        return player;
    }

    function get_action():PlayerAction {
        return action;
    }
}
