package {
	import flash.geom.Matrix;	
	import flash.geom.ColorTransform;	
	import flash.text.TextFormat;	
	import flash.text.TextField;	
	import flash.geom.Rectangle;	
	import flash.display.BitmapData;	
	import flash.display.Bitmap;	
	import flash.display.Sprite;	
	
	/**
	 * @author Cory Petosky
	 */
	[SWF(width="800", height="600", backgroundColor="#000000", frameRate="30")]
	dynamic public class g extends Sprite {

//		private var NORTH:uint = 0x01;
//		private var EAST:uint = 0x02;
//		private var SOUTH:uint = 0x04;
//		private var WEST:uint = 0x08;
//		private var ALL:uint = 0x0F;
//		private var VISITED:int = 0x10;
//
//		private var px:int;
//		private var py:int;
//		private var sx:int;
//		private var sy:int;
//		private var sk:Boolean;

//		private var dir:int = 0x01;
//		private var dirs:Array;
		
//		private var maze:Array;
		
//		private var fpv:Sprite = new Sprite();
//		private var maph:Bitmap;
//		private var map:BitmapData = new BitmapData(320, 320, false, 0xFF700000);
//		
//		private var floor:int;
//		
//		// battle
//		private var ehp:int;
//		private var estr:int;
//		private var edef:int;
//
//		private var rchance:Number;
//		
//		private var bchance:Number = 0.07;
//		private var battle:Boolean = false;
//		private var defending:Boolean = false;
//		
//		// character
//		private var hp:int;
//		private var mhp:int;
//		
//		private var str:int;
//		private var def:int;
//		private var xp:int;
//		private var xpn:int;
//		private var level:int;
//
//		
//		// display stats
//		private var tl:Array;
//		private var d_stats:TextField;
//		private var d_text:TextField;
//		private var bgc:uint;

		public function g() {
			this.dir = 0x01;
			this.fpv = new Sprite();
			this.map = new BitmapData(320, 320);
			this.bchance = 0.07;
			this.battle = this.defending = false;
			this.bgc = 0;
			this.tl = [];
			var tf:TextFormat = new TextFormat("Courier New", 20, 0xFFFFFFFF);

			this.newChar = function():void {
				this.tl.push("Gain levels, find stairs down, how deep can you get?");
				this.mhp = this.hp = 10 + int(Math.random() * 10);
				this.str = 8 + int(Math.random() * 8);
				this.def = 8 + int(Math.random() * 8);
				
				this.level = 1;
				this.xp = 0;
				this.xpn = 100;
				
				this.floor = 0;
				this.newFloor();
			};
			
			this.newFloor = function():void {
				this.floor++;
				randomFloor();
				
				this.wa = new BitmapData(32, 16);
				this.wa.perlinNoise(32, 16, 16, Math.random() * 1000000, true, true, 1 + Math.random() * 7);
				
				
				do {
					this.px = int(Math.random() * 20);
					this.py = int(Math.random() * 20);
				} while (this.maze[this.px][this.py] == 0);
				
				this.maze[this.px][this.py] |= 0x10;
				
				do {
					this.sx = int(Math.random() * 20);
					this.sy = int(Math.random() * 20);
				} while (this.maze[this.sx][this.sy] == 0);
				
				this.sk = false;
			};
			
			// setup dirs right->down->left
			this.dirs = [];
			this.dirs[0x01] = [0x02, 0x04, 0x08];
			this.dirs[0x02] = [0x04, 0x08, 0x01];
			this.dirs[0x04] = [0x08, 0x01, 0x02];
			this.dirs[0x08] = [0x01, 0x02, 0x04];
		
			this.d_stats = new TextField();
			this.d_stats.defaultTextFormat = tf;
			this.d_stats.x = 10;
			this.d_stats.y = 325;
			this.d_stats.width = 780;
			this.d_stats.selectable = false;
			addChild(this.d_stats);
			
			this.d_text = new TextField();
			this.d_text.defaultTextFormat = tf;
			this.d_text.x = 10;
			this.d_text.width = 780;
			this.d_text.y = 395;
			this.d_text.height = 205;
			this.d_text.selectable = false;
			this.d_text.background = true;
			this.d_text.border = true;
			this.d_text.borderColor = 0xFFFFFFFF;
			addChild(this.d_text);
			
			this.newChar();
			this.fpv.scrollRect = new Rectangle(0, 0, 480, 320);
			addChild(this.fpv);
			
			this.maph = new Bitmap(this.map);
			this.maph.x = 480;
			addChild(this.maph);
			
			addEventListener("enterFrame", efl);
			

		}
		
		private function kl(event):void  {
			if (this.battle) {
				if (event.keyCode == 65) {
					var dmg:int = (1 + Math.random() * 10) + this.str - this.edef - (1 + Math.random() * 10);
					if (dmg < 1)
						dmg = Math.random() * 2;
					
					if (dmg < 1)
						this.tl.push("You miss.");
					else {
						this.tl.push("You attack for " + dmg + ".");
						this.ehp -= dmg;
					}
					
					if (this.ehp < 1) {
						this.tl.push("You win!");
						this.battle = false;
						this.tl.push("Gained " + 10 * this.floor + " XP.");
						this.xp += 10 * this.floor;
						while (this.xp >= this.xpn) {
							this.level++;
							this.tl.push("Welcome to level " + this.level + "!");
							var gain:int = 1 + Math.random() * 5;
							this.tl.push("Gained " + gain + " HP.");
							this.mhp += gain;
							this.hp += gain;
							
							gain = 1 + Math.random() * 4;
							this.tl.push("Gained " + gain + " STR.");
							this.str += gain;
							
							gain = 1 + Math.random() * 4;
							this.tl.push("Gained " + gain + " DEF.");
							this.def += gain;
							
							this.xpn = int(this.xpn * 2.1);
						}
					} else {
						enemyTurn();
					}
					
				} else if (event.keyCode == 72) {
					this.tl.push("You begin mending...");
					this.defending = true;
					enemyTurn();
					
				} else if (event.keyCode == 82) {
					if (Math.random() < this.rchance) {
						this.tl.push("You run away!");
						this.battle = false;
					} else {
						this.rchance *= 1.25; // make it easier on successive attempts
						this.tl.push("You couldn't run away...");
						enemyTurn();
					}					
				}
			} else {
				if (event.keyCode == 38) {
					if (this.maze[this.px][this.py] & this.dir) {
						move(this.dir);
						this.maze[this.px][this.py] |= 0x10;
						
						if (this.sx == this.px && this.sy == this.py) {
							this.tl.push("Stairs down. You can (d)escend.");
							this.sk = true;
						} else {
							checkBattle();
						}
					}
				
				} else if (event.keyCode == 39) {
					this.dir = this.dirs[this.dir][0];

				} else if (event.keyCode == 40) {
					if (this.maze[this.px][this.py] & this.dirs[this.dir][1]) {
						move(this.dirs[this.dir][1]);
						this.maze[this.px][this.py] |= 0x10;
						
						if (this.sx == this.px && this.sy == this.py) {
							this.tl.push("Stairs down. You can (d)escend.");
							this.sk = true;
						} else {
							checkBattle();
						}
						
					}
					
				} else if (event.keyCode == 37) {
					this.dir = this.dirs[this.dir][2];
				} else if (event.keyCode == 68) {
					if (this.sx == this.px && this.sy == this.py) {
						this.newFloor();
						this.tl.push("Welcome to floor " + this.floor + ".");
					} else {
						this.tl.push("No stairs to (d)escend.");
					}
				}
			}
		}
		
		private function enemyTurn():void {
			var dmg:int = (1 + Math.random() * 10) + this.estr - this.def - (1 + Math.random() * 10);
			
			// 1.5x when defending!
			if (this.defending)
				dmg -= (this.def + (1 + Math.random() * 10) >> 1);
			
			if (dmg < 1 && Math.random() * 2 < 1)
				dmg = 1;
			
			if (dmg < 1) {
				if (this.defending) {
					if (dmg < this.hp - this.mhp)
						dmg = this.hp - this.mhp;
					this.tl.push("You defend yourself and mend for " + -dmg + ".");
					this.hp -= dmg;
				} else {
					this.tl.push("Enemy misses.");
				}	
			} else {
				this.tl.push("Enemy hits you for " + dmg);	
				this.hp -= dmg;
			}

			this.defending = false;
			
			if (this.hp < 1) {
				this.d_text.text = "";
				this.tl.push("You lose...");
				this.tl.push("You got to floor " + this.floor + " as a level " + this.level + " hero.");
				this.tl.push("Restarting game...");
				this.battle = false;
				this.newChar();
			} else {
				this.tl.push("(A)ttack, (H)eal, (R)un?");				
			}
		}
		
		private function checkBattle():void {
			if (Math.random() < this.bchance) {
				// battle start
				this.battle = true;
				this.bchance = 0.07;
				this.rchance = 0.25;
				this.bgc = 0xFFFFFFFF;
				this.ehp = (3 + Math.random() * 10) * this.floor;
				this.estr = (3 + Math.random() * 8) * this.floor;
				this.edef = (3 + Math.random() * 8) * this.floor;
				
				this.tl.push("Enemy!");
				this.tl.push("(A)ttack, (H)eal, (R)un?");
			} else {
				this.bchance *= 1.01;
			}
		}
		
		private function move(dir:uint):void {
			if (dir == 0x01)
				this.py--;
			else if (dir == 0x02)
				this.px++;
			else if (dir == 0x04)
				this.py++;
			else
				this.px--;
		}
		
		private function efl(event):void {
			stage.addEventListener("keyDown", kl);
			if (this.tl[0]) {
				this.d_text.appendText(this.tl[0] + "\n");
				while (this.d_text.numLines > 9) {
					this.d_text.text = this.d_text.text.substr(this.d_text.text.indexOf("\r") + 1);
				}
				this.tl.shift();
			}

			var i:uint;
			var j:uint;
						
			this.fpv.graphics.clear();
			this.fpv.graphics.beginFill(0x111111);
			this.fpv.graphics.drawRect(0, 0, 480, 320);
			this.fpv.graphics.lineStyle(2, 0xFFFFFFFF);

			move(this.dir);
			move(this.dir);
			move(this.dir);
			move(this.dir);
			move(this.dir);

			var p:Array = [];

			for (var d:int = 5; d > 0; d--) {
				move(this.dirs[this.dir][1]);
							
				
				var z:int = 200 * d;
				
				// draw middle frontal wall
				if (this.maze[this.px] && this.maze[this.px][this.py] && !(this.maze[this.px][this.py] & this.dir)) {
					p.push([-100, 100, z]);
					p.push([100, 100, z]);
					p.push([100, -100, z]);
					p.push([-100, -100, z]);
				}
				
				var x:int = -100;
				var sw:Boolean;
				var m:int = 0;
				while ((240 * (x / z)) + 240 > 0) {
					sw = false;
	
					// find left side wall
					if (this.maze[this.px] && this.maze[this.px][this.py] && !(this.maze[this.px][this.py] & this.dirs[this.dir][2])) {
						sw = true;
					}
					
					move(this.dirs[this.dir][2]);
					++m;
									
					// draw left back wall
					if (this.maze[this.px] && this.maze[this.px][this.py] && !(this.maze[this.px][this.py] & this.dir)) {
						p.push([x - 200, 100, z]);
						p.push([x, 100, z]);
						p.push([x, -100, z]);
						p.push([x - 200, -100, z]);
					}	
					
					// draw left side wall
					if (sw) {
						p.push([x, 100, z]);
						p.push([x, -100, z]);
						p.push([x, -100, (z - 200) > 50 ? (z - 200) : 50]);
						p.push([x, 100, (z - 200) > 50 ? (z - 200) : 50]);			
					}
					
					x -= 200;	
				}
							
				while (m-- > 0)
					move(this.dirs[this.dir][0]);
				
				
				x = 100;
				m = 0;
				
				
				while ((240 * (x / z)) + 240 < 480) {
					sw = false;
					
					// find right side wall
					if (this.maze[this.px] && this.maze[this.px][this.py] && !(this.maze[this.px][this.py] & this.dirs[this.dir][0])) {
						sw = true;
					} 
	
					move(this.dirs[this.dir][0]);
					++m;
					
					// draw right back wall
					if (this.maze[this.px] && this.maze[this.px][this.py] && !(this.maze[this.px][this.py] & this.dir)) {
						p.push([x + 200, 100, z]);
						p.push([x, 100, z]);
						p.push([x, -100, z]);
						p.push([x + 200, -100, z]);
					}
					
					// draw right side wall
					if (sw) {
						p.push([x, 100, z]);
						p.push([x, -100, z]);
						p.push([x, -100,(z - 200) > 50 ? (z - 200) : 50]);
						p.push([x, 100, (z - 200) > 50 ? (z - 200) : 50]);
						
					}
						
					
					x += 200;	
				}
				
				while (m-- > 0)
					move(this.dirs[this.dir][2]);
				

			}
			
				for (i = 0; i < p.length; i += 4) {
					this.fpv.graphics.beginBitmapFill(this.wa);
					
					this.fpv.graphics.moveTo(
						240 * p[i][0] / p[i][2] + 240,
						240 * p[i][1] / p[i][2] + 160
					);
					for (j = i + 1; j < i + 4; ++j) {
						this.fpv.graphics.lineTo(
							240 * p[j][0] / p[j][2] + 240,
							240 * p[j][1] / p[j][2] + 160
						);
					}
				}

			var rect:Rectangle = new Rectangle();
			// draw minimap
			this.map.fillRect(new Rectangle(0, 0, 320, 320), 0xFFFFFFFF);
			
			for (i = 0; i < 20; i++) {
				for (j = 0; j < 20; j++) {
					var cell:uint = this.maze[i][j];
					if ((cell & 0x10) && cell) {
						if ((cell & 0x01) == 0) {
							rect.x = i * 16;
							rect.y = j * 16;
							rect.width = 16;
							rect.height = 3;
							this.map.fillRect(rect, 0xFF000000);
						}
						if ((cell & 0x08) == 0) {
							rect.x = i * 16;
							rect.y = j * 16;
							rect.width = 3;
							rect.height = 16;
							this.map.fillRect(rect, 0xFF000000);
						}
						if ((cell & 0x02) == 0) {
							rect.x = i * 16 + 13;
							rect.y = j * 16;
							rect.width = 3;
							rect.height = 16;
							this.map.fillRect(rect, 0xFF000000);
						}
						if ((cell & 0x04) == 0) {
							rect.x = i * 16;
							rect.y = j * 16 + 13;
							rect.width = 16;
							rect.height = 3;
							this.map.fillRect(rect, 0xFF000000);
						}
					} else {
						rect.x = i * 16;
						rect.y = j * 16;
						rect.width = 16;
						rect.height = 16;
						this.map.fillRect(rect, 0xFF666666);
					}
				}
			}
			
			// draw position on minimap
			rect.x = this.px * 16 + 4;
			rect.y = this.py * 16 + 4;
			rect.width = 8;
			rect.height = 8;
			this.map.fillRect(rect, 0xFF0000FF);
			
			// draw head
			rect.width >>= 1;
			rect.height >>= 1;
			
			if (this.dir == 0x01) {
				rect.x += 2;
			} else if (this.dir == 0x02) {
				rect.x += 4;
				rect.y += 2;
			} else if (this.dir == 0x04) {
				rect.x += 2;
				rect.y += 4;
			} else {
				rect.y += 2;
			}
			
			this.map.fillRect(rect, 0xFFFFFFFF);
			
			// draw stairs (if applicable)
			if (this.sk) {
				rect.x = this.sx * 16 + 4;
				rect.y = this.sy * 16 + 4;
				rect.width = 8;
				rect.height = 8;
				this.map.fillRect(rect, 0xFF00AA55);
			}			
			
			// display stats
			
			this.d_stats.text = "HP: " + this.hp + "/" + this.mhp + "\n" +
			"STR: " + this.str + "  " + "DEF: " + this.def + "\n" +
			"Level " + this.level + "  XP: " + this.xp + "/" + this.xpn;
			
			this.bgc *= 0.35;
			this.d_text.backgroundColor = this.bgc;
		}
			
		 
		public function randomFloor():void {
			var i:uint;
			var j:uint;
			
			this.maze = [
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			];
			
			this.ccx = int(Math.random() * 20);
			this.ccy = int(Math.random() * 20);
			
			this.lss = 0;
			this.ld = 0;
			
			var remaining:uint = 399;
			
			while (remaining > 0) {
				while (!drawPassage(true)) {
					do {
						this.ccx = int(Math.random() * 20);
						this.ccy = int(Math.random() * 20);
					} while(this.maze[this.ccx][this.ccy] == 0);
				}
				--remaining;
			}
			
			// Sparsify
			for (i = 0; i < 20; i++) {
				for (j = 0; j < 20; j++) {
					if (this.maze[i][j] == 0x01) {
						this.maze[i][j] = 0;
						this.maze[i][j - 1] ^= 0x04;
					} else if (this.maze[i][j] == 0x02) {
						this.maze[i][j] = 0;
						this.maze[i + 1][j] ^= 0x08;
					} else if (this.maze[i][j] == 0x04) {
						this.maze[i][j] = 0;
						this.maze[i][j + 1] ^= 0x01;
					} else if (this.maze[i][j] == 0x08) {
						this.maze[i][j] = 0;
						this.maze[i - 1][j] ^= 0x02;
					}
				} // for j
			}
			for (i = 0; i < 20; i++) {
				for (j = 0; j < 20; j++) {
					if (this.maze[i][j] == 0x01) {
						this.maze[i][j] = 0;
						this.maze[i][j - 1] ^= 0x04;
					} else if (this.maze[i][j] == 0x02) {
						this.maze[i][j] = 0;
						this.maze[i + 1][j] ^= 0x08;
					} else if (this.maze[i][j] == 0x04) {
						this.maze[i][j] = 0;
						this.maze[i][j + 1] ^= 0x01;
					} else if (this.maze[i][j] == 0x08) {
						this.maze[i][j] = 0;
						this.maze[i - 1][j] ^= 0x02;
					}
				} // for j
			}


			// Remove deadends
			for (i = 0; i < 20; i++) {
				for (j = 0; j < 20; j++) {
					if (
						iss(this.maze[i][j]) &&
						Math.random() * 100 < 75
					) {
						this.ccx = i;
						this.ccy = j;
						
						this.lss = 0;
						this.ld = 0;
						
						while (iss(this.maze[this.ccx][this.ccy])) {
							while (!drawPassage(false)) {
								do {
									this.ccx = int(Math.random() * 20);
									this.ccy = int(Math.random() * 20);
								} while(this.maze[this.ccx][this.ccy] == 0);
							}
						}						
					}
				}
			}
		}
		
		/**
		 * Attempts to add a single new passage to a cells array using a
		 * Hunt-and-Kill algorithm.
		 * 
		 * @param cells The cells array to modify.
		 * @param currentCell The cell to work from.
		 * @param randomness Percentage (0-100) chance to change direction
		 *    last successful passage.
		 * @param lastPassage Struct containing the last direction moved and
		 *    the number of times the passage has gone in a single direction.
		 * @param noLoops If true, will never draw a passage that connects to
		 *    an already-visted cell.
		 */
		private function drawPassage(nol:Boolean):Boolean {
			var directions:uint = this.maze[this.ccx][this.ccy];
			if (directions == 0x0F)
				return false;
				
			var direction:uint;
			
			if (this.ccx < 1)
				directions |= 0x08;
			if (this.ccx + 1 >= 20)
				directions |= 0x02;
			if (this.ccy < 1)
				directions |= 0x01;
			if (this.ccy + 1 >= 20)
				directions |= 0x04;

			if (int(Math.random() * 8) < 4 ||
				!cgs(nol)
			) {
				this.lss = 0;
				direction = srd(directions, nol);
			} else {
				++this.lss;
				direction = this.ld;
			}

			if (direction == 0)
				return false;
		
			this.ld = direction;
			this.maze[this.ccx][this.ccy] |= direction;
			
			if (direction == 0x01) {
				--this.ccy;
				direction = 0x04;
			} else if (direction == 0x02) {
				++this.ccx;
				direction = 0x08;
			} else if (direction == 0x04) {
				++this.ccy;
				direction = 0x01;
			} else if (direction == 0x08) {
				--this.ccx;
				direction = 0x02;
			}

			
			this.maze[this.ccx][this.ccy] |= direction;
			return true;
		}
		
		
		
		/**
		 * Returns true if the next cell in the current direction is unvisited.
		 */
		private function cgs(nl:Boolean):Boolean {
			if (this.ld == 0x01) {
				return (
					(this.lss < (this.ccy >> 1)) && 
					(this.ccy > 0) && 
					!(nl && this.maze[this.ccx][this.ccy - 1])
				);
			} else if (this.ld == 0x02) {
				return (
					(this.lss < (this.ccx >> 1)) &&
					(this.ccx + 1 < 20) && 
					!(nl && this.maze[this.ccx + 1][this.ccy])
				);				
			} else if (this.ld == 0x04) {
				return (
					(this.lss < (this.ccy >> 1)) &&
					(this.ccy + 1 < 20) &&
					!(nl && this.maze[this.ccx][this.ccy + 1])
				);
			} else if (this.ld == 0x08) {
				return (
					(this.lss < (this.ccx >> 1)) &&
					(this.ccx > 0) &&
					!(nl && this.maze[this.ccx - 1][this.ccy])
				);				
			} else {
				return false;
			}
		} 
		
		private function srd(ds:uint, ar:Boolean):uint {
			var d:uint;
			
			while ((d == 0) || ((ds & d) != 0)) {
				var tx:uint = this.ccx;
				var ty:uint = this.ccy;
				
				var r:int = int(Math.random() * 4);
				if (r == 0) {
					if (this.ccy > 0) {
						d = 0x01;
						--ty;
					} else {
						ds |= 0x01;
					}
				} else if (r == 1) {
					if (this.ccy + 1 < 20) {
						d = 0x04;
						++ty;
					} else {
						ds |= 0x04;
					}
				} else if (r == 2) {
					if (this.ccx > 0) {
						d = 0x08;
						--tx;
					} else {
						ds |= 0x08;
					}
				} else {
					if (this.ccx + 1 < 20) {
						d = 0x02;
						++tx;
					} else {
						ds |= 0x02;
					}
				}
				
				if (ar && this.maze[tx][ty] != 0) {
					ds |= d;
					if (ds == 0x0F)
						return 0;
							
					d = 0;
				}
			}
			
			return d;
		}
		
		public function iss(d:uint):Boolean {
			return (d == 0x01 ||
				d == 0x02 ||
				d == 0x04 ||
				d == 0x08
			);	
		}

	}
}