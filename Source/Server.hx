package ;

import net.PlayerIdentity;
import terrain.GameGrid;
import net.PlayerRequest;

class Server {

    private var _grid: GameGrid;

    public function new () {
        _grid = GameGrid.getInstance();
    }

    public function sendMapToClients (): GameGrid {
        return _grid;
    }

    public function requestIdentityHandler (): PlayerIdentity {
        return new PlayerIdentity(Date.now().getTime(), "DefaultPlayerName");
    }

    public function playerRequestHandler (request: PlayerRequest) {

    }
}
