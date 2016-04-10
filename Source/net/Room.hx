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

    public function new(id: Float, name: String, serv: Server) {
        idRoom = id;
        name = nameRoom;
        server = serv;
        playerNb = 0;
        players = new Array<Float>();
    }

    public function onPlayerEnter (playerId: Float) {
        if (players.indexOf(playerId) == -1 && playerNb < GameSettings.playerNbToStart) {
            players[playerNb] = playerId;
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
        // TODO Start a game giving the ids of the two players
        sendMapToClients();
    }

    public function onPlayerRequest (request: PlayerRequest) {
        if (grid.movePlayer(request.player.idPlayer, request.action)) {
            for (player in players) {
                server.getClientById(player).serverOrderHandler(new ServerOrder(request.player.idPlayer, PlayerRequestStatus.SUCCESS, request.action));
            }
            grid.resolvePlayersMovement();
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
