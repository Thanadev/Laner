package terrain;

import terrain.GameGrid.GridPosition;

class GameCell {

    public var _id:Int;
    public var _position:GridPosition;
    public var _walkable:Bool;
    public var _exit:Bool;

    public function new (id: Int, x: Int, y: Int) {
        _id = id;
        _position = {x: x, y: y};
        _walkable = true;
        if (id == 1) {
            _walkable = false;
        } else if (id == 2) {
            _exit = true;
        }
    }

    public function onResolve (player: Float) {
        var ret = false;

        if (_exit == true) {
            trace("Thanatos went back home!");
            ret = true;
        }

        return ret;
    }
}