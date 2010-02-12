package net.petosky.game {

	/**
	 * @author Cory
	 */
	public class NavigationManager {
		private var _viewManager:ViewManager;

		public function NavigationManager(viewManager:ViewManager) {
			_viewManager = viewManager;
		}
		
		public function navigateTo(id:String, options:Object = null):void {
			navigationListener(new NavigationEvent(null, id, options));
		}
		
		public function register(view:View):void {
			view.addEventListener(NavigationEvent.NAVIGATE, navigationListener);
		}
		
		private function navigationListener(event:NavigationEvent):void {
			event.stopPropagation();
			_viewManager.changeView(event.destinationID, event.options);
			register(_viewManager.view);
		}
	}
}
