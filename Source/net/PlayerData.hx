package net;

class PlayerData {
    public var identity: PlayerIdentity;
    public var proxy: PlayerProxy;

    public function new(identity: PlayerIdentity, proxy: PlayerProxy) {
        this.identity = identity;
        this.proxy = proxy;
    }
}
