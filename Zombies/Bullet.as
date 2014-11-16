package {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Bullet extends MovieClip {
		
		public var damage = 1;		
		public var angle = 0;
		public var speed = 22; // inherited from player
		public var radius:Number;
		
		var p:Player;
		
		public function Bullet(player:Player) {
			radius = this.height / 2;
			p = player;
			this.addEventListener(Event.ENTER_FRAME, Move);
			this.cacheAsBitmap = true;
		}
		
		public function Remove() {
			this.removeEventListener(Event.ENTER_FRAME, Move);
			stage.removeChild(this);
		}
		
		function Move(e:Event) {
			if (!p.gamePaused) {
				this.x += Math.cos(angle) * speed;
				this.y -= Math.sin(angle) * speed;
			}
		}
	}
}