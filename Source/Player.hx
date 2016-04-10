package;

import terrain.GameGrid;
import enums.PlayerAction;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.display.Sprite;

class Player extends Sprite {

    private var playerSprite: Bitmap;
    private var sprites: Map<PlayerAction, BitmapData>;

    public function new () {
        super ();
        loadSprites();
        playerSprite  = new Bitmap(cast (sprites.get(PlayerAction.MOVE_BOTTOM), BitmapData));
        addChild(playerSprite);
    }

    private function loadSprites () {
        sprites = new Map<PlayerAction, BitmapData>();
        sprites.arrayWrite(PlayerAction.MOVE_TOP, Assets.getBitmapData("assets/player/player_top.png"));
        sprites.arrayWrite(PlayerAction.MOVE_BOTTOM, Assets.getBitmapData("assets/player/player_bottom.png"));
        sprites.arrayWrite(PlayerAction.MOVE_LEFT, Assets.getBitmapData("assets/player/player_left.png"));
        sprites.arrayWrite(PlayerAction.MOVE_RIGHT, Assets.getBitmapData("assets/player/player_right.png"));
    }


    /**
    * @brief actualize avatar position on clients
    **/
    private function move (direction: PlayerAction) {
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

        playerSprite.bitmapData = sprites.get(direction);
    }

    public function receiveOrder (order: PlayerAction) {
        if (order == PlayerAction.MOVE_BOTTOM || order == PlayerAction.MOVE_LEFT || order == PlayerAction.MOVE_RIGHT || order == PlayerAction.MOVE_TOP) {
            move(order);
        }
    }

    public function setPosition (position: GridPosition) {
        playerSprite.x = position.x * GameSettings.cellSize;
        playerSprite.y = position.y * GameSettings.cellSize;
    }
}
