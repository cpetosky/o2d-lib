package net.petosky.o2d {

	import nochump.util.zip.ZipOutput;
	import nochump.util.zip.ZipEntry;
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import net.petosky.o2d.script.Script;
	import net.petosky.util.NumberUtils;
	
	import nochump.util.zip.ZipFile;
	
	/**
	 * A Project is the entire collection of assets (maps, images, scripts,
	 * etc.) that comprise a single game. It is the highest level of data
	 * organization within the o2d engine.
	 * 
	 * You cannot directly instantiate a project -- instead, use the static
	 * methods createNew or load.
	 * 
	 * @author Cory
	 */
	public class Project {
		
		private var _name:String;
		
		private var _startingMap:int;
		
		private var _maps:Vector.<Map>;
		private var _palettes:Vector.<Palette>;
		private var _entityGraphics:Vector.<EntityGraphics>;
		private var _scripts:Vector.<Script>;
		
		public function Project(enforcer:FactoryEnforcer) {
			
		}
		
		public function getMap(id:int):Map {
			return _maps[id];
		}
		
		public function getPalette(id:int):Palette {
			return _palettes[id];
		}
		
		public function getScript(id:int):Script {
			return _scripts[id];
		}

		
		
		public function instantiateEntity(id:int, map:Map, x:int, y:int):Entity {
			return new Entity(_entityGraphics[id], map, x, y);
		}
		
		public function save():void {
			var zip:ZipOutput = new ZipOutput();
			
			var metadata:ByteArray = new ByteArray();
			metadata.writeInt(0); // fileversion
			metadata.writeUTF(_name); // name
			metadata.writeInt(_startingMap); // starting map
			metadata.writeInt(0); // starting entitygraphics
			metadata.writeInt(15); // starting entity x
			metadata.writeInt(15); // starting entity y
			
			zip.putNextEntry(new ZipEntry("project"));
			zip.write(metadata);
			zip.closeEntry();
			
			for each (var palette:Palette in _palettes) {
				zip.putNextEntry(new ZipEntry("palettes/" + NumberUtils.pad(palette.id, 5)));
				zip.write(palette.serialize());
				zip.closeEntry();
			}
			
			for each (var map:Map in _maps) {
				zip.putNextEntry(new ZipEntry("maps/" + NumberUtils.pad(map.id, 5)));
				zip.write(map.serialize());
				zip.closeEntry();
			}
			
			for each (var entityGraphics:EntityGraphics in _entityGraphics) {
				zip.putNextEntry(new ZipEntry("entities/" + NumberUtils.pad(entityGraphics.id, 5)));
				zip.write(entityGraphics.serialize());
				zip.closeEntry();
			}
			
			for each (var script:Script in _scripts) {
				var data:ByteArray = new ByteArray();
				data.writeUTFBytes(script.text);
				
				zip.putNextEntry(new ZipEntry("scripts/" + script.name + ".o2s"));
				zip.write(data);
				zip.closeEntry();
			}
			
			zip.finish();
			
			new FileReference().save(zip.byteArray, "project.o2d");
		}
		
		public static function load(bytes:ByteArray):Project {
			var project:Project = new Project(new FactoryEnforcer());
			
			project.load(bytes);
			
			return project;
		}
		
		private function load(bytes:ByteArray):void {
			var zip:ZipFile = new ZipFile(bytes);
			
			var paletteData:Vector.<ByteArray> = new Vector.<ByteArray>;
			var mapData:Vector.<ByteArray> = new Vector.<ByteArray>;
			var entityData:Vector.<ByteArray> = new Vector.<ByteArray>;
			
			_scripts = new Vector.<Script>();

			for each (var entry:ZipEntry in zip.entries) {
				var name:String = entry.name;
				var data:ByteArray = zip.getInput(entry);
				
				if (name == "project") {
					var version:int = data.readInt();
					
					if (version != 0)
						throw new Error("WRONG PROJECT VERSION!");
						
					_name = data.readUTF();
					trace(_name);
					_startingMap = data.readInt();
					
					var startingEntityGraphics:int = data.readInt();
					var startingEntityX:int = data.readInt();
					var startingEntityY:int = data.readInt();
				} else if (name.indexOf("palettes") > -1) {
					paletteData.push(data);		
				} else if (name.indexOf("maps") > -1) {
					mapData.push(data);
				} else if (name.indexOf("entities") > -1) {
					entityData.push(data);
				} else if (name.indexOf(".o2s") > -1) {
					var scriptName:String = name.substring(8, name.length - 4);
					trace(name, scriptName);
					_scripts.push(Script.loadAndParse(scriptName, data.toString()));
				}
			}
			
			_palettes = new Vector.<Palette>(paletteData.length);
			for each (data in paletteData) {
				var palette:Palette = Palette.deserialize(data);
				_palettes[palette.id] = palette;
			}
			
			_maps = new Vector.<Map>(mapData.length);
			for each (data in mapData) {
				var map:Map = Map.deserialize(data, this);
				_maps[map.id] = map;
			}

			_entityGraphics = new Vector.<EntityGraphics>(entityData.length);
			for each (data in entityData) {
				var entity:EntityGraphics = EntityGraphics.deserialize(data);
				_entityGraphics[entity.id] = entity;
			}
		}
		
		public static function create(name:String):Project {
			var project:Project = new Project(new FactoryEnforcer());
			
			project.create(name);
			
			return project;
		}
		
		private function create(name:String):void {
			_name = name;
			
			_palettes = new Vector.<Palette>();
			_palettes.push(Palette.create(0, "Default Palette", new Vector.<TileInfo>()));
			
			_maps = new Vector.<Map>();
			_maps.push(Map.create(0, _palettes[0], 25, 15, "Default Map"));
			
			_startingMap = 0;
			
			_entityGraphics = new Vector.<EntityGraphics>();
			_entityGraphics.push(
				EntityGraphics.create(0, "Default Entity", 32, 48, 4, "", 
					new Vector.<String>(["down, left, right, up"]),
					new BitmapData(128, 192, true, 0xCC00FF00)
				)
			);
			
			_scripts = new Vector.<Script>();
			_scripts.push(new Script("Global", ""));
		}
		
		
		[Bindable]
		public function get maps():Vector.<Map> {
			return _maps;
		}
		
		[Bindable]
		public function get scripts():Vector.<Script> {
			return _scripts;
		}
	}
}

class FactoryEnforcer { }