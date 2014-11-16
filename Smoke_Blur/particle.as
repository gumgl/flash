package  {
	
	import flash.display.*;
	import flash.events.*;
	
	public class particle extends MovieClip {
		public var ORIGINAL_ANGLE = 0;
		var RANGE = Math.PI/8;
		
		var speed:Number;
		var distance:Number = 0;
		var angle:Number;
		var originalDiameter:Number;
		var originalDistance:Number;
		
		var stageRef:Stage;
		
		public function particle(s:Stage) {
			speed = 4 + 2*Math.random();
			originalDistance = 200 + 50*Math.random();
			originalDiameter = 20 + 10*Math.random();
			this.width = originalDiameter;
			this.height = originalDiameter;
			
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
			
			var newDiameter = originalDiameter + ((distance/originalDistance) * originalDiameter * 3);
			this.width = newDiameter;
			this.height = newDiameter;
			//this.alpha = 1 / (Math.pow(newRadius, 2)/Math.pow(originalRadius, 2));
			this.alpha = (originalDistance - distance)/originalDistance;
		}
	}
}