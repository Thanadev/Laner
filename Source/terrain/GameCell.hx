package terrain;

import Main;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import terrain.GameGrid.GridPosition;

class GameCell extends Sprite {

    public var _position:GridPosition;
    public var _walkable:Bool;
    public var _exit:Bool;
    public var _sprite:Bitmap;

    public function new (id: Int, x: Int, y: Int) {
        super();
        _position = {x: x, y: y};
        _walkable = true;
        switch (id) {
            case 0:
                _sprite = new Bitmap(Assets.getBitmapData("assets/terrain/grass.png"));
            case 1:
                _sprite = new Bitmap(Assets.getBitmapData("assets/terrain/forest.png"));
                _walkable = false;
            case 2:
                _sprite = new Bitmap(Assets.getBitmapData("assets/terrain/exit.png"));
                _exit = true;
        }

        addChild(_sprite);
    }

    public function onResolve () {
        if (_exit == true) {
            trace("Thanatos went back home !");
            Main.onWon();
        }
    }
}