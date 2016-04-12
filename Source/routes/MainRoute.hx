package routes;

import nodejs.express.ExpressResponse;
import nodejs.express.ExpressRequest;

class MainRoute extends Route {
    public function new( ) {
        super(_sucessHandler);
    }

    private function _sucessHandler(request:ExpressRequest,response:ExpressResponse):Void{
        trace('Play!');
        response.send('Coucou !');
    }
}
