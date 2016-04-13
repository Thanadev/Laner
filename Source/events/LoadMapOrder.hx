package events;

import terrain.GameGrid;
import enums.OrderStatus;
import enums.MessageType;

class LoadMapOrder extends Order {

    public var positionNumber: Int;
    public var grid: GameGrid;

    public function new(status: OrderStatus, _grid: GameGrid, _positionNumber: Int) {
        type = MessageType.LOADMAP;
        positionNumber = _positionNumber;
        grid = _grid;
    }
}
