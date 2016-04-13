package ;

class GameSettings {
    public static inline var APP_PORT:Int = 8000;
    public static inline var WEB_SOCKET_PORT:Int = 8128;
    public static inline var ENDSTRING: String = "#end#";
    public static var cellSize: Int = 32; // the cell size in pixels
    public static var serverAddress: String = "ws://bew.ink:" + WEB_SOCKET_PORT;
    public static var mapNb: Int = 5; // number of levels for each game
    public static var mapWidth: Int = 10; // width of levels in cells
    public static var mapHeight: Int = 10; // height of levels in cells
    public static var playerNbToStart: Int = 2; // number of player needed to start a game
}
