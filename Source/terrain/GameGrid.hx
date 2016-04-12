package terrain;

import net.Room;
import enums.PlayerAction;

typedef GridPosition = {x: Int, y: Int}

class GameGrid {

    private var playerIds: Array<Float>;
    @:isVar public var playerPos(get, null):Array<GridPosition>;
    public var gameData: Array<Array<GameCell>>;
    private var gameMaps: Array<GameLevel>;

    public function new(clients: Array<Float>) {
        super();
        playerIds = clients;
        gameMaps = new Array<GameLevel>();
        for (i in 0...GameSettings.mapNb) {
            gameMaps.push(new GameLevel(i));
        }
    }

    public function loadLevel (level: Int) {
        removeChildren();
        gameData = new Array<Array<GameCell>>();
        playerPos = gameMaps[level].playerPos;
        var mapData: Array<Array<Int>> = gameMaps[level].mapData;

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

    public function movePlayer (playerId: Float, direction: PlayerAction): Bool {
        var index: Int = playerIds.indexOf(playerId);
        if (index < 0) {
            return false;
        }
        //trace(instance.playerPos[index]);

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

    public function resolvePlayersMovement (owner: Room) {
        for (i in 0...playerPos.length) {
            gameData[playerPos[i].y][playerPos[i].x].onResolve(owner, playerIds[i]);
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
