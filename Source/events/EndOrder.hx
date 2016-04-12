package events;
import enums.MessageType;
import enums.OrderStatus;
class EndOrder extends Order {

    public var message: String;

    public function new(_status: OrderStatus, _type: MessageType, _message: String) {
        type = _type;
        status = _status;
        message = _message;
    }
}
