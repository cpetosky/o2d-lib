package net.petosky.puzzle {
	
	import net.petosky.game.Dialogue;	
	import net.petosky.game.NavigationEvent;	
	import net.petosky.game.TextDisplay;	
	import net.petosky.game.View;
	import net.petosky.puzzle.block.BlockField;	
	import net.petosky.puzzle.display.StatsDisplay;	
	
	import flash.ui.Keyboard;	
	import flash.events.KeyboardEvent;	
	import flash.display.Bitmap;	
	import flash.display.DisplayObject;	
	import flash.events.Event;	

	/**
	 * @author Cory
	 */
	public class GameView extends View {
		private static const BLOCK_SIZE:uint = 32;
		private static const COUNTER_THRESHOLD:Number = 1 / BLOCK_SIZE;
		private static const ROWS:uint = 13;
		private static const COLUMNS:uint = 6;
		private static const BLOCKS_PER_LEVEL:uint = 10;
		
		private var _mode:Mode;
		
		private var _fieldView:Bitmap;
		
		private var _counter:Number = 0;
		private var _stopCounter:int = 0;
		
		private var _blocksRemoved:uint = 0;
		
		private var _blockField:BlockField;

		private var _stats:StatsDisplay;
		
		private var _paused:Boolean = false;
		private var _pauseNotice:Dialogue;

		public function GameView(options:Object) {
			if (options.blockCount == undefined)
				options.blockCount = 5;
			
			_mode = options.mode;
			
			_blockField = new BlockField(COLUMNS, ROWS, BLOCK_SIZE, options.blockCount);
			
			_fieldView = new Bitmap(_blockField);
			_fieldView.x = 0;
			_fieldView.y = 0;
			
			addChild(_fieldView);
									
			_stats = new StatsDisplay(1);
			_stats.x = 12;
			_stats.y = 26;
			addChild(_stats);

			_pauseNotice = new Dialogue(BLOCK_SIZE * (4 + COLUMNS), 80);
			var pauseText:TextDisplay = new TextDisplay(Main.TechFont, 36, BLOCK_SIZE * (4 + COLUMNS), "PAUSED");
			pauseText.x = pauseText.y = 5;
			var pauseText2:TextDisplay = new TextDisplay(Main.TechFont, 18, pauseText.width, "(press p to play)");
			pauseText2.x = pauseText.x;
			pauseText2.y = pauseText.y + pauseText.height;
			_pauseNotice.addChild(pauseText);
			_pauseNotice.addChild(pauseText2);
			
			_pauseNotice.x = (320 - _pauseNotice.width) / 2;
			_pauseNotice.y = (480 - _pauseNotice.height) / 2;
			_pauseNotice.visible = false;
			addChild(_pauseNotice);
			
			addEventListener(Event.ENTER_FRAME, frameListener, false, 0, true);
			addEventListener(Event.ADDED_TO_STAGE, stageListener, false, 0, true);
			_blockField.addEventListener(Event.COMPLETE, stopGameListener, false, 0, true);
		}
		
		private function stopGameListener(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, frameListener);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			dispatchEvent(new NavigationEvent(this, Views.RESULTS, 
				{level: _stats.level, score: _stats.score, mode: _mode}
			));
		}
		
		private function stageListener(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageListener);
			stage.stageFocusRect = false;
			stage.focus = this;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true);
		}
		
		private function keyDownListener(event:KeyboardEvent):void {
			if (!_paused) {
				switch (event.keyCode) {
					case Keyboard.LEFT:
						--_blockField.cursorColumn;
					break;
					
					case Keyboard.RIGHT:
						++_blockField.cursorColumn;
					break;
					
					case Keyboard.UP:
						--_blockField.cursorRow;
					break;
					
					case Keyboard.DOWN:
						++_blockField.cursorRow;
					break;
					
					case Keyboard.SPACE:
						_blockField.swapBlocks();
					break;
					
					case Keyboard.CONTROL:
						_blockField.riseRow();
						_stats.score += _stats.level;
						break;
				}
			}
			
			switch (event.charCode) {
				case "p".charCodeAt():
				case "P".charCodeAt():
					_paused = !_paused;
					_pauseNotice.visible = !_pauseNotice.visible;
				break;	
			}
		}

		private function frameListener(event:Event):void {
			if (!_paused) {
				var delta:uint = 1000 / stage.frameRate;
				
				// Handle stop counter
				if (_stopCounter > 0) 
					_stopCounter = Math.max(_stopCounter - delta, 0);
	
				if (_stopCounter == 0 && !_blockField.removing) {			
					// Handle field motion
					_counter += (_stats.rate / stage.frameRate);
					while (_counter > COUNTER_THRESHOLD) {
						_counter -= (COUNTER_THRESHOLD);
						_blockField.rise();
					}
				}
	
				// Mark and count matches
				var matchCount:uint = _blockField.markMatches();
				_stopCounter += 200 * matchCount;
				_blocksRemoved += matchCount;
				_stats.level = _blocksRemoved / BLOCKS_PER_LEVEL + 1;
				
				// TODO: Remove this line and do as blocks blow up
				_stats.score += matchCount * 10;
				
				if (matchCount > 3)
					_stats.score += (matchCount - 3) * (matchCount - 3) * 20;
	
				// Remove blocks and drop floating blocks
				_blockField.processMatches(delta);
			}

			// Draw
			_blockField.render();
			
			if (_paused)
				_blockField.renderPauseNotice();
			
		}
	}
}
