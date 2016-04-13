package;

import model.Point;
import openfl.events.TouchEvent;
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
    private var _mouseSwipe: Array<Point>;

	public function new () {
        super();
        instance = this;
        broadcaster = new EventDispatcher();
        _proxy = new ServerProxy(this);
        _mouseSwipe = new Array<Point>();
	}

    public function initGame (_gridData: GameGrid) {
        gridData = _gridData;
        localPlayer = new Player(true);
        enemyPlayer = new Player(false);
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
        stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
        stage.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
	}

    private function reset () {
        stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
        stage.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
        stage.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
        removeChildren();
    }

    private function touchBeginHandler (evt: TouchEvent) {
        trace('Touch begin');
        _mouseSwipe = new Array<Point>();
        _mouseSwipe.push(new Point(evt.stageX, evt.stageY));
    }

    private function touchEndHandler (evt: TouchEvent) {
        trace('Touch end');
        _mouseSwipe.push(new Point(evt.stageX, evt.stageY));


        var direction:PlayerAction = null;


        var averageX = _mouseSwipe[1].x - _mouseSwipe[0].x;
        var averageY = _mouseSwipe[1].y - _mouseSwipe[0].y;

        if (Math.abs(averageX) > Math.abs(averageY)) {
            if (averageX > 0) {
                direction = PlayerAction.MOVE_RIGHT;
            } else {
                direction = PlayerAction.MOVE_LEFT;
            }
        } else {
            if (averageY > 0) {
                direction = PlayerAction.MOVE_BOTTOM;
            } else {
                direction = PlayerAction.MOVE_TOP;
            }
        }

        trace(direction);

        playerRequestHandler(new PlayerRequest(_identity, direction));
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

	public function onWon (level: Int) {
        _level = level;

        reset();
		startLevel(_level);
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
                trace("local player moved ! " + order.playerId);
                localPlayer.receiveOrder(order.order);
            } else {
                trace("enemy player moved ! " + order.playerId);
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

    public function setIdentity (identity: PlayerIdentity) {
        if (_identity == null) {
            _identity = identity;
        }
    }

    public function getIdentity():PlayerIdentity {
        return _identity;
    }
}