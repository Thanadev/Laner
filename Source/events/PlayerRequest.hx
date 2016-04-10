package events;

import net.PlayerIdentity;
import openfl.events.Event;
import enums.PlayerAction;

class PlayerRequest extends Event {

    @:isVar public var player(get, null):PlayerIdentity;
    @:isVar public var action(get, null):PlayerAction;

    public function new(_player: PlayerIdentity, _action: PlayerAction) {
        super("PlayerRequest");
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
