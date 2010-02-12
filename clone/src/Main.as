package {
	import com.kongregate.as3.client.events.KongregateEvent;	
	import com.kongregate.as3.client.KongregateAPI;
	
	import flash.events.Event;	
	
	import net.petosky.puzzle.Session;	
	import net.petosky.puzzle.ResultsView;	
	import net.petosky.puzzle.GameView;	
	import net.petosky.puzzle.MenuView;	
	import net.petosky.puzzle.Views;	
	import net.petosky.game.ViewManager;	
	import net.petosky.game.NavigationManager;	
	
	import flash.display.Sprite;	
	
	/**
	 * @author Cory
	 */
	[SWF(width="320", height="480", frameRate="30", backgroundColor="0x000000")]
	public class Main extends Sprite {
		private var _viewManager:ViewManager; 
		private var _navigationManager:NavigationManager;

		[Embed(source="/../fonts/ltromatic.ttf", fontName="Main_TechFont", mimeType="application/x-font-truetype", unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E")]
		public static var TechFont:String;
		
		public function Main() {
			addEventListener(Event.ADDED_TO_STAGE, stageListener);
		}
		
		private function stageListener(event:Event):void {
			var km:KongregateAPI = new KongregateAPI();
			km.addEventListener(KongregateEvent.COMPLETE, kongComplete);
			addChild(km);
		}
		
		private function kongComplete(event:Event):void {
			_viewManager = new ViewManager(this);
			_viewManager.registerViewClass(Views.MENU, MenuView);
			_viewManager.registerViewClass(Views.GAME, GameView);
			_viewManager.registerViewClass(Views.RESULTS, ResultsView);
			
			// Initialize session
			Session.instance;
			
			_navigationManager = new NavigationManager(_viewManager);
			
			_navigationManager.navigateTo(Views.MENU);
		}
	}
}
