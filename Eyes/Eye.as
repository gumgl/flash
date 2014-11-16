package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Eye extends MovieClip {
		
		public var angle = 0;
		
		public function Eye() {			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, Turn);
		}
		
		function Turn(e:MouseEvent) {
			angle = Math.atan2((e.stageY - this.y),(e.stageX - this.x));
			this.rotation = angle * 180 / Math.PI;
		}
	}
	
}
