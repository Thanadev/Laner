package ;

import enums.PlayerRequestStatus;
import events.ServerOrder;
import events.PlayerRequest;
import net.PlayerIdentity;
import terrain.GameGrid;

class Server {

    private var _grid: GameGrid;
    private var _clients: Array<Main>;

    public function new (client: Main) {
        _clients = [client];
    }

    public function sendMapToClients (): GameGrid {
        var ids = new Array<Float>();
        for (client in _clients) {
            ids.push(client.sendIdHandler());
        }
        _grid = GameGrid.getInstance(ids);
        return _grid;
    }

    public function requestIdentityHandler (): PlayerIdentity {
        return new PlayerIdentity(Date.now().getTime(), "DefaultPlayerName");
    }

    public function playerRequestHandler (request: PlayerRequest) {
        if (_grid.isMovementLegal(request.player.idPlayer, request.action)) {
            _clients[0].serverOrderHandler(new ServerOrder(request.player.idPlayer, PlayerRequestStatus.SUCCESS, request.action));
        } else {
            _clients[0].serverOrderHandler(new ServerOrder(request.player.idPlayer, PlayerRequestStatus.FAILURE, null));
        }
    }
}
