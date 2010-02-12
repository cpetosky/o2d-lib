package net.petosky.puzzle.display {
	import net.petosky.puzzle.block.BlockGraphics;	
	
	import flash.display.DisplayObject;	
	
	/**
	 * @author Try-Catch
	 */
	public class StandardSelectionTab extends SelectionTab {
		private static const MARGIN:uint = 2;
		
		public function StandardSelectionTab(mainText:String, subText:String, view:String, options:Object, numDefects:uint) {
			super(mainText, subText, view, options);
			
			for (var i:uint = 0; i < numDefects; ++i) {
//				var defect:DisplayObject = new (BlockGraphics.Defect)();
//				defect.x = ((_bg.width - (defect.width * numDefects) - (MARGIN * (numDefects - 1))) >> 1) + (i * defect.width) + ((i - 1) * MARGIN);
//				defect.y = 40;
//				addChild(defect);
			}
		}
	}
}
