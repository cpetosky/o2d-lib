package {

	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLLoader;
	import net.petosky.o2d.Project;
	import net.petosky.o2d.player.IPlayer;	
	import net.petosky.o2d.Map;	
	import net.petosky.o2d.player.View;	
	import net.petosky.o2d.player.Player;	
	
	import flash.display.StageAlign;	
	import flash.display.StageScaleMode;	
	import flash.events.Event;	
	
	import net.petosky.o2d.Game;	
	
	import flash.display.BitmapData;	
	import flash.display.Bitmap;	
	import flash.display.Sprite;	
	
	/**
	 * @author Cory
	 */
	[SWF(frameRate="150",backgroundColor="#FFFFFF")]
	public class Main extends Sprite {
		private static const BASE_URL:String = "http://files.petosky.net/o2d/project.o2d";
		private static const LOCAL_BASE_URL:String = "C:/Users/Cory/Desktop/project.o2d";
		
		private var _output:BitmapData;
		private var _outputHolder:Bitmap;
		private var _game:Game;
		private var _player:IPlayer;
		public var projectURL:String;

		public function Main() {
			trace("Started...");
			addEventListener(Event.ADDED_TO_STAGE, stageListener);
		}
		
		private function stageListener(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageListener);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, resizeListener);
			
			trace(stage.stageWidth, stage.stageHeight);
			if (stage.stageWidth > 0 && stage.stageHeight > 0)
				_output = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
			else
				_output = new BitmapData(1, 1, true, 0);
			_outputHolder = new Bitmap(_output);
			
			addChild(_outputHolder);
			
			if (projectURL == null || projectURL == "")
				projectURL = stage.loaderInfo.url.indexOf("http") >= 0 ? BASE_URL : LOCAL_BASE_URL;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, projectLoadCompleteListener);
			loader.load(new URLRequest(projectURL));
		}
		
		private function projectLoadCompleteListener(event:Event):void {
			var project:Project = Project.load(ByteArray(URLLoader(event.target).data));
			
			_game = new Game(project, _output, stage);
			var map:Map = project.getMap(0);

			_player = new Player(new View(0, 0, _output.width, _output.height, 0, 0),
				project.instantiateEntity(0, map, 15, 15)
			);

			_game.addPlayer(_player);
			
			_player.view.width = _output.width;
			_player.view.height = _output.height;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function resizeListener(event:Event):void {
			trace("New SIZE:", stage.stageWidth, stage.stageHeight);
			_output = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
			removeChild(_outputHolder);
			_outputHolder = new Bitmap(_output);
			addChild(_outputHolder);
			
			if (_game)
				_game.output = _output;
				
			if (_player) {
				_player.view.width = _output.width;
				_player.view.height = _output.height;
			}
		}

		
		
		private function update(event:Event):void {
			_game.update();
		}
	}
}
