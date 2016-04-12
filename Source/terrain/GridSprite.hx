package terrain;

import openfl.display.Sprite;

class GridSprite extends Sprite {

    public function new (grid: GameGrid) {
        super();
        for (row in grid.gameData) {
            for (cell in row) {
                var cellSprite = new CellSprite(cell._id);
                cellSprite.x = cell._position.x * GameSettings.cellSize;
                cellSprite.y = cell._position.y * GameSettings.cellSize;
                addChild(cellSprite);
            }
        }
    }
}
