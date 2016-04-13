package events;

import terrain.GameGrid;
import enums.OrderStatus;
import enums.MessageType;

class LoadMapOrder extends Order {

    public var positionNumber: Int;
    public var grid: GameGrid;

    public function new(status: OrderStatus, grid: GameGrid, positionNumber: Int) {
        this.type = MessageType.LOADMAP;
        this.positionNumber = positionNumber;
        this.grid = grid;
        this.status = status;
    }
}
