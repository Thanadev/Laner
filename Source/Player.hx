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

    public function new (isLocal: Bool) {
        super ();
        loadSprites(isLocal);
        playerSprite  = new Bitmap(cast (sprites.get(PlayerAction.MOVE_BOTTOM), BitmapData));
        addChild(playerSprite);
    }

    private function loadSprites (isLocal: Bool) {
        sprites = new Map<PlayerAction, BitmapData>();
        if (isLocal) {
            sprites.arrayWrite(PlayerAction.MOVE_TOP, Assets.getBitmapData("assets/players/player_top.png"));
            sprites.arrayWrite(PlayerAction.MOVE_BOTTOM, Assets.getBitmapData("assets/players/player_bottom.png"));
            sprites.arrayWrite(PlayerAction.MOVE_LEFT, Assets.getBitmapData("assets/players/player_left.png"));
            sprites.arrayWrite(PlayerAction.MOVE_RIGHT, Assets.getBitmapData("assets/players/player_right.png"));
        } else {
            sprites.arrayWrite(PlayerAction.MOVE_TOP, Assets.getBitmapData("assets/players/enemy_top.png"));
            sprites.arrayWrite(PlayerAction.MOVE_BOTTOM, Assets.getBitmapData("assets/players/enemy_bottom.png"));
            sprites.arrayWrite(PlayerAction.MOVE_LEFT, Assets.getBitmapData("assets/players/enemy_left.png"));
            sprites.arrayWrite(PlayerAction.MOVE_RIGHT, Assets.getBitmapData("assets/players/enemy_right.png"));
        }

    }


    /**
    * @brief actualize avatar position on clients
    **/
    private function move (direction: PlayerAction) {
        switch (direction) {
            case PlayerAction.MOVE_TOP:
                trace("moving top");
                playerSprite.y -= GameSettings.cellSize;
            case PlayerAction.MOVE_BOTTOM:
                trace("moving bottom");
                playerSprite.y += GameSettings.cellSize;
            case PlayerAction.MOVE_RIGHT:
                trace("moving right");
                playerSprite.x += GameSettings.cellSize;
            case PlayerAction.MOVE_LEFT:
                trace("moving left");
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
