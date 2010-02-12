package net.petosky.game {
	import flash.text.GridFitType;	
	import flash.text.TextFieldType;	
	import flash.text.AntiAliasType;	
	import flash.text.TextFormatAlign;	
	import flash.text.TextFormat;	
	import flash.text.TextField;	
	/**
	 * @author Cory
	 */
	public class TextDisplay extends TextField {
		public function TextDisplay(
			font:String,
			fontSize:uint,
			width:uint,
			contents:String = "",
			align:String = TextFormatAlign.CENTER
		) {
			super();
			
			var tf:TextFormat = new TextFormat(font, fontSize);
			tf.align = align;
			
			defaultTextFormat = tf;

			text = contents;
			
			antiAliasType = AntiAliasType.ADVANCED;
			type = TextFieldType.DYNAMIC;
			gridFitType = GridFitType.PIXEL;
			
			embedFonts = true;
			selectable = false;
			
			this.width = width;
		}
		
		override public function set text(value:String):void {
			super.text = value;
			height = textHeight;
		}
	}
}
