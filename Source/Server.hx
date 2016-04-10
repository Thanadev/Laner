package ;

import net.Lobby;
import enums.PlayerRequestStatus;
import events.ServerOrder;
import events.PlayerRequest;
import net.PlayerIdentity;
import terrain.GameGrid;

class Server {

    private var _grid: GameGrid;
    @:isVar public var _clients(get, null):Array<Client>;
    private var _lobby: Lobby;

    public function new () {
        _clients = new Array<Client>();
        _lobby = Lobby.getInstance(this);
    }

    public function getCorrespondingClient (identity: PlayerIdentity): Client {
        for (client in _clients) {
            if (client.identity.idPlayer == identity.idPlayer) {
                return client;
            }
        }

        return null;
    }

    public function requestIdentityHandler (): PlayerIdentity {
        var identity: PlayerIdentity = new PlayerIdentity(Date.now().getTime(), "DefaultPlayerName");
        return identity;
    }

    public function requestLobbyConnection (client: Client) {
        _clients.push(client);
        _lobby.playerConnectHandler(client.identity);
    }

    public function playerRequestHandler (request: PlayerRequest) {
        _lobby.findPlayer(request.player.idPlayer).onPlayerRequest(request);
    }

    public function getClientById (idPlayer: Float) {
        for (client in _clients) {
            trace (client.identity.idPlayer + " / " + idPlayer);
            if (client.identity.idPlayer == idPlayer) {
                return client;
            }
        }

        return null;
    }

    function get__clients():Array<Client> {
        return _clients;
    }
}
