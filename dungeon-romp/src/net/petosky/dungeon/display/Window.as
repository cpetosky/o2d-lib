package net.petosky.dungeon.display {
	import net.petosky.metaplay.RenderableContainer;	
	import net.petosky.metaplay.RenderableSprite;	
	
	import flash.geom.Point;	
	import flash.display.BitmapData;	
	
	import flash.events.MouseEvent;	
	import flash.events.Event;	
	import flash.text.TextFieldType;	
	import flash.display.DisplayObject;	
	
	import net.petosky.dungeon.display.TextFactory;
	import flash.text.TextField;	
	import flash.display.Sprite;

	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import net.petosky.bitmap.convertSpriteToBitmapData;	
	
	/**
	 * @author Cory Petosky
	 */
	public class Window extends RenderableContainer {
		public static const INPUT_COMPLETE:String = "inputComplete";
		
		private var _nominalWidth:int;
		private var _nominalHeight:int;
		
		private var _border:Boolean;
		
		private var _backgroundColor:uint = 0x000000;
		private var _backgroundAlpha:Number = 1.0;
		
		private var _message:DisplayObject;
		private var _messageTimeout:uint;
		
		private var _inputField:TextField;
		
		private var _input:String;
		
		private var _sprite:RenderableSprite = new RenderableSprite();

		public function Window(width:int = 0, height:int = 0, border:Boolean = true) {
			super(width, height);
			_nominalWidth = width;
			_nominalHeight = height;
			_border = border;
			
			attach(_sprite);
			redraw();
		}
		
		public function get sprite():Sprite {
			return _sprite.sprite;
		}

		
		
		public function redraw():void {
			sprite.graphics.clear();
			
			var w:int = _nominalWidth ? _nominalWidth : (_border ? sprite.width + 10 : sprite.width);
			var h:int = _nominalHeight ? _nominalHeight : (_border ? sprite.height + 10 : sprite.height);

			with (sprite.graphics) {
				beginFill(_backgroundColor, _backgroundAlpha);

				if (_border) {
					lineStyle(2, 0xFFFFFFFF);
					drawRoundRect(2, 2, w, h, 5, 5);
				} else {
					drawRect(0, 0, w, h);
				}
				endFill();
			}
		}
		
		public function showMessage(message:String, duration:int = 1000):void {
			removeMessage();
			
			var field:TextField = TextFactory.instance.createTextField(message);
			field.text = message;
			field.x = field.y = 5;
			field.width = (_nominalWidth ? _nominalWidth : sprite.width) - 10;
			field.height = (_nominalHeight ? _nominalHeight : sprite.height) - 10;
			field.wordWrap = true;
			
			sprite.addChild(field);
			_message = field;
			
			if (duration > 0)
				_messageTimeout = setTimeout(removeMessage, duration);			
		}
		
		
		public function showPopupMessage(message:String, duration:int = 1000):void {
			removeMessage();
			
			var field:TextField = TextFactory.instance.createTextField(message);
			field.text = message;
			field.x = field.y = 5;
			
			var subwindow:Window = new Window(field.width + 10, field.height + 10);
			subwindow.x = (_nominalWidth - field.width) >> 1;
			subwindow.y = (_nominalHeight - field.height) >> 1;

			subwindow.sprite.addChild(field);
			sprite.addChild(subwindow.sprite);
			
			_message = subwindow.sprite;
			
			if (duration > 0)
				_messageTimeout = setTimeout(removeMessage, duration);
		}
		
		public function showInputPopupMessage(message:String):void {
			removeMessage();
			
			var field:TextField = TextFactory.instance.createTextField(message);
			field.text = message;
			field.x = field.y = 5;
			
			_inputField = TextFactory.instance.createTextField("", field.width - 35);
			_inputField.name = "input";
			_inputField.type = TextFieldType.INPUT;
			_inputField.y = field.y + field.height + 5;
			_inputField.x = 5;
			_inputField.border = true;
			_inputField.borderColor = 0xFFFFFFFF;
			
			var submit:Sprite = new Sprite();
			with (submit.graphics) {
				lineStyle(2, 0xAAFFAA);
				beginFill(0x77FF77);
				drawRoundRect(0, 0, 30, _inputField.height, 5, 5);
				endFill();
			}
			
			submit.x = 5 + _inputField.x + _inputField.width;
			submit.y = _inputField.y;
			
			submit.addEventListener(MouseEvent.CLICK, inputListener);
			
			var subwindow:Window = new Window(field.width + 10, field.height + _inputField.height + 15);
			subwindow.x = (_nominalWidth - field.width) >> 1;
			subwindow.y = (_nominalHeight - field.height) >> 1;

			subwindow.sprite.addChild(field);
			subwindow.sprite.addChild(_inputField);
			subwindow.sprite.addChild(submit);
			
			sprite.addChild(subwindow.sprite);
			
			_message = subwindow.sprite;
			if (subwindow.sprite.stage)
				subwindow.sprite.stage.focus = _inputField;			
		}
		
		private function inputListener(event:MouseEvent):void {
			_input = _inputField.text;
			removeMessage();
			dispatchEvent(new Event(INPUT_COMPLETE));
		}

		
		
		public function removeMessage():void {
			if (_message)  {
//				if (stage && stage.focus == _message)
//					stage.focus = stage;
				
				sprite.removeChild(_message);
				_message = null;
			}
			clearTimeout(_messageTimeout);
		}
		
		
		
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			_backgroundAlpha = (value >>> 24) / 0xFF;
			redraw();
		}
		
		
		
		public function get nominalWidth():int {
			return _nominalWidth;
		}
		
		
		
		public function get nominalHeight():int {
			return _nominalHeight;
		}
		
		override public function get width():int {
			return _sprite.width;
		}
		
		override public function set width(value:int):void {
			_sprite.width = value;
		}
		
		override public function get height():int {
			return _sprite.height;
		}
		
		override public function set height(value:int):void {
			_sprite.height = value;
		}
		
		
		
		public function get input():String {
			return _input;
		}
		
		
		
		override public function draw(target:BitmapData, destPoint:Point):void {
			var source:BitmapData = convertSpriteToBitmapData(sprite);
			target.copyPixels(source, source.rect, destPoint);
		}
	}
}
