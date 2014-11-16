package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Puck extends MovieClip {
		
		public var speed = 0; // In pixels/frame
		public var angle = 0; // 0-2pi
		
		public function Puck() {
			// constructor code
			speed = 4+2*Math.random();
			angle = 2*Math.PI*Math.random();
			this.addEventListener(Event.ENTER_FRAME, Move);
		}
		
		function Move(e:Event) {
			angle = angle%(2*Math.PI);
			this.x += Math.cos(angle) * speed;
			this.y -= Math.sin(angle) * speed;
			speed *= 0.99; // lose 0.001% each frame to slow down
			
			if (this.y - this.width/2 <= 0 && angle < Math.PI && angle > 0)
			{
				if (angle <= Math.PI/2) //Q1
				{
					angle = Math.PI * 1.5 + (Math.PI/2 - angle);
				}
				else // Q2
				{
					angle = Math.PI + (Math.PI - angle);
				}			
			}
			else if (this.x - this.width/2 <= 0 && angle < Math.PI*1.5 && angle > Math.PI/2)
			{
				if (angle < Math.PI) //Q2
				{
					angle = Math.PI - angle;
				}
				else // Q3
				{
					angle = 2*Math.PI - (angle - Math.PI);
				}	
			}
			else if (this.y + this.width/2 >= stage.stageHeight && angle < Math.PI*2 && angle > Math.PI)
			{
				if (angle < Math.PI * 1.5) //Q3
				{
					angle = Math.PI - (angle - Math.PI);
				}
				else // Q4
				{
					angle = 2*Math.PI - angle;
				}	
			}
			else if (this.x + this.width/2 >= stage.stageWidth && (angle < Math.PI/2 || angle > Math.PI*1.5))
			{
				if (angle < Math.PI * 1.5) //Q1
				{
					angle = Math.PI - angle;
				}
				else // Q4
				{
					angle = Math.PI + (2*Math.PI - angle);
				}	
			}
		}
	}
	
}
