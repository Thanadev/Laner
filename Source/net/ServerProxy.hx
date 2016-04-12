package net;

import nodejs.ws.WebSocket.WebSocketEventType;
import js.html.WebSocket;

class ServerProxy {

    private var _socket: WebSocket;
    private var _data: String = "";

    public function new() {
        _socket = new WebSocket(GameSettings.serverAddress);
        _socket.addEventListener(WebSocketEventType.Open, connectionHandler);
        _socket.addEventListener(WebSocketEventType.Message, messageHandler);
        _socket.addEventListener(WebSocketEventType.Error, serrorHandler);
    }

    private function messageHandler (data: Dynamic) {
        trace(data.data);
        _data += data.toString();
        if (_data.indexOf("#end#") > -1) {
            messageEndHandler();
        }
    }

    public function sendMessage( message:String ):Void {
        _socket.send(message);
    }

    private function messageEndHandler () {
        trace(_data);
        _data = "";
    }

    private function serrorHandler( evt:Dynamic ):Void {
        trace('[Socket server] Error');
    }

    public function connectionHandler ( socket:WebSocket ) {
        sendMessage("Hey ! Connected !");
    }

}
