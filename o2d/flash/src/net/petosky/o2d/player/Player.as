package net.petosky.o2d.player {
	import net.petosky.o2d.script.ScriptableObject;	
	import net.petosky.o2d.Map;	
	import net.petosky.o2d.Entity;	
	import net.petosky.geom.GridPoint;	
	
	import flash.display.BitmapData;
	
	/**
	 * @author Cory
	 */
	public class Player extends ScriptableObject implements IPlayer {
		private static const VERTICAL_THRESHOLD:int = 160;
		private static const HORIZONTAL_THRESHOLD:int = 200;

		private var _avatar:Entity;
		private var _view:View;

		private var _lastPosition:GridPoint;

		//		private var actions:Dictionary = new Dictionary(); // Dictionary<Buttons, Action>
//		private var items:Vector.<Item> = new Vector.<Item>();
//		private var interfaceElements:Vector.<InterfaceElement> = new Vector.<InterfaceElement>();

		public function Player(view:View, avatar:Entity) {
			super("player");
			addScriptProperty("avatar");
			
			_view = view;
			_avatar = avatar;
			_lastPosition = new GridPoint(avatar.x, avatar.y);
//			lastState = GamePad.GetState(index);

//			items.Add(new SprintShoes(this));
//			items.Add(new Rucksack(this));
//
//			interfaceElements.Add(new ButtonLegend(this));
			prepareActions();
		}

		private function prepareActions():void {
//			foreach (Item item in items)
//				foreach (Action action in item.Actions)
//					actions[action.Buttons] = action;
		}
		


		public function scroll():void {
			// Handle scrolling
			var move:int = _avatar.y - _lastPosition.y;

			// Scroll up, if necessary	
			if ((move < 0) && (_avatar.y - view.y < VERTICAL_THRESHOLD) && (view.y + move >= 0))
				view.y += move;

			// Scroll down, if necessary
			if ((move > 0) && ((view.y + view.height) - (_avatar.y + _avatar.height) < VERTICAL_THRESHOLD) &&
					(view.y + move < _avatar.map.pixelHeight - view.height))
				view.y += move;

			move = _avatar.x - _lastPosition.x;

			// Scroll left, if necessary
			if ((move < 0) && (_avatar.x - view.x < HORIZONTAL_THRESHOLD) && (view.x + move >= 0))
				view.x += move;

			// Scroll right, if necessary
			if ((move > 0) && ((view.x + view.width) - (_avatar.x + _avatar.width) < HORIZONTAL_THRESHOLD) &&
				(view.x + move < _avatar.map.pixelWidth - view.width))
				view.x += move;

			_lastPosition.x = _avatar.x;
			_lastPosition.y = _avatar.y;
		}

		public function renderView(output:BitmapData):void {
			_avatar.map.render(output, _view);

//			foreach (InterfaceElement element in interfaceElements)
//				element.Render(spriteBatch);
		}

		public function get avatar():Entity {
			return _avatar;
		}

		public function get view():View {
			return _view;
		}
		
		public function get map():Map {
			return _avatar.map;
		}

//		public function AddInterfaceElement(InterfaceElement element):void {
//			interfaceElements.Add(element);
//		}
//
//		public function RemoveInterfaceElement(InterfaceElement element):void {
//			interfaceElements.Remove(element);
//		}
//
//		public Action this[Buttons button] {
//			get {
//				if (actions.ContainsKey(button))
//					return actions[button];
//				else
//					return null;
//			}
//		}
 	}
}

