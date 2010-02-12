package net.petosky.game {
	import flash.display.DisplayObjectContainer;	
	import flash.display.DisplayObject;	
	
	/**
	 * @author Cory
	 */
	public class ViewManager {
		private var _views:Object;
		private var _currentView:View;
		private var _container:DisplayObjectContainer;

		public function ViewManager(container:DisplayObjectContainer) {
			_views = {};
			_container = container;
		}
		
		public function registerViewClass(id:String, klass:Class):void {
			_views[id] = klass;
		}

		public function changeView(id:String, options:Object = null):void {
			if (_currentView) {
				var oldView:View = _currentView;
				_currentView = new _views[id](options);
				
				oldView.addEventListener(ViewEvent.HIDDEN, viewHiddenListener);
				oldView.hide();
			} else {
				_currentView = new _views[id](options);
				viewHiddenListener();
			}
		}
		
		private function viewHiddenListener(event:ViewEvent = null):void {
			if (event)
				_container.removeChild(event.currentTarget as DisplayObject);
			_container.addChild(_currentView);
		}
		
		public function get view():View {
			return _currentView;
		}
	}
}
