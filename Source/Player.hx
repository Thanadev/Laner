package;

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
        trace ("Player spawned at " + position);
        loadSprites();
        playerSprite  = new Bitmap(cast (sprites.get(PlayerAction.MOVE_BOTTOM), BitmapData));
        addChild(playerSprite);
        setPosition(position);
        Main._stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    private function loadSprites () {
        sprites = new Map<PlayerAction, BitmapData>();
        sprites.arrayWrite(PlayerAction.MOVE_TOP, Assets.getBitmapData("assets/player/player_top.png"));
        sprites.arrayWrite(PlayerAction.MOVE_BOTTOM, Assets.getBitmapData("assets/player/player_bottom.png"));
        sprites.arrayWrite(PlayerAction.MOVE_LEFT, Assets.getBitmapData("assets/player/player_left.png"));
        sprites.arrayWrite(PlayerAction.MOVE_RIGHT, Assets.getBitmapData("assets/player/player_right.png"));
    }

    private function onKeyUp (evt: KeyboardEvent) {
        if (evt.keyCode == Keyboard.UP) {
            move(PlayerAction.MOVE_TOP);
        } else if (evt.keyCode == Keyboard.DOWN) {
            move(PlayerAction.MOVE_BOTTOM);
        } else if (evt.keyCode == Keyboard.RIGHT) {
            move(PlayerAction.MOVE_RIGHT);
        } else if (evt.keyCode == Keyboard.LEFT) {
            move(PlayerAction.MOVE_LEFT);
        }
    }

    private function move (direction: PlayerAction) {
        if (!GameGrid.isMovementLegal(direction)) {
            return;
        }

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

        GameGrid.resolvePlayerMovement();
        playerSprite.bitmapData = sprites.get(direction);
    }

    public function setPosition (position: GridPosition) {
        playerSprite.x = position.x * GameSettings.cellSize;
        playerSprite.y = position.y * GameSettings.cellSize;
    }
}
