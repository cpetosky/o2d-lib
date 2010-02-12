package net.petosky.o2d.editor {
	import flash.utils.ByteArray;
	import flash.net.FileFilter;
	import net.petosky.o2d.Project;
	
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	
	import net.petosky.o2d.Game;
	
	public final class SaveLoadManager extends EventDispatcher {
		public static const SAVE_FAILED:String = "saveFailed";
		
		private var _keyboardEventSource:InteractiveObject;
		private var _saveFile:File;
						
		private var _sharedObject:SharedObject;
		private var _lastDirectory:File;

		private var _project:Project;
		
		public function SaveLoadManager(keyboardEventSource:InteractiveObject) {
			_keyboardEventSource = keyboardEventSource;
			
			_sharedObject = SharedObject.getLocal("editor");
			if (_sharedObject.data.lastDirectoryOpened)
				_lastDirectory = new File(_sharedObject.data.lastDirectoryOpened);
			else
				_lastDirectory = File.userDirectory;
		}
		
		public function newProject():void {
			_project = Project.create("Test");
			var game:Game = new Game(_project, new BitmapData(1, 1), _keyboardEventSource);
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE, game));
		}
		
		
		
		public function save():void {
			_project.save();
//			if (!_saveFile) {
//				saveAs();
//				return;
//			}
//
//			var fileStream:FileStream = new FileStream();
//			fileStream.open(_saveFile, FileMode.WRITE);
//
//			fileStream.close();
		}


		
		public function saveAs():void {
			try {
				_lastDirectory.addEventListener(Event.SELECT, saveFileSelectedListener);
				_lastDirectory.browseForSave("Save world");
			} catch (error:Error) {
				dispatchEvent(new ErrorEvent(SAVE_FAILED, false, false, error.message));
			}			
		}


		


		private function saveFileSelectedListener(event:Event):void {
			_saveFile = File(event.target);
			_saveFile.removeEventListener(Event.SELECT, saveFileSelectedListener);
			
			if (_saveFile.nativePath.substr(-6) != ".world")
				_saveFile.nativePath += ".world";
			
			_lastDirectory = _saveFile.parent;
			saveLastDirectory();
			save();
		}
		
		private function saveLastDirectory():void {
			_sharedObject.data.lastDirectoryOpened = _lastDirectory.url;
			_sharedObject.flush();
		}
		
		
		
		public function load():void {
			try {
				_lastDirectory.browseForOpen("Choose o2d project zip", [new FileFilter("o2d projects", "*.o2d")]);
				_lastDirectory.addEventListener(Event.SELECT, loadProjectSelectedListener);
			} catch (error:Error) {
				dispatchEvent(new LoadEvent("Error while loading: " + error.message));
			}
		}
		
		
		private function loadProjectSelectedListener(event:Event):void {
			var file:File = File(event.target);
			file.removeEventListener(Event.SELECT, loadProjectSelectedListener);
			
			loadURL(file.url);
		}

		public function loadURL(url:String):void {
			var file:File = new File(url);

			trace("File selected:", file.url);
			
			_saveFile = file;
			_lastDirectory = _saveFile.parent;
			saveLastDirectory();
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			var bytes:ByteArray = new ByteArray();
			fileStream.readBytes(bytes);
			fileStream.close();
			
			_project = Project.load(bytes);
			
			var game:Game = new Game(_project, new BitmapData(1, 1), _keyboardEventSource);
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE, game));
		}
	}
}