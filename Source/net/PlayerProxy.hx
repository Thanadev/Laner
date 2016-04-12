package net;

import nodejs.ws.WebSocket.WebSocketEventType;
import js.html.WebSocket;

class PlayerProxy {

    private var _socket: WebSocket;

    public function new() {
        _socket = new WebSocket(GameSettings.serverAddress);
        _socket.addEventListener(WebSocketEventType.Open, connectionHandler);
        _socket.addEventListener(WebSocketEventType.Error, serrorHandler);
    }

    private function serrorHandler( evt:Dynamic ):Void {
        trace('[Socket server] Error');
    }

    public function connectionHandler ( socket:WebSocket ) {
        trace("Hey !");
    }

}
