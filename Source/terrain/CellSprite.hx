package terrain;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

class CellSprite extends Sprite {

    private var _sprite: Bitmap;

    public function new(id: Int) {
        super();
        switch (id) {
            case 0:
                _sprite = new Bitmap(Assets.getBitmapData("assets/terrain/grass.png"));
            case 1:
                _sprite = new Bitmap(Assets.getBitmapData("assets/terrain/forest.png"));
                // TODO _walkable = false;
            case 2:
                _sprite = new Bitmap(Assets.getBitmapData("assets/terrain/exit.png"));
                // TODO _exit = true;
        }

        addChild(_sprite);
    }
}
