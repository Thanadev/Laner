package ;

import net.PlayerData;
import routes.MainRoute;
import nodejs.express.Express;
import socket.WSocketServer;
import nodejs.express.Application;
import net.Lobby;
import events.PlayerRequest;
import net.PlayerIdentity;
import terrain.GameGrid;
import nodejs.Process;
import nodejs.NodeJS;

class Server {

    public static var instance(get, null): Server;
    private static var _instance: Server;

    private var _grid: GameGrid;
    private var _lobby:Lobby;
    private var _express:Application;
    private var _websocketServer:WSocketServer;
    private var _process:Process;

    public static function main():Void {
        _instance = new Server();
    }

    public static function get_instance() {
        if (_instance == null) {
            _instance = new Server();
        }

        return _instance;
    }

    public function new () {
        GameSettings.serverAddress = NodeJS.dirname + '/';

        _process = NodeJS.process;

        _express = Express.GetApplication();
        _express.listen(GameSettings.APP_PORT);
        _express.use(Express.Static(GameSettings.serverAddress));

        var mainRoute = new MainRoute();
        _express.get('/', mainRoute.succesHandler);

        trace('Server listening on ' + GameSettings.APP_PORT);

        _websocketServer = new WSocketServer();
        _lobby = Lobby.getInstance();
        _lobby.setServer(this);
    }

    public function requestIdentityHandler (): PlayerIdentity {
        var identity: PlayerIdentity = new PlayerIdentity(Date.now().getTime(), "DefaultPlayerName");
        return identity;
    }

    public function playerRequestHandler (request: PlayerRequest) {
        _lobby.findPlayer(request.player.idPlayer).onPlayerRequest(request);
    }

    public function getPlayerById (idPlayer: Float): PlayerData {
        var ret = null;

        for (player in _lobby.getPlayers()) {
            if (player.identity.idPlayer == idPlayer) {
                ret = player;
                break;
            }
        }

        return ret;
    }

    public function getLobby():Lobby {
        return _lobby;
    }

}
