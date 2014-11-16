package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	
	public class mother extends MovieClip {
		
		//var UC_mc:UnitCircle = new UnitCircle();
		
		public function mother() {
			// constructor code
			stage.addEventListener(MouseEvent.MOUSE_MOVE, Update);
			stage.addEventListener(MouseEvent.CLICK, Freeze);
		}
		function Update(e:MouseEvent) {
			UC_mc.DrawLine();
			rad.text = UC_mc.getrad();
			deg.text = UC_mc.getdeg();
			pos_x.text = UC_mc.getx();
			pos_y.text = UC_mc.gety();
		}
		function Freeze(e:MouseEvent) {
			if (UC_mc.frozen) {
				stage.addEventListener(MouseEvent.MOUSE_MOVE, Update);
				UC_mc.frozen = false;
				Update(e);
			}
			else {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, Update);
				UC_mc.frozen = true;
			}
		}
	}
	
}
