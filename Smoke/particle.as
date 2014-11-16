package  {
	
	import flash.display.*;
	import flash.events.*;
	
	public class particle extends MovieClip {
		public var ORIGINAL_ANGLE = 0;
		var RANGE = Math.PI/4;
		
		var speed:Number;
		var distance:Number = 0;
		var angle:Number;
		var originalRadius:Number;
		var originalDistance:Number;
		
		var stageRef:Stage;
		
		public function particle(s:Stage) {
			speed = 2 + 4*Math.random();
			originalDistance = 100 + 50*Math.random();
			originalRadius = 10 + 5*Math.random();
			this.width = originalRadius;
			this.height = originalRadius;
			
			stageRef = s;
			
			this.addEventListener(Event.ENTER_FRAME, Move);
		}
		
		public function setAngle(newAngle:Number) {
			angle = (newAngle) - RANGE/2 + RANGE*Math.random();
		}
		
		function  Move(e:Event) {
			if (this.visible == false)
				this.visible = true;
			
			//trace(MovieClip(parent).ROTATION_SPEED);
			if (distance >= originalDistance) {
				this.removeEventListener(Event.ENTER_FRAME, Move);
				stage.removeChild(this);
				delete this;
			}
			
			
			
			this.x += Math.cos(angle) * speed;
			this.y -= Math.sin(angle) * speed;
			distance += speed;
			
			var newRadius = originalRadius * ((distance/originalDistance) * 3);
			this.width = newRadius;
			this.height = newRadius;
			//this.alpha = 1 / (Math.pow(newRadius, 2)/Math.pow(originalRadius, 2));
			this.alpha = (originalDistance - distance)/originalDistance;
		}
	}
}