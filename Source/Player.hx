package;

import events.PlayerRequest;
import openfl.events.EventDispatcher;
import lime.app.Event;
import terrain.GameGrid;
import enums.PlayerAction;
import Main;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.display.Sprite;

class Player extends Sprite {

    public var broadcaster: EventDispatcher;

    private static var instance: Player;

    private var playerSprite: Bitmap;
    private var sprites: Map<PlayerAction, BitmapData>;

    public static function getInstance (position: GridPosition) {
        if (instance == null) {
            instance = new Player (position);
        } else {
            instance.setPosition(position);
        }

        return instance;
    }

    public function new (position: GridPosition) {
        super ();
        broadcaster = new EventDispatcher();
        trace ("Player spawned at " + position);
        loadSprites();
        playerSprite  = new Bitmap(cast (sprites.get(PlayerAction.MOVE_BOTTOM), BitmapData));
        addChild(playerSprite);
        setPosition(position);
        Main._stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
    }

    private function loadSprites () {
        sprites = new Map<PlayerAction, BitmapData>();
        sprites.arrayWrite(PlayerAction.MOVE_TOP, Assets.getBitmapData("assets/player/player_top.png"));
        sprites.arrayWrite(PlayerAction.MOVE_BOTTOM, Assets.getBitmapData("assets/player/player_bottom.png"));
        sprites.arrayWrite(PlayerAction.MOVE_LEFT, Assets.getBitmapData("assets/player/player_left.png"));
        sprites.arrayWrite(PlayerAction.MOVE_RIGHT, Assets.getBitmapData("assets/player/player_right.png"));
    }

    private function onKeyUpHandler (evt: KeyboardEvent) {
        if (evt.keyCode == Keyboard.UP) {
            broadcaster.dispatchEvent(new PlayerRequest(Main.getInstance().identity, PlayerAction.MOVE_TOP));
            //move(Main.getPlayerId(), PlayerAction.MOVE_TOP);
        } else if (evt.keyCode == Keyboard.DOWN) {
            broadcaster.dispatchEvent(new PlayerRequest(Main.getInstance().identity, PlayerAction.MOVE_BOTTOM));
            //move(Main.getPlayerId(), PlayerAction.MOVE_BOTTOM);
        } else if (evt.keyCode == Keyboard.RIGHT) {
            broadcaster.dispatchEvent(new PlayerRequest(Main.getInstance().identity, PlayerAction.MOVE_RIGHT));
            //move(Main.getPlayerId(), PlayerAction.MOVE_RIGHT);
        } else if (evt.keyCode == Keyboard.LEFT) {
            broadcaster.dispatchEvent(new PlayerRequest(Main.getInstance().identity, PlayerAction.MOVE_LEFT));
           // move(Main.getPlayerId(), PlayerAction.MOVE_LEFT);
        }
    }
    /**
    * @brief actualize avatar position on clients
    **/
    private function move (playerId: Float, direction: PlayerAction) {

        // TODO let server control movements
        /*if (!GameGrid.isMovementLegal(direction)) {
            return;
        }*/

        switch (direction) {
            case PlayerAction.MOVE_TOP:
                playerSprite.y -= GameSettings.cellSize;
            case PlayerAction.MOVE_BOTTOM:
                playerSprite.y += GameSettings.cellSize;
            case PlayerAction.MOVE_RIGHT:
                playerSprite.x += GameSettings.cellSize;
            case PlayerAction.MOVE_LEFT:
                playerSprite.x -= GameSettings.cellSize;
            default:
                return;
        }

        // TODO move on server
        GameGrid.resolvePlayersMovement();
        playerSprite.bitmapData = sprites.get(direction);
    }

    public function receiveOrder (playerId: Float, order: PlayerAction) {
        if (order == PlayerAction.MOVE_BOTTOM || order == PlayerAction.MOVE_LEFT || order == PlayerAction.MOVE_RIGHT || order == PlayerAction.MOVE_TOP) {
            move(playerId, order);
        }
    }

    public function setPosition (position: GridPosition) {
        playerSprite.x = position.x * GameSettings.cellSize;
        playerSprite.y = position.y * GameSettings.cellSize;
    }
}
