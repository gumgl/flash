package  {
	
	import flash.display.*;
	import flash.events.*;	
	
	public class Smoke extends MovieClip {
		
		var PARTICLES_PER_FRAME = 2;
		public var ROTATION_SPEED = 15; // in degrees/wheel click
		
		public function Smoke() {
			this.addEventListener(Event.ENTER_FRAME, AddParticles);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, Move);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, Turn);
		}
		
		function Move(e:MouseEvent) {
			this.x = e.stageX;
			this.y = e.stageY;			
		}
		
		function Turn(e:MouseEvent) {
			if (e.delta < 0) // Mouse Wheel Up
				this.rotation += ROTATION_SPEED;
			else
				this.rotation -= ROTATION_SPEED;
		}
		
		function AddParticles(e:Event) {
			var i:Number;
			for (i=0; i<PARTICLES_PER_FRAME; i++) {
				var newParticle:particle = new particle(stage);
				newParticle.x = this.x;
				newParticle.y = this.y;
				newParticle.visible = false;
				newParticle.setAngle(-1 * this.rotation / 180 * Math.PI);
				stage.addChild(newParticle);
				stage.setChildIndex(newParticle, 0);
			}
		}
	}
	
}
