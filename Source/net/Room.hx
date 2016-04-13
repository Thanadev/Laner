package net;

import enums.MessageType;
import events.EndOrder;
import events.LoadMapOrder;
import haxe.Json;
import enums.OrderStatus;
import events.PlayerRequest;
import events.ActionOrder;
import terrain.GameGrid;

class Room {

    private var server: Server;
    @:isVar public var idRoom(get, null):Float;
    @:isVar public var nameRoom(get, null):String;
    @:isVar public var playerNb(get, null):Int;
    @:isVar public var players(get, null):Array<Float>;
    private var grid: GameGrid;
    private var playerScores: Array<Int>;
    private var _level = 0;

    public function new(id: Float, name: String, serv: Server) {
        idRoom = id;
        name = nameRoom;
        server = serv;
        playerNb = 0;
        playerScores = new Array<Int>();
        players = new Array<Float>();
    }

    public function onPlayerEnter (playerId: Float) {
        if (players.indexOf(playerId) == -1 && playerNb < GameSettings.playerNbToStart) {
            players[playerNb] = playerId;
            playerScores.push(0);
            playerNb++;

            if (playerNb == GameSettings.playerNbToStart) {
                onReadyToLaunch();
            }
        }
    }

    public function onPlayerLeaves (playerId: Float) {
        if (players.remove(playerId)) {
            if (players.length == 1) {
                server.getPlayerById(players[0]).proxy.sendMessage(Json.stringify(new EndOrder(OrderStatus.SUCCESS, MessageType.ENDGAME, "Player " + players[0] + " has won the map ! Next map !")));
                Lobby.getInstance().gameFinishedHandler(this);
            }
        }
    }

    public function onReadyToLaunch () {
        sendMapToClients();
        grid.loadLevel(_level);
    }

    public function onWon (player: Float) {
        playerScores[players.indexOf(player)]++;
        var totalScore = 0;
        var highScore = 0;
        for (i in 0...playerScores.length) {
            totalScore+= playerScores[i];
            if (playerScores[i] > highScore) {
                highScore = playerScores[i];
            }

            if (totalScore >= GameSettings.mapNb) {
                trace("Player " + player + " has won the GAME! Such awesomeness!! :O");
                for (player in players) {
                    var message: String = "Sorry, but your opponent skill is higher than yours...";
                    if (player == players[i]) {
                        message = "Omg you won... Unfortunatly I didn't bet on you...";
                    }
                    server.getPlayerById(player).proxy.sendMessage(Json.stringify(new EndOrder(OrderStatus.SUCCESS, MessageType.ENDGAME, "Player " + players.indexOf(player) + " has won the GAME")));
                }
                server.getLobby().gameFinishedHandler(this);
                return;
            }
        }

        trace("Player " + player + " has won the map! Next map!");
        for (player in players) {
            grid.loadLevel(++_level);
            server.getPlayerById(player).proxy.sendMessage(Json.stringify(new EndOrder(OrderStatus.SUCCESS, MessageType.ENDMAP, "Player " + players.indexOf(player) + " has won the map! Next map!")));
        }
    }

    public function onPlayerRequest (request: PlayerRequest) {
        if (grid.movePlayer(request.player.idPlayer, request.action)) {
            for (player in players) {
                var order = new ActionOrder(request.player.idPlayer, OrderStatus.SUCCESS, request.action);
                server.getPlayerById(player).proxy.sendMessage(Json.stringify(order));
            }

            var winnerId = grid.resolvePlayersMovement();

            if (winnerId != null) {
                this.onWon(winnerId);
            }
        } else {
            for (player in players) {
                var order = new ActionOrder(request.player.idPlayer, OrderStatus.FAILURE, null);
                server.getPlayerById(player).proxy.sendMessage(Json.stringify(order));
            }
        }
    }

    public function sendMapToClients () {
        grid = new GameGrid(players);

        for (i in 0...players.length) {
            trace('Client ' + players[i] + ' asked the map!');
            var gridOrder = new LoadMapOrder(OrderStatus.SUCCESS, grid, i);
            server.getPlayerById(players[i]).proxy.sendMessage(Json.stringify(gridOrder));
        }
    }

    function get_idRoom():Float {
        return idRoom;
    }

    function get_nameRoom():String {
        return nameRoom;
    }

    function get_playerNb():Int {
        return playerNb;
    }

    function get_players():Array<Float> {
        return players;
    }


}
