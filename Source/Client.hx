package;

import net.ServerProxy;
import terrain.GridSprite;
import openfl.events.EventDispatcher;
import enums.PlayerAction;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import net.PlayerIdentity;
import events.ActionOrder;
import enums.OrderStatus;
import events.PlayerRequest;
import openfl.events.Event;
import terrain.GameGrid;
import openfl.display.Stage;
import openfl.display.Sprite;

class Client extends Sprite {

	private static var instance: Client;

    private var _level: Int;
	private var gridData: GameGrid;
    private var gridSprite: GridSprite;
	private var localPlayer: Player;
    private var enemyPlayer: Player;
    private var broadcaster: EventDispatcher;
    private var _identity: PlayerIdentity;
    private var _proxy: ServerProxy;

	public function new () {
        super();
        instance = this;
        broadcaster = new EventDispatcher();
        _proxy = new ServerProxy(this);
	}

    public function initGame (_gridData: GameGrid) {
        gridData = _gridData;
        localPlayer = new Player();
        enemyPlayer = new Player();
        _level = 0;
        startLevel(_level);
    }


	private function startLevel (level: Int) {
		trace("Starting level " + _level);
		gridData.loadLevel(level);
        gridSprite = new GridSprite(gridData);
        trace (_identity.idPlayer);
        for (i in 0...gridData.playerPos.length) {
            var pos = gridData.getPlayerLocation(_identity.idPlayer);
            if (pos == null) {
                trace("Position is null, check ids !!");
                break;
            }
            if (gridData.playerPos[i] == pos) {
                trace("Player pos found ! " + gridData.playerPos[i]);
                localPlayer.setPosition(gridData.playerPos[i]);
            } else {
                trace("Enemy pos found !" + gridData.playerPos[i]);
                enemyPlayer.setPosition(gridData.playerPos[i]);
            }
        }

		addChild(gridSprite);
		gridSprite.x = (stage.stageWidth - (GameSettings.mapWidth - 1) * GameSettings.cellSize) /2;
		gridSprite.y = (stage.stageHeight - (GameSettings.mapHeight - 1) * GameSettings.cellSize) /2;
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

    private function playerRequestHandler (request: PlayerRequest) {
        _proxy.sendRequest(request);
    }

	public function serverOrderHandler (order: ActionOrder) {
        if (order.status == OrderStatus.SUCCESS) {
            if (order.playerId == _identity.idPlayer) {
                localPlayer.receiveOrder(order.order);
            } else {
                enemyPlayer.receiveOrder(order.order);
            }
        }
	}

    public function sendIdHandler (): Float {
        return _identity.idPlayer;
    }

    public static function getInstance (): Client {
        return instance;
    }

    public static function getPlayerId (): Float {
        return instance.getIdentity().idPlayer;
    }

    private function keyUpHandler (evt: KeyboardEvent) {
        if (evt.keyCode == Keyboard.UP) {
            playerRequestHandler(new PlayerRequest(_identity, PlayerAction.MOVE_TOP));
        } else if (evt.keyCode == Keyboard.DOWN) {
            playerRequestHandler(new PlayerRequest(_identity, PlayerAction.MOVE_BOTTOM));
        } else if (evt.keyCode == Keyboard.RIGHT) {
            playerRequestHandler(new PlayerRequest(_identity, PlayerAction.MOVE_RIGHT));
        } else if (evt.keyCode == Keyboard.LEFT) {
            playerRequestHandler(new PlayerRequest(_identity, PlayerAction.MOVE_LEFT));
        }
    }

    public function setIdentity (identity: PlayerIdentity) {
        if (_identity == null) {
            _identity = identity;
        }
    }

    public function getIdentity():PlayerIdentity {
        return _identity;
    }
}