package  {
	
    import flash.display.Sprite;
    import flash.display.LineScaleMode;
    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	
	
	public class UnitCircle extends MovieClip {
		
		public var frozen:Boolean = false;
		
		var line1:Shape = new Shape();
		var angle:Number = 0;
		var pos_x:Number = 1;
		var pos_y:Number = 0;
		
		public function UnitCircle() {
			this.addChild(line1);
			setChildIndex(line1, 4);
			
			stage.addEventListener(Event.MOUSE_LEAVE, Clear);
		}
		public function getrad() : String
		{
			var Q1:Array = ["2π", "π/6", "π/4", "π/3"];
			var Q2:Array = ["π/2", "2π/3", "3π/4", "5π/6"];
			var Q3:Array = ["π", "7π/6", "5π/4", "4π/3"];
			var Q4:Array = ["3π/2", "5π/3", "7π/4", "11π/6"];
			var angles:Array = [Q1, Q2, Q3, Q4];
			var quadrant = Math.floor(angle / (Math.PI/2));
			var degree = Math.round(((angle / Math.PI) % 0.5) * 180);
			var index = -1;
			switch(degree) {
				case 0:
					index = 0;
					break;
				case 30:
					index = 1;
					break;
				case 45:
					index = 2;
					break;
				case 60:
					index = 3;
					break;
			}
			if (index >= 0)
				return angles[quadrant][index];
			else
				return String(Math.round(angle/Math.PI*1000)/1000)+"π";
		}
		public function getdeg() : String
		{
			return String(Math.round(angle*180/Math.PI*10)/10)+"°";
		}
		public function getx() : String
		{
			return String(Math.round(pos_x*1000)/1000);
		}
		public function gety() : String
		{
			return String(Math.round(pos_y*1000)/1000);
		}
		public function Clear(e:Event) : void {
			line1.graphics.clear();
		}
		public function DrawLine(){
			line1.graphics.clear();
			
            line1.graphics.lineStyle(2, 0xFF0000, 1, false, LineScaleMode.VERTICAL, CapsStyle.NONE, JointStyle.MITER, 10);
			
			
			var len = getRect(this).height / 2;
			angle = Math.atan2(-1*mouseY, mouseX);
			if (angle < 0)
				angle += 2*Math.PI;
						
			var quadrant = Math.floor(angle / (Math.PI/2));
			var Q1 = ((angle / Math.PI) % 0.5) * 180;
			var precision = 2;
			
			if (Q1 <= precision) {
				angle = (quadrant * Math.PI/2) + 0;
			}
			else if (Q1 >= 30-precision && Q1 <= 30+precision) {
				angle = (quadrant * Math.PI/2) + Math.PI/6;
			}
			else if (Q1 >= 45-precision && Q1 <= 45+precision) {
				angle = (quadrant * Math.PI/2) + Math.PI/4;
			}
			else if (Q1 >= 60-precision && Q1 <= 60+precision) {
				angle = (quadrant * Math.PI/2) + Math.PI/3;
			}
			else if (Q1 >= 90-precision) {
				quadrant ++;
				if (quadrant == 4)
					quadrant = 0;
				angle = (quadrant * Math.PI/2) + 0;
			}
			
			pos_x = Math.cos(angle);
			pos_y = Math.sin(angle);
			
			// Draw Hypothenus:
			line1.graphics.lineStyle(2, 0xFF0000, 1, false, LineScaleMode.VERTICAL, CapsStyle.NONE, JointStyle.MITER, 10);
			line1.graphics.moveTo(0, 0);
            line1.graphics.lineTo(pos_x*len, -1*pos_y*len);
			
            // Draw Horizontal Axis (y):
			line1.graphics.lineStyle(2, 0x000099, 1, false, LineScaleMode.VERTICAL, CapsStyle.NONE, JointStyle.MITER, 10);
			line1.graphics.moveTo(pos_x*len, 0);
			line1.graphics.lineTo(pos_x*len, -1*pos_y*len);
			
            // Draw Vertical Axis (x):
			line1.graphics.lineStyle(2, 0x009900, 1, false, LineScaleMode.VERTICAL, CapsStyle.NONE, JointStyle.MITER, 10);
			line1.graphics.moveTo(0, -1*pos_y*len);
			line1.graphics.lineTo(pos_x*len, -1*pos_y*len);
			
			// Draw Hypothenus Extension:
			if (Math.abs(mouseX) >= Math.abs(pos_x*len) && Math.abs(mouseY) >= Math.abs(pos_y*len))
			{
				var mouseDistance = Math.pow(mouseX*mouseX+mouseY*mouseY, 0.5);
				line1.graphics.lineStyle(2, 0x000000, .5, false, LineScaleMode.VERTICAL, CapsStyle.NONE, JointStyle.MITER, 10);
				line1.graphics.moveTo(pos_x*len, -1*pos_y*len);
				line1.graphics.lineTo(Math.cos(angle)*mouseDistance, -1*Math.sin(angle)*mouseDistance);
			}
		}
	}
	
}
