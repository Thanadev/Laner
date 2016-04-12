package socket;

import nodejs.ws.WebSocket;
import nodejs.ws.WebSocketServer;

class WSocketServer {

    private var _server:WebSocketServer;

    public function new( ) {
        var opt:WebSocketServerOption = cast {
            port : GameSettings.WEB_SOCKET_PORT
        };
        _server = new WebSocketServer(opt);
        _server.on(WebSocketServerEventType.Error, errorHandler);
        _server.on(WebSocketServerEventType.Connection, connectionHandler);
    }

    private function errorHandler( evt:Dynamic ):Void {
        trace('[Socket server] Error');
        trace(evt);
    }

    private function connectionHandler( socket:WebSocket ):Void {
        trace('[Socket server] : New Connection');
        trace(socket);
    }
}