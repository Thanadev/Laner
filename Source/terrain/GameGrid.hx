package terrain;

import Array;
import enums.PlayerAction;

typedef GridPosition = {x: Int, y: Int}

class GameGrid {

    public var playerIds: Array<Float>;
    public var playerPos:Array<GridPosition>;
    public var gameData: Array<Array<GameCell>>;
    public var gameMaps: Array<GameLevel>;

    public function new(playerIds: Array<Float>) {
        this.playerIds = playerIds;
        this.playerPos = new Array<GridPosition>();
        this.gameMaps = new Array<GameLevel>();
        for (i in 0...GameSettings.mapNb) {
            gameMaps.push(new GameLevel(i));
        }
    }

    public function setGrid (_playerIds: Array<Float>, _gameMaps: Array<GameLevel>) {
        playerIds = _playerIds;
        trace(playerIds);
        gameMaps = _gameMaps;
    }

    public function loadLevel (level: Int) {
        gameData = new Array<Array<GameCell>>();
        playerPos = gameMaps[level].playerPos;
        var mapData: Array<Array<Int>> = gameMaps[level].mapData;

        var x = 0, y = 0;
        for (row in mapData) {
            var gameRow = new Array<GameCell>();
            for (cell in row) {
                var gameCell: GameCell = new GameCell(cell, x, y);
                gameRow.push(gameCell);
                x++;
            }
            gameData.push(gameRow);
            y++;
            x = 0;
        }
    }

    public function movePlayer (playerId: Float, direction: PlayerAction): Bool {
        var index: Int = playerIds.indexOf(playerId);
        if (index < 0) {
            return false;
        }

        switch (direction) {
            case PlayerAction.MOVE_BOTTOM:
                if (gameData.length > playerPos[index].y + 1 && gameData[playerPos[index].y + 1][playerPos[index].x]._walkable) {
                    playerPos[index].y++;
                    return true;
                }
            case PlayerAction.MOVE_TOP:
                if (playerPos[index].y - 1 > 0 && gameData[playerPos[index].y - 1][playerPos[index].x]._walkable) {
                    playerPos[index].y--;
                    return true;
                }
            case PlayerAction.MOVE_RIGHT:
                if (gameData[playerPos[index].y].length > playerPos[index].x + 1 && gameData[playerPos[index].y][playerPos[index].x + 1]._walkable) {
                    playerPos[index].x++;
                    return true;
                }
            case PlayerAction.MOVE_LEFT:
                if (playerPos[index].x - 1 > 0 && gameData[playerPos[index].y][playerPos[index].x - 1]._walkable) {
                    playerPos[index].x--;
                    return true;
                }
            default:
                return false;
        }

        return false;
    }

    public function resolvePlayersMovement () {
        var ret = null;

        for (i in 0...playerPos.length) {
            if (gameData[playerPos[i].y][playerPos[i].x].onResolve(playerIds[i])) {
                ret = playerIds[i];
            }
        }

        return ret;
    }

    public function getPlayerLocation (playerId: Float): GridPosition {
        var index: Int = playerIds.indexOf(playerId);
        if (index > -1 && index < 2) {
            return playerPos[index];
        }

        return null;
    }


}
