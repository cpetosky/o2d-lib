package net.petosky.dungeon {
	import net.petosky.dungeon.display.Window;
	import net.petosky.dungeon.party.Party;
	import net.petosky.dungeon.party.Character;
	import net.petosky.dungeon.display.TextFactory;
	import flash.events.Event;	
	import flash.text.TextField;

	/**
	 * @author Cory Petosky
	 */
	public class BattleView extends Window {
		public static const BATTLE_WON:String = "battleWon";
		public static const BATTLE_ESCAPE:String = "battleEscape";
		
		// battle
		private var _enemyHealth:int;
		private var _enemyStrength:int;
		private var _enemyDefense:int;

		private var _runChance:Number;
		
		// display stats
		private var _textQueue:Vector.<String> = new Vector.<String>();
		private var _combatLog:TextField;

		private var _defending:Boolean = false;
		
		private var _floorNumber:int;
		private var _party:Party;
		
		public function BattleView(floor:int, party:Party) {
			super(615, 400);
			
			_floorNumber = floor;
			_party = party;
			
			_runChance = 0.25 - 0.002 * floor;
			_enemyHealth = (3 + Math.random() * 10) * floor / 2;
			_enemyStrength = (3 + Math.random() * 8) * floor / 2;
			_enemyDefense = (3 + Math.random() * 8) * floor / 2;

			_combatLog = TextFactory.instance.createTextField("", 370, 380);
			_combatLog.x = 400;
			_combatLog.y = 10;
			_combatLog.background = true;
			_combatLog.backgroundColor = 0;
			_combatLog.border = true;
			_combatLog.borderColor = 0xFFFFFF;
			_combatLog.wordWrap = true;
			sprite.addChild(_combatLog);
			
			echo("Enemy!");
			echo("(A)ttack, (H)eal, (R)un?");
			
			backgroundColor = 0xCC000000;
		}
		
		private function echo(t:String):void {
			_textQueue.push(t);			
		}
		
		override public function update(delta:uint):void {
			super.update(delta);
			handleInput();
			
			if (_textQueue.length > 0) {
				_combatLog.appendText(_textQueue[0] + "\n");
				while (_combatLog.numLines > 18) {
					_combatLog.text = _combatLog.text.substr(_combatLog.text.indexOf("\r") + 1);
				}
				_textQueue.shift();	
			}
		}
		
		
		private function enemyTurn():void {
			var character:Character = _party.getCharacter(0);
			
			var dmg:int = (1 + Math.random() * 10) + _enemyStrength - character.defense - (1 + Math.random() * 10);
			
			// 1.5x when defending!
			if (_defending)
				dmg -= (character.defense + (1 + Math.random() * 10) >> 1);
			
			// 50% miss chance/heal chance
			if (dmg < 1 && Math.random() * 100 < 50)
				dmg = 1;
				
			if (dmg < 1) {
				if (_defending) {
					if (dmg < character.health - character.maxHealth)
						dmg = character.health - character.maxHealth;
					echo("You defend yourself and heal for " + -dmg + ".");
					character.health -= dmg;
				} else {
					echo("Enemy misses.");
				}	
			} else {
				echo("Enemy hits you for " + dmg);	
				character.health -= dmg;
			}

			_defending = false;
			
			if (character.health < 1) {
				_combatLog.text = "";
				echo("You lose...");
				echo("You got to floor " + _floorNumber + " as a level " + character.level + " warrior.");
				echo("Restarting game...");
				
				_party.dispatchEvent(new Event(Party.DOOMED));
			} else {
				echo("(A)ttack, (H)eal, (R)un?");				
			}
		}
		
		public function handleInput():uint {
			if (gameState.isKeyDown("A")) {
				var character:Character = _party.getCharacter(0);

				var dmg:int = (1 + Math.random() * 10) + character.strength - _enemyDefense - (1 + Math.random() * 10);
				
				// Make miss chance 50%
				if (dmg < 1)
					dmg = Math.random() * 2;
				
				if (dmg < 1)
					echo("You miss.");
				else {
					echo("You attack and inflict " + dmg + " damage.");
					_enemyHealth -= dmg;
				}
				
				if (_enemyHealth < 1) {
					echo("You win!");
					echo("All surviving party members gain " + _party.splitXP(10 * _floorNumber) + " XP.");
					dispatchEvent(new Event(BATTLE_WON));
				} else {
					enemyTurn();
				}
				
				return 200;
			} else if (gameState.isKeyDown("H")) {
				echo("You begin mending...");
				_defending = true;
				enemyTurn();
				return 200;
			} else if (gameState.isKeyDown("R")) {
				if (Math.random() < _runChance) {
					echo("You run away!");
					dispatchEvent(new Event(BATTLE_ESCAPE));
				} else {
					_runChance *= 1.25; // make it easier on successive attempts
					echo("You couldn't run away...");
					enemyTurn();
				}	
				return 200;				
			}
			
			return 0;
		}
	}
}
