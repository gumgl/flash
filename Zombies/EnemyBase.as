package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	
	
	public class EnemyBase extends MovieClip {
		
		public var DAMAGE = 10;
		public var ATTACK_RATE = 1; // In attack/second
		public var VALUE = 10; // Points that will be added to player's score
		public var health = 2;
		public var radius;
		
		var initialHealth = 10;
		var speed = 1;
		var angle = 0;
		var attackFrame;
		var s:Stage;
		var p:Player;
		var sound_hit:SoundHit = new SoundHit();
		var healthBar_mc:HealthBar = new HealthBar();
		
		public function EnemyBase() {
			this.addEventListener(Event.ENTER_FRAME, Move);
			//this.addEventListener(MouseEvent.MOUSE_OVER, ShowHealth);
			
			// Slighty alter speed (± 10%) so that zombies from same type disperse instead of converge
			speed = speed * (0.9 + 0.2 * Math.random())
		}
		
		/*function ShowHealth(e:MouseEvent) {
			trace("Zombies Health:", health);
		}*/
		
		function BaseConstructor(theStage:Stage, player:Player) {
			s = theStage;
			p = player;
			attackFrame = s.frameRate/ATTACK_RATE;
			s.addChild(this);
			s.addChild(healthBar_mc);
			radius = this.height / 2;
		}
		
		public function Remove() {
			//sound_hit.Stop();
			sound_hit = null;
			this.removeEventListener(Event.ENTER_FRAME, Move);
			s.removeChild(this);
			s.removeChild(healthBar_mc);
		}
		
		public function Move(e:Event) {
			if (!p.gamePaused) {
				angle = Math.atan2(-1 *(p.y - this.y),(p.x - this.x));
				this.rotation = -1 * angle * 180 / Math.PI;
				
				var distX = p.x - this.x;
				var distY = p.y - this.y;
				if (Math.sqrt(distX * distX + distY * distY) <= p.radius + radius) { // Zombie touches player
					// Play Hit Sound
					/*if (sound_hit.Playing == false) {
						sound_hit.Play();
					}*/
					// Damage Player
					if (attackFrame >= s.frameRate/ATTACK_RATE)
						attackFrame = 0;
					if (attackFrame % (s.frameRate/ATTACK_RATE) == 0) {
						sound_hit.play();
						p.health -= DAMAGE;
						p.UpdateHealthBar();
					}
				}
				else {
					// Stop Hit Sound
					/*if (sound_hit.Playing) {
						sound_hit.Stop();
					}*/
					this.x += Math.cos(angle) * speed;
					this.y -= Math.sin(angle) * speed;
					healthBar_mc.x = this.x;
					healthBar_mc.y = this.y - 20;
				}
				
				
				attackFrame ++;
			}
		}
		
		public function UpdateHealthBar() {
			healthBar_mc.Update(health/initialHealth);
		}
	}
}
