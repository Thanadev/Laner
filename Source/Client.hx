package;

import openfl.events.EventDispatcher;
import enums.PlayerAction;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import net.PlayerIdentity;
import events.ServerOrder;
import enums.PlayerRequestStatus;
import net.Room;
import events.PlayerRequest;
import openfl.events.Event;
import terrain.GameGrid;
import openfl.display.Stage;
import openfl.display.Sprite;

class Client extends Sprite {

	private static var instance: Client;

	private var server: Server;
	private var _level: Int;
	private var grid: GameGrid;
	private var localPlayer: Player;
    private var enemyPlayer: Player;
    private var broadcaster: EventDispatcher;
    @:isVar public var identity(get, null):PlayerIdentity;

	public function new () {
        super();
        instance = this;
        broadcaster = new EventDispatcher();

		server = new Server();
        identity = server.requestIdentityHandler();
        server.requestLobbyConnection(this);
	}

    private function connectToRoom (room: Room) {
        //room.onPlayerEnter();
    }

    public function initGame (_grid: GameGrid) {
        grid = _grid;
        localPlayer = new Player();
        enemyPlayer = new Player();
        _level = 0;
        startLevel(_level);
    }


	private function startLevel (level: Int) {
		trace("Starting level " + _level);
		grid.loadLevel(level);
        for (pos in grid.playerPos) {
            if (pos == grid.getPlayerLocation(identity.idPlayer)) {
                localPlayer.setPosition(pos);
            } else {
                enemyPlayer.setPosition(pos);
            }
        }

		addChild(grid);
		grid.x = (stage.stageWidth - (GameSettings.mapWidth - 1) * GameSettings.cellSize) /2;
		grid.y = (stage.stageHeight - (GameSettings.mapHeight - 1) * GameSettings.cellSize) /2;
		addChild(localPlayer);
        localPlayer.x = (stage.stageWidth - (GameSettings.mapWidth - 1) * GameSettings.cellSize) /2;
        localPlayer.y = (stage.stageHeight - (GameSettings.mapHeight - 1) * GameSettings.cellSize) /2;
        addChild(enemyPlayer);
        enemyPlayer.x = (stage.stageWidth - (GameSettings.mapWidth - 1) * GameSettings.cellSize) /2;
        enemyPlayer.y = (stage.stageHeight - (GameSettings.mapHeight - 1) * GameSettings.cellSize) /2;

        stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}

    private function reset () {
        stage.removeEventListener(KeyboardEvent.KEY_UP, instance.keyUpHandler);
        removeChildren();
    }

	public function onWon () {
        reset();
		startLevel(++instance._level);
	}

    public function onGameEnded (message: String) {
        reset();
        trace(message);
    }

    private function playerRequestHandler (evt: PlayerRequest) {
        server.playerRequestHandler(evt);
    }

	public function serverOrderHandler (order: ServerOrder) {
        if (order.status == PlayerRequestStatus.SUCCESS) {
            if (order.playerId == identity.idPlayer) {
                localPlayer.receiveOrder(order.order);
            } else {
                enemyPlayer.receiveOrder(order.order);
            }
        }
	}

    public function sendIdHandler (): Float {
        return identity.idPlayer;
    }

    public static function getInstance (): Client {
        return instance;
    }

    public static function getPlayerId (): Float {
        return instance.identity.idPlayer;
    }

    private function keyUpHandler (evt: KeyboardEvent) {
        if (evt.keyCode == Keyboard.UP) {
            playerRequestHandler(new PlayerRequest(identity, PlayerAction.MOVE_TOP));
        } else if (evt.keyCode == Keyboard.DOWN) {
            playerRequestHandler(new PlayerRequest(identity, PlayerAction.MOVE_BOTTOM));
        } else if (evt.keyCode == Keyboard.RIGHT) {
            playerRequestHandler(new PlayerRequest(identity, PlayerAction.MOVE_RIGHT));
        } else if (evt.keyCode == Keyboard.LEFT) {
            playerRequestHandler(new PlayerRequest(identity, PlayerAction.MOVE_LEFT));
        }
    }

    function get_identity():PlayerIdentity {
        return identity;
    }
}