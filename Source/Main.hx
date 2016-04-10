package;

import net.ServerOrder;
import terrain.GameGrid;
import openfl.display.Stage;
import openfl.display.Sprite;

class Main extends Sprite {
	public static var _stage: Stage;

	private static var instance: Main;

	private var server: Server;
	private var _level: Int;
	private var grid: GameGrid;
	private var player: Player;

	public function new () {
		server = new Server();
		grid = server.sendMapToClients();

		super();
		instance = this;
		_stage = this.stage;
		_level = 0;
		startLevel(_level);
	}

	private function startLevel (level: Int) {
		trace("Starting level " + _level);
		grid.loadLevel(level);
        player = Player.getInstance(server.requestIdentityHandler(), grid.playerPos);
		addChild(grid);
		grid.x = (stage.stageWidth - (10 - 1) * GameSettings.cellSize) /2;
		grid.y = (stage.stageHeight - (10 - 1) * GameSettings.cellSize) /2;
		addChild(player);
		player.x = (stage.stageWidth - (10 - 1) * GameSettings.cellSize) /2;
		player.y = (stage.stageHeight - (10 - 1) * GameSettings.cellSize) /2;
	}

	public static function onWon () {
		instance.removeChildren();
		instance.startLevel(++instance._level);
	}

	private function serverOrderHandler (order: ServerOrder) {

	}

	public function gameFinished () {
	}
}