package net;

import enums.OrderStatus;
import enums.OrderType;
import haxe.Json;
import nodejs.ws.WebSocket.WebSocketEventType;
import js.html.WebSocket;

class ServerProxy {

    private var _client: Client;
    private var _socket: WebSocket;
    private var _data: String = '';

    public function new() {
        _socket = new WebSocket(GameSettings.serverAddress);
        _socket.addEventListener(WebSocketEventType.Open, connectionHandler);
        _socket.addEventListener(WebSocketEventType.Message, messageHandler);
        _socket.addEventListener(WebSocketEventType.Error, serrorHandler);
    }

    private function messageHandler (data: Dynamic) {
        trace(data.data);
        _data += data.toString();
        if (_data.indexOf(GameSettings.ENDSTRING) > -1) {
            _data.split(GameSettings.ENDSTRING).join('');
            messageEndHandler();
        }
    }

    public function sendMessage( message:String ):Void {
        _socket.send(message);
    }

    private function messageEndHandler () {
        trace(_data);

        var order = Json.parse(_data);
        if (order.status == OrderStatus.FAILURE) {
            return;
        }

        switch (order.type) {
            case OrderType.IDENTITY:
                _client.setIdentity(order.identity);
            case OrderType.ACTION:

            default:
                trace("[ServerProxy] Unable to determine order type");
        }

        _data = "";
    }

    private function serrorHandler( evt:Dynamic ):Void {
        trace('[Socket server] Error');
    }

    public function connectionHandler ( socket:WebSocket ) {

    }

}
