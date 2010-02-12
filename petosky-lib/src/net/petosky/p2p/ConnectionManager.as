package net.petosky.p2p {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	/**
	 * @author Cory
	 */
	public class ConnectionManager extends EventDispatcher{
		
		private static const STRATUS_ADDRESS:String = "rtmfp://stratus.adobe.com/2bef1ea68a19aac3b74999c5-65e64b223a7f/";
		
		private var netConnection:NetConnection;
		private var sendStream:NetStream;
		
		private var peers:Vector.<NetStream> = new Vector.<NetStream>();
		
		public function ConnectionManager() {
			netConnection = new NetConnection();
		}
		
		public function initialize():void {
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusListener);
			netConnection.connect(STRATUS_ADDRESS);
		}

		public function get peerID():String {
			return netConnection.nearID;
		}

		public function connect(peer:String):void {
 			var stream:NetStream = new NetStream(netConnection, peer);
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStreamHandler);
			stream.client = sendStream.client;
			stream.play("petosky");
			
			peers.push(stream);
		}
		
		public function send(handler:String, ...args):void {
			sendStream.send(handler, args);
		}
		
		public function get client():Object {
			return sendStream.client; 
		}
		
		public function set client(value:Object):void {
			sendStream.client = value;
			for each (var stream:NetStream in peers)
				stream.client = value;
		}
		
		private function netStatusListener(event:NetStatusEvent):void {
			if (event.info.code == "NetConnection.Connect.Success") {
				trace(netConnection.nearID);

				sendStream = new NetStream(netConnection, NetStream.DIRECT_CONNECTIONS);
				sendStream.addEventListener(NetStatusEvent.NET_STATUS, sendStreamListener);
				sendStream.publish("petosky");
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function sendStreamListener(event:NetStatusEvent):void {
			if (event.info.code == "NetStream.Play.Start") {
				var id:String = sendStream.peerStreams[sendStream.peerStreams.length - 1].farID;
				for each (var stream:NetStream in peers)
					if (stream.farID == id)
						return;
				connect(id);
			}
		}
		
		private function netStreamHandler(event:NetStatusEvent):void {
			dispatchEvent(event);
		}
	}
}
