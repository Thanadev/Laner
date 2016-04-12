package terrain;

import openfl.display.Sprite;

class GridSprite extends Sprite {

    public function new (grid: GameGrid) {
        super();
        for (row in grid.gameData) {
            for (cell in row) {
                var cellSprite = new CellSprite(cell.id);
                cellSprite.x = x * GameSettings.cellSize;
                cellSprite.y = y * GameSettings.cellSize;
                addChild(cell);
            }
        }
    }
}
