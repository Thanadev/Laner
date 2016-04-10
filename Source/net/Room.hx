package net;

import enums.PlayerRequestStatus;
import events.PlayerRequest;
import events.ServerOrder;
import terrain.GameGrid;

class Room {

    private var server: Server;
    @:isVar public var idRoom(get, null):Float;
    @:isVar public var nameRoom(get, null):String;
    @:isVar public var playerNb(get, null):Int;
    @:isVar public var players(get, null):Array<Float>;
    private var grid: GameGrid;
    private var playerScores: Array<Int>;

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
            if (players.length > 0) {
                // TODO on player wins
            }
        }
    }

    public function onReadyToLaunch () {
        sendMapToClients();
    }

    public function onWon (player: Float) {


        playerScores[players.indexOf(player)] ++;
        var totalScore = 0;
        var highScore = 0;
        for (i in 0...playerScores.length) {
            totalScore+= playerScores[i];
            if (playerScores[i] > highScore) {
                highScore = playerScores[i];
            }

            if (totalScore >= GameSettings.mapNb) {
                trace("Player " + players.indexOf(player) + " has won the GAME ! Such awesomeness !! :O");
                for (player in players) {
                    var message: String = "Sorry, but your opponent skill is higher than yours...";
                    if (player == players[i]) {
                        message = "Omg you won... Unfortunatly I didn't bet on you...";
                    }
                    server.getClientById(player).onGameEnded(message);
                }
                return;
            }
        }

        trace("Player " + players.indexOf(player) + " has won the map ! Next map !");
        for (player in players) {
            server.getClientById(player).onWon();
        }
    }

    public function onPlayerRequest (request: PlayerRequest) {
        if (grid.movePlayer(request.player.idPlayer, request.action)) {
            for (player in players) {
                server.getClientById(player).serverOrderHandler(new ServerOrder(request.player.idPlayer, PlayerRequestStatus.SUCCESS, request.action));
            }
            grid.resolvePlayersMovement(this);
        } else {
            for (player in players) {
                server.getClientById(player).serverOrderHandler(new ServerOrder(request.player.idPlayer, PlayerRequestStatus.FAILURE, null));
            }
        }
    }

    public function sendMapToClients () {
        grid = new GameGrid(players);
        for (player in players) {
            trace ("Client asked !");
            server.getClientById(player).initGame(grid);
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
