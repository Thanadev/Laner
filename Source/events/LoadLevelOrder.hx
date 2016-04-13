package events;

import enums.MessageType;
import enums.OrderStatus;

class LoadLevelOrder extends Order {

    public var message: String;
    public var level: Int;

    public function new(status: OrderStatus, type: MessageType, message: String, level: Int) {
        this.type = type;
        this.status = status;
        this.message = message;
        this.level = level;
    }
}
