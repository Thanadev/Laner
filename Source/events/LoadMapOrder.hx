package events;

import terrain.GameGrid;
import enums.OrderStatus;
import enums.MessageType;

class LoadMapOrder extends Order {

    public var grid: GameGrid;

    public function new(status: OrderStatus, _grid: GameGrid) {
        type = MessageType.LOADMAP;
        this.grid = _grid;
    }
}
