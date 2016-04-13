package events;

import terrain.GameGrid;
import enums.OrderStatus;
import enums.MessageType;

class LoadMapOrder extends Order {

    public var positionNumber;
    public var grid: GameGrid;

    public function new(status: OrderStatus, _grid: GameGrid, _positionNumber) {
        type = MessageType.LOADMAP;
        positionNumber = _positionNumber;
        grid = _grid;
    }
}
