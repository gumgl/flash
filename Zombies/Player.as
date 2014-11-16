package {
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.ui.Keyboard;
	 
	public class Player extends MovieClip {
		const WEAPON_TYPES:Array = [WeaponGlock, WeaponAK47, WeaponMiniGun, WeaponShotgun];
		//const CHEAT_KEYCODE = 32; // Space bar
		public const INITIAL_HEALTH = 100;
		public var speed = 6;
		public var angle = 0;
		public var health = INITIAL_HEALTH;
		public var radius:Number = 0;
		public var weapon:WeaponBase;
		public var gamePaused = false;
		public var ownedGuns:Array = new Array();
		public var weaponID:Number = 0;
		
		var s:Stage;
		var IsKeyDown:Array = new Array();
		var healthBar_mc:HealthBar = new HealthBar();
		
		public function Player(theStage:Stage) {
			s = theStage;
			s.addEventListener(Event.ENTER_FRAME, Move);
			s.addEventListener(MouseEvent.MOUSE_MOVE, function(){Turn();});
			s.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			s.addEventListener(KeyboardEvent.KEY_UP, key_up);
						
			ResetKeyArray();
			
			s.addChild(healthBar_mc);
			healthBar_mc.SetColor(0x00FF00);
			radius = this.height / 2;
			weapon = new WEAPON_TYPES[weaponID](s, this);
			addChild(weapon)
		}
		
		public function PrevGun() {
			if (weaponID > 0)
				ChangeGun(weaponID - 1);
			else
				ChangeGun(WEAPON_TYPES.length - 1);
		}
		
		public function NextGun() {
			if (weaponID < WEAPON_TYPES.length - 1)
				ChangeGun(weaponID + 1);
			else
				ChangeGun(0);
		}
		
		public function ChangeGun(id:Number) {
			removeChild(weapon);
			weapon = new WEAPON_TYPES[id](s, this);
			addChild(weapon);
			weaponID = id;
		}
		
		function Move(e:Event) {
			if (health > 0 && !gamePaused) {
				/*if (IsKeyDown[CHEAT_KEYCODE])
					speed *= 2;*/
				
				if (IsKeyDown[Keyboard.W] || IsKeyDown[Keyboard.UP])
					this.y -= speed * weapon.speedFactor;
				if (IsKeyDown[Keyboard.S] || IsKeyDown[Keyboard.DOWN])
					this.y += speed * weapon.speedFactor;
				if (IsKeyDown[Keyboard.D] || IsKeyDown[Keyboard.RIGHT])
					this.x += speed * weapon.speedFactor;
				if (IsKeyDown[Keyboard.A] || IsKeyDown[Keyboard.LEFT])
					this.x -= speed * weapon.speedFactor;
				
				/*if (IsKeyDown[CHEAT_KEYCODE])
					speed /= 2;*/
				
				if (this.x < radius)
					this.x = radius;
				else if (this.x > s.stageWidth - radius)
					this.x = s.stageWidth - radius;
				if (this.y < radius)
					this.y = radius;
				else if (this.y > s.stageHeight - radius)
					this.y = s.stageHeight - radius;
					
				healthBar_mc.x = this.x;
				healthBar_mc.y = this.y - 20;
				
				Turn();
			}
		}
		
		function Turn() {
			if (health > 0 && !gamePaused) {
				angle = Math.atan2(-1 *(s.mouseY - this.y),(s.mouseX - this.x));
				this.rotation = -1 * angle * 180 / Math.PI;
				if (Math.abs(angle) > Math.PI/2)
					weapon.scaleY = Math.abs(weapon.scaleY) * -1;
				else
					weapon.scaleY = Math.abs(weapon.scaleY);
			}
		}
		
		function key_down(e:KeyboardEvent) {
			IsKeyDown[e.keyCode] = true;
			
			/*if (!gamePaused) {
				switch (e.keyCode) {
					case Keyboard.Q:
						PrevGun(); break;
					case Keyboard.E:
						NextGun(); break;
				}
			}*/
			//trace("Down:", e.keyCode, String.fromCharCode(e.charCode));
		}
		
		function key_up(e:KeyboardEvent) {
			IsKeyDown[e.keyCode] = false;
			//trace("Up:", e.keyCode, String.fromCharCode(e.charCode));
		}
		
		public function ResetKeyArray() {
			for (var i = 0; i < 128; i ++)
				IsKeyDown[i] = false;
		}
		
		public function UpdateHealthBar() {
			healthBar_mc.Update(health/INITIAL_HEALTH);
		}
	}
}