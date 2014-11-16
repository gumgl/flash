package  {
	
	import flash.display.*;
	import flash.events.*;	
	
	public class Smoke extends MovieClip {
		
		public var PARTICLES_PER_FRAME = 0;
		public var RANGE = Math.PI/4;
		public var ROTATION_SPEED = 15; // in degrees/wheel click
		
		var angle:Number;		
		var s:Stage;
		var p:MovieClip;
		
		public function Smoke(stageRef:Stage, parentRef:MovieClip) {
			s = stageRef;
			p = parentRef;
			this.addEventListener(Event.ENTER_FRAME, AddParticles);
		}
		
		public function UpdatePos(X:Number, Y:Number, ANGLE:Number)
		{
			this.x = X;
			this.y = Y;
			this.angle = ANGLE;
		}
		
		function AddParticles(e:Event) {
			var i:Number;
			for (i=0; i<PARTICLES_PER_FRAME; i++) {
				var newParticle:particle = new particle(s, p);
				newParticle.x = this.x;
				newParticle.y = this.y;
				newParticle.visible = false;
				
				newParticle.speed = 2 + Math.random();
				//newParticle.speed = Math.abs(p.speed) * (p.DECCELERATION/100);
				newParticle.originalDistance = 60 + 30*Math.random();
				newParticle.originalDiameter = 3 + 5*Math.random();
				newParticle.width = newParticle.originalDiameter;
				newParticle.height = newParticle.originalDiameter;
				
				newParticle.angle = (this.angle) - RANGE/2 + RANGE*Math.random();;
				s.addChild(newParticle);
				s.setChildIndex(newParticle, s.numChildren - 1);
				//s.setChildIndex(newParticle, 0);
			}
		}
	}
	
}
