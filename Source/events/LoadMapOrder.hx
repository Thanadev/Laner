package events;

import terrain.GameGrid;
import enums.OrderStatus;
import enums.OrderType;

class LoadMapOrder extends ServerOrder {

    public var grid: GameGrid;

    public function new(status: OrderStatus, _grid: GameGrid) {
        type = OrderType.LOADMAP;
        this.grid = _grid;
    }
}
