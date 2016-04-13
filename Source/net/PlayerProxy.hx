package net;

import events.PlayerRequest;
import enums.MessageType;
import enums.OrderStatus;
import events.IdentityOrder;
import haxe.Json;
import nodejs.ws.WebSocket;

class PlayerProxy {

    private var _id: Float;
    private var _socket: WebSocket;
    private var _data: String;

    public function new( ws:WebSocket, identity:PlayerIdentity ) {
        _socket = ws;
        _data = '';
        _id = identity.idPlayer;

        sendIdentity(identity);

        _socket.on(WebSocketEventType.Message, messageHandler);
        _socket.on(WebSocketEventType.Close, closeHandler);
    }


    public function sendMessage( message:String ):Void {
        try {
            _socket.send(message + GameSettings.ENDSTRING);
        } catch ( e: js.Error ) {
            trace('Error while sending message to ' + _id + ': ' + e.message);
        }
    }

    private function sendIdentity(playerIdentity:PlayerIdentity): Void {
        var identityOrder = new IdentityOrder(OrderStatus.SUCCESS, playerIdentity);
        trace('New Connection: ' + playerIdentity.idPlayer);

        sendMessage(Json.stringify(identityOrder));
    }

    private function closeHandler () {
        Lobby.getInstance().findPlayer(_id).onPlayerLeaves(_id);
    }

    private function messageHandler( data:String ):Void {
        _data += data.toString();

        if ( _data.indexOf(GameSettings.ENDSTRING) > -1 ) {
            _data = _data.split(GameSettings.ENDSTRING).join('');

            if ( _data.length > 0 ) {
                endHandler();
            } else {
                trace('Received empty data from ' + _id + ': ' + data);
            }
        }
    }

    private function endHandler():Void {
        var message:Dynamic = null;

        try {
            message = Json.parse(_data);
            _data = '';
        } catch ( e:js.Error ) {
            trace('JSON parse failed for player ' + _id + ': ' + e.message);
        }

        if ( message != null && message.type != null) {
            handleMessage(message);
        } else {
            trace('Received corrupted data from ' + _id);
        }
    }

    private function handleMessage(message):Void {
        switch (message.type) {
            case MessageType.PLAYER:
                trace('Message received from ' + _id + ': ' + message.action[0]);
                var playerRequest:PlayerRequest = new PlayerRequest(message.player, cast message.action);
                playerRequest.type = message.type;

                Lobby.getInstance().findPlayer(_id).onPlayerRequest(playerRequest);

            default:
                trace('Received corrupted data from ' + _id + ': invalid type');
        }
    }
}
