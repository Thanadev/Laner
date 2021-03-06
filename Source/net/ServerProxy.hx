package net;

import enums.PlayerAction;
import events.ActionOrder;
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
        if (order.status[0] == OrderStatus.FAILURE) {
            trace('Order failed!');
            _data = "";
            return;
        }

        switch (order.type) {
            case MessageType.IDENTITY:
                trace("Identity received, waiting for more players");
                _client.setIdentity(new PlayerIdentity(order.identity.idPlayer, order.identity.playerName));
            case MessageType.ACTION:
                var status = order.status;
                var tmp = order.order[1];
                var orderO: PlayerAction = PlayerAction.MOVE_BOTTOM;
                if (tmp == 0) {
                    orderO = PlayerAction.MOVE_TOP;
                } else if (tmp == 1) {
                    orderO = PlayerAction.MOVE_BOTTOM;
                } else if (tmp == 2) {
                    orderO = PlayerAction.MOVE_LEFT;
                } else if (tmp == 3) {
                    orderO = PlayerAction.MOVE_RIGHT;
                }

                var actionOrder = new ActionOrder(order.playerId, OrderStatus.SUCCESS, orderO);
                _client.serverOrderHandler(actionOrder);
            case MessageType.LOADMAP:
                trace('Received map to load!');
                //var position = order.positionNumber;
                var gameGrid = new GameGrid([-1.0, -1.0]);
                var levels: Array<GameLevel> = new Array<GameLevel>();
                for (i in 0...GameSettings.mapNb) {
                    var tmp: GameLevel = new GameLevel(-1);
                    tmp.setLevel(order.grid.gameMaps[i].playerPos, order.grid.gameMaps[i].mapData);
                    levels.push(tmp);
                }
                gameGrid.setGrid(order.grid.playerIds, levels);
                _client.initGame(gameGrid);
            case MessageType.LOADLEVEL:
                trace(order.message);
                _client.onWon(order.level);
            case MessageType.ENDGAME:
                trace('Game ended!');
                _client.onGameEnded(order.message);
            default:
                trace('Unable to determine order type');
        }

        _data = "";
    }

    private function serrorHandler( evt:Dynamic ):Void {
        trace('Socket server Error');
    }

    public function connectionHandler ( socket:WebSocket ) {

    }

}
