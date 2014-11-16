package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Player extends MovieClip {
		
		public var speed:Number = 0;
		var oldX:Number = 0;
		var oldY:Number = 0;
		
		public function Player() {
			// constructor code
			stage.addEventListener(MouseEvent.MOUSE_MOVE, Update);
		}
		
		function Update(e:MouseEvent) {
			if (e.stageY < stage.stageHeight/2)
				this.y = stage.stageHeight/2;
			else
				this.y = e.stageY;
			this.x = e.stageX;
			
			speed = Math.sqrt(Math.pow(this.x-oldX, 2) + Math.pow(this.y-oldY, 2));
			oldX = e.stageX;
			oldY = e.stageY;
		}
	}
}
