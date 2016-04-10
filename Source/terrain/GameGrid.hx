package terrain;

import enums.PlayerAction;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

typedef GridPosition = {x: Int, y: Int}

class GameGrid extends Sprite {

    private static var instance: GameGrid;

    private var playerIds: Array<Float>;
    @:isVar public var playerPos(get, null):Array<GridPosition>;
    private var gameData: Array<Array<GameCell>>;

    public static function getInstance (clients: Array<Float>): GameGrid {
        if (instance == null) {
            instance =  new GameGrid(clients);
        }

        return instance;
    }

    private function new(clients: Array<Float>) {
        super();
        playerIds = clients;
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

    public function isMovementLegal (playerId: Float, direction: PlayerAction): Bool {
        //trace(instance.playerPos);
        var index: Int = playerIds.indexOf(playerId);
        if (index < 0) {
            return false;
        }

        switch (direction) {
            case PlayerAction.MOVE_BOTTOM:
                //trace (instance.gameData[instance.playerPos.y + 1][instance.playerPos.x]._position);
                if (gameData.length > playerPos[index].y + 1 && gameData[playerPos[index].y + 1][playerPos[index].x]._walkable) {
                    playerPos[index].y++;
                    return true;
                }
            case PlayerAction.MOVE_TOP:
                //trace (gameData[playerPos[index].y - 1][playerPos[index].x]._position);
                if (playerPos[index].y - 1 > 0 && gameData[playerPos[index].y - 1][playerPos[index].x]._walkable) {
                    playerPos[index].y--;
                    return true;
                }
            case PlayerAction.MOVE_RIGHT:
               // trace (gameData[playerPos[index].y][playerPos[index].x + 1]._position);
                if (gameData[playerPos[index].y].length > playerPos[index].x + 1 && gameData[playerPos[index].y][playerPos[index].x + 1]._walkable) {
                    playerPos[index].x++;
                    return true;
                }
            case PlayerAction.MOVE_LEFT:
                //trace (gameData[playerPos[index].y][playerPos[index].x - 1]._position);
                if (playerPos[index].x - 1 > 0 && gameData[playerPos[index].y][playerPos[index].x - 1]._walkable) {
                    playerPos[index].x--;
                    return true;
                }
            default:
                return false;
        }

        return false;
    }

    public static function resolvePlayersMovement () {
        for (i in 0...instance.playerPos.length) {
            instance.gameData[instance.playerPos[i].y][instance.playerPos[i].x].onResolve();
        }
    }

    public function getPlayerLocation (playerId: Float): GridPosition {
        var index: Int = playerIds.indexOf(playerId);
        if (index > -1 && index < 2) {
            return playerPos[index];
        }

        return null;
    }

    function get_playerPos():Array<GridPosition> {
        return playerPos;
    }


}
