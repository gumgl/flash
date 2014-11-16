package  {
	
	import flash.display.*;
	import flash.events.*;
	
	public class particle extends MovieClip {		
		var speed:Number;
		var distance:Number = 0;
		var angle:Number;
		var originalDiameter:Number;
		var originalDistance:Number;
		var originalAngle:Number;
		var originalSpeed:Number;
		
		var s:Stage;
		var p:MovieClip;
		
		public function particle(stageRef:Stage, parentRef:MovieClip) {
			
			s = stageRef;
			p = parentRef;
			originalAngle = p.angle;
			originalSpeed = p.speed;// * (1 - p.ACCELERATION/100);
			
			this.addEventListener(Event.ENTER_FRAME, Move);
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
			// Move independant particle:
			this.x += Math.cos(angle) * speed;
			this.y -= Math.sin(angle) * speed;
			// Add relative to car:
			this.x += Math.cos(originalAngle) * originalSpeed;
			this.y -= Math.sin(originalAngle) * originalSpeed;
			originalSpeed *= (1 - p.DECCELERATION * 2 / 100);
			// Move relative to stage:
			this.x += Math.cos(p.angle + Math.PI) * p.speed;
			this.y -= Math.sin(p.angle + Math.PI) * p.speed;
			
			distance += speed;
			
			var newDiameter = originalDiameter + ((distance/originalDistance) * originalDiameter * 10);
			this.width = newDiameter;
			this.height = newDiameter;
			//this.alpha = 1 / (Math.pow(newRadius, 2)/Math.pow(originalRadius, 2));
			this.alpha = (originalDistance - distance)/originalDistance;
		}
	}
}