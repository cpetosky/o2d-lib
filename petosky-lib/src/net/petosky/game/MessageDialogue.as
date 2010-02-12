package net.petosky.game {

	/**
	 * @author Cory
	 */
	public class MessageDialogue extends Dialogue {
		public function MessageDialogue(
			font:String,
			fontSize:uint,
			message:String,
			backgroundColor:uint = 0xFFFFFF,
			borderThickness:uint = 5,
			borderColor:uint = 0
		) {
			var text:TextDisplay = new TextDisplay(font, fontSize, 1000, message);
			text.width = text.textWidth + 5;
			text.x = 5;
			text.y = 5;
			super(text.width + 10, text.height + 10, backgroundColor, borderThickness, borderColor);
			addChild(text);
		}
	}
}
