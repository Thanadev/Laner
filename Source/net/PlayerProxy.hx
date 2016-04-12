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
    }


    public function sendMessage( message:String ):Void {
        try {
            _socket.send(message + GameSettings.ENDSTRING);
        } catch ( e: js.Error ) {
            trace('ERROR : ' + e.message);
        }
    }

    private function sendIdentity(playerIdentity:PlayerIdentity): Void {
        var identityOrder = new IdentityOrder(OrderStatus.SUCCESS, playerIdentity);
        trace('New Connection: ' + Json.stringify(identityOrder));

        sendMessage(Json.stringify(identityOrder));
    }

    private function messageHandler( data:String ):Void {
        _data += data.toString();

        if ( _data.indexOf(GameSettings.ENDSTRING) > -1 ) {
            _data = _data.split(GameSettings.ENDSTRING).join('');

            if ( _data.length > 0 ) {
                endHandler();
            } else {
                trace('Empty data: ' + data);
            }
        }
    }

    private function endHandler():Void {
        var message:Dynamic = null;

        try {
            message = Json.parse(_data);
            _data = '';
        } catch ( e:js.Error ) {
            trace('JSON parse failed: ' + e.message);
        }

        if ( message != null && message.type != null) {
            trace('Message received: ' + message);
            handleMessage(message);
        } else {
            trace('Data corrupted');
        }
    }

    private function handleMessage(message):Void {
        switch (message.type) {
            case MessageType.PLAYER:
                var playerRequest:PlayerRequest = cast message;
                Lobby.getInstance().findPlayer(_id).onPlayerRequest(playerRequest);

            default:
                trace('Data corrupted: invalid type');
        }
    }
}
