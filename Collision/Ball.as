package {
	import flash.display.*;
	import flash.events.*;
	 
	public class Ball extends MovieClip {
		
		var speed = 0;
		var radians = 0;
		 
		public function Ball()
		{
			speed = 1+5*Math.random();
			radians = 2*Math.PI*Math.random();
			
			this.addEventListener(Event.ENTER_FRAME, MoveBall);
			this.addEventListener(MouseEvent.MOUSE_OVER, Redirect);
		}
		
		function Redirect(e:MouseEvent)
		{
			radians = 2*Math.PI*Math.random();			
		}
		
		function MoveBall(e:Event)
		{
			//trace("Radians = PI*" + radians / Math.PI);
			//trace("Angle: " + 180 * radians / Math.PI);
			//trace("X added: " + Math.cos(radians));
			//trace("Y adeed: " + Math.sin(radians));
			
			this.x += Math.cos(radians) * speed;
			this.y -= Math.sin(radians) * speed;
			
			if (this.y <= 0)
			{
				radians = radians%(2*Math.PI);
				if (radians <= Math.PI/2) //Q1
				{
					radians = Math.PI * 1.5 + (Math.PI/2 - radians);
				}
				else // Q2
				{
					radians = Math.PI + (Math.PI - radians);
				}			
			}
			else if (this.x <= 0)
			{
				radians = radians%(2*Math.PI);
				if (radians < Math.PI) //Q2
				{
					radians = Math.PI - radians;
				}
				else // Q3
				{
					radians = 2*Math.PI - (radians - Math.PI);
				}	
			}
			else if (this.y + this.height >= stage.stageHeight)
			{
				radians = radians%(2*Math.PI);
				if (radians < Math.PI * 1.5) //Q3
				{
					radians = Math.PI - (radians - Math.PI);
				}
				else // Q4
				{
					radians = 2*Math.PI - radians;
				}	
			}
			else if (this.x + this.width >= stage.stageWidth)
			{
				radians = radians%(2*Math.PI);
				if (radians < Math.PI * 1.5) //Q1
				{
					radians = Math.PI - radians;
				}
				else // Q4
				{
					radians = Math.PI + (2*Math.PI - radians);
				}	
			}
		}
	}
}