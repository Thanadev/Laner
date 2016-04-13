package socket;

import net.Lobby;
import net.PlayerData;
import net.PlayerIdentity;
import net.PlayerProxy;
import nodejs.ws.WebSocket;
import nodejs.ws.WebSocketServer;

class WSocketServer {

    private var _server:WebSocketServer;
    private var _connections:Array<PlayerData>;

    public function new() {
        _connections = new Array<PlayerData>();

        var opt:WebSocketServerOption = cast {
            port : GameSettings.WEB_SOCKET_PORT
        };
        _server = new WebSocketServer(opt);
        _server.on(WebSocketServerEventType.Error, errorHandler);
        _server.on(WebSocketServerEventType.Connection, connectionHandler);
    }

    private function errorHandler( evt:Dynamic ):Void {
        trace('Socket server error');
    }

    private function connectionHandler( ws:WebSocket ):Void {
        var playerIdentity = new PlayerIdentity(Date.now().getTime(), "Guest");
        var playerProxy = new PlayerProxy(ws, playerIdentity);
        var playerData = new PlayerData(playerIdentity, playerProxy);

        Lobby.getInstance().addPlayer(playerData);

        _connections.push(playerData);
    }
}