package ;

import net.Lobby;
import events.PlayerRequest;
import net.PlayerIdentity;
import terrain.GameGrid;

class Server {

    public static var instance(get, null): Server;
    private static var _instance: Server;

    private var _grid: GameGrid;
    private var _lobby:Lobby;

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
        _lobby = Lobby.getInstance(this);
    }

    public function requestIdentityHandler (): PlayerIdentity {
        var identity: PlayerIdentity = new PlayerIdentity(Date.now().getTime(), "DefaultPlayerName");
        return identity;
    }

    public function requestLobbyConnection (player: PlayerIdentity) {
        _lobby.addPlayer(player);
        _lobby.playerConnectHandler(player);
    }

    public function playerRequestHandler (request: PlayerRequest) {
        _lobby.findPlayer(request.player.idPlayer).onPlayerRequest(request);
    }

    public function getPlayerById (idPlayer: Float) {
        var ret = null;

        for (player in _lobby.getPlayers()) {
            if (player.idPlayer == idPlayer) {
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
