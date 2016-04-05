package terrain;

import enums.PlayerAction;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

typedef GridPosition = {x: Int, y: Int}

class GameGrid extends Sprite {

    private static var instance: GameGrid;

    @:isVar public var playerPos(get, null):GridPosition;
    private var gameData: Array<Array<GameCell>>;

    public static function getInstance (): GameGrid {
        if (instance == null) {
            instance =  new GameGrid();
        }

        return instance;
    }
    private function new() {
        super();
    }

    public function loadLevel (level: Int) {
        removeChildren();
        gameData = new Array<Array<GameCell>>();
        var gameLevel: GameLevel = new GameLevel(level);
        playerPos = gameLevel.playerPos;
        var mapData: Array<Array<Int>> = gameLevel.mapData;

        var x = 0, y = 0;
        for (row in mapData) {
            var gameRow = new Array<GameCell>();
            for (cell in row) {
                var gameCell: GameCell = new GameCell(cell, x, y);
                gameCell.x = x * GameSettings.cellSize;
                gameCell.y = y * GameSettings.cellSize;
                gameRow.push(gameCell);
                addChild(gameCell);
                x++;
            }
            gameData.push(gameRow);
            y++;
            x = 0;
        }
    }

    public static function isMovementLegal (direction: PlayerAction): Bool {
        trace(instance.playerPos);
        switch (direction) {
            case PlayerAction.MOVE_BOTTOM:
                //trace (instance.gameData[instance.playerPos.y + 1][instance.playerPos.x]._position);
                if (instance.gameData.length > instance.playerPos.y + 1 && instance.gameData[instance.playerPos.y + 1][instance.playerPos.x]._walkable) {
                    instance.playerPos.y++;
                    return true;
                }
            case PlayerAction.MOVE_TOP:
                //trace (instance.gameData[instance.playerPos.y - 1][instance.playerPos.x]._position);
                if (instance.playerPos.y - 1 > 0 && instance.gameData[instance.playerPos.y - 1][instance.playerPos.x]._walkable) {
                    instance.playerPos.y--;
                    return true;
                }
            case PlayerAction.MOVE_RIGHT:
               // trace (instance.gameData[instance.playerPos.y][instance.playerPos.x + 1]._position);
                if (instance.gameData[instance.playerPos.y].length > instance.playerPos.x + 1 && instance.gameData[instance.playerPos.y][instance.playerPos.x + 1]._walkable) {
                    instance.playerPos.x++;
                    return true;
                }
            case PlayerAction.MOVE_LEFT:
                //trace (instance.gameData[instance.playerPos.y][instance.playerPos.x - 1]._position);
                if (instance.playerPos.x - 1 > 0 && instance.gameData[instance.playerPos.y][instance.playerPos.x - 1]._walkable) {
                    instance.playerPos.x--;
                    return true;
                }
            default:
                return false;
        }

        return false;
    }

    public static function resolvePlayerMovement () {
        instance.gameData[instance.playerPos.y][instance.playerPos.x].onResolve();
    }

    function get_playerPos():GridPosition {
        return playerPos;
    }


}
