package net.petosky.puzzle.display {
	import net.petosky.game.NavigationEvent;	
	
	import flash.events.MouseEvent;	
	
	import net.petosky.game.TextDisplay;	
	
	import flash.display.Sprite;	
	import flash.display.DisplayObject;	
	
	/**
	 * @author Try-Catch
	 */
	public class SelectionTab extends Sprite {

		[Embed(source="/../gfx/selection_tab.png")]
		private static var Background:Class;
		
		protected var _bg:DisplayObject;
		
		private var _view:String;
		private var _options:Object;
		
		public function SelectionTab(mainText:String, subText:String, view:String, options:Object) {
			_view = view;
			_options = options;
			_bg = new Background();
			addChild(_bg);
			
			var t:TextDisplay = new TextDisplay(Main.TechFont, 18, _bg.width, mainText);
			t.y = 5;
			addChild(t);
			
			t = new TextDisplay(Main.TechFont, 14, _bg.width, subText);
			t.y = 24;
			addChild(t);
			
			addEventListener(MouseEvent.CLICK, clickListener, false, 0, true);
		}
		
		private function clickListener(event:MouseEvent):void {
			dispatchEvent(new NavigationEvent(null, _view, _options));
		}
	}
}
