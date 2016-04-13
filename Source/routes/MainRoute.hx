package routes;

import nodejs.NodeJS;
import nodejs.Path;
import nodejs.express.ExpressResponse;
import nodejs.express.ExpressRequest;

class MainRoute extends Route {
    public function new( ) {
        super(_sucessHandler);
    }

    private function _sucessHandler(request:ExpressRequest,response:ExpressResponse):Void{
        var path:Path = NodeJS.require('path');

        trace('Main route loaded');
        response.sendfile(path.resolve(GameSettings.serverAddress + '/index.html'));
    }
}
