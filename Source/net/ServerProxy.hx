package net;

import terrain.GameLevel;
import terrain.GameGrid;
import events.PlayerRequest;
import enums.OrderStatus;
import enums.MessageType;
import haxe.Json;
import nodejs.ws.WebSocket.WebSocketEventType;
import js.html.WebSocket;

class ServerProxy {

    private var _client: Client;
    private var _socket: WebSocket;
    private var _data: String = '';

    public function new(client: Client) {
        _client = client;
        _socket = new WebSocket(GameSettings.serverAddress);
        _socket.addEventListener(WebSocketEventType.Open, connectionHandler);
        _socket.addEventListener(WebSocketEventType.Message, messageHandler);
        _socket.addEventListener(WebSocketEventType.Error, serrorHandler);
    }

    private function messageHandler (data: Dynamic) {
        _data += data.data;
        if (_data.length > 0 && _data.indexOf(GameSettings.ENDSTRING) > -1) {
            _data = _data.split(GameSettings.ENDSTRING).join('');
            messageEndHandler();
        }
    }

    public function sendRequest( request:PlayerRequest ): Void {
        _socket.send(Json.stringify(request) + GameSettings.ENDSTRING);
    }

    private function messageEndHandler () {
        var order = Json.parse(_data);
        if (order.status == OrderStatus.FAILURE) {
            return;
        }

        switch (order.type) {
            case MessageType.IDENTITY:
                trace("Identity received");
                _client.setIdentity(new PlayerIdentity(order.identity.idPlayer, order.identity.playerName));
            case MessageType.ACTION:
            case MessageType.LOADMAP:
                trace("Received map to load !!");
                var gameGrid = new GameGrid([-1.0, -1.0]);
                var levels: Array<GameLevel> = new Array<GameLevel>();
                for (i in 0...GameSettings.mapNb) {
                    var tmp: GameLevel = new GameLevel(-1);
                    tmp.setLevel(order.grid.gameMaps[i].playerPos, order.grid.gameMaps[i].mapData);
                    levels.push(tmp);
                }
                gameGrid.setGrid(order.grid.playerIds, levels);
                _client.initGame(gameGrid);
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
