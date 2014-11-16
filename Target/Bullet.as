package {
	import flash.display.*;
	import flash.events.*;
	
	public class Bullet extends MovieClip {
		
		public var angle = 0;
		public var speed = 0;
		
		public function Bullet() {
			this.addEventListener(Event.ENTER_FRAME, Move);
		}
		
		function Move(e:Event) {
			this.x += Math.cos(angle) * speed;
			this.y += Math.sin(angle) * speed;
			
			if (this.x < 0 || this.y < 0 || this.x > stage.stageWidth || this.y > stage.stageHeight)
			{
				this.removeEventListener(Event.ENTER_FRAME, Move);
				this.visible = false;
				//this = null;
			}
		}
	}
}