package;

import net.PlayerIdentity;
import events.ServerOrder;
import enums.PlayerRequestStatus;
import net.Room;
import events.PlayerRequest;
import openfl.events.Event;
import terrain.GameGrid;
import openfl.display.Stage;
import openfl.display.Sprite;

class Main extends Sprite {
	public static var _stage: Stage;

	private static var instance: Main;

	private var server: Server;
	private var _level: Int;
	private var grid: GameGrid;
	private var player: Player;
    @:isVar public var identity(get, null):PlayerIdentity;

	public function new () {
        super();

		server = new Server(this);
        identity = server.requestIdentityHandler();
        grid = server.sendMapToClients();

		instance = this;
		_stage = this.stage;
		_level = 0;
		startLevel(_level);
	}

    private function connectToRoom (room: Room) {
        //room.onPlayerEnter();
    }

	private function startLevel (level: Int) {
		trace("Starting level " + _level);
		grid.loadLevel(level);

        this.player = Player.getInstance(grid.getPlayerLocation(identity.idPlayer));
        player.broadcaster.addEventListener("PlayerRequest", playerRequestHandler);

		addChild(grid);
		grid.x = (stage.stageWidth - (10 - 1) * GameSettings.cellSize) /2;
		grid.y = (stage.stageHeight - (10 - 1) * GameSettings.cellSize) /2;
		addChild(player);
		player.x = (stage.stageWidth - (10 - 1) * GameSettings.cellSize) /2;
		player.y = (stage.stageHeight - (10 - 1) * GameSettings.cellSize) /2;
	}

	public static function onWon () {
		instance.removeChildren();
		instance.startLevel(++instance._level);
	}

    private function playerRequestHandler (evt: PlayerRequest) {
        server.playerRequestHandler(evt);
    }

	public function serverOrderHandler (order: ServerOrder) {
        if (order.status == PlayerRequestStatus.SUCCESS) {
            player.receiveOrder(order.playerId, order.order);
        }
	}

    public function sendIdHandler (): Float {
        return identity.idPlayer;
    }

    public static function getInstance (): Main {
        return instance;
    }

    public static function getPlayerId (): Float {
        return instance.identity.idPlayer;
    }

	public function gameFinished () {
	}

    function get_identity():PlayerIdentity {
        return identity;
    }
}