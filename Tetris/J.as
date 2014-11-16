package  {
	
	import flash.display.MovieClip;
	
	
	public class J extends Piece {
		
		
		public function J() {
			//color = 0x0000FF;
			color = 0x447cff;
			grid_color = 0x2159de;
			AddBlock(0, 0, color);
			AddBlock(0, 1, color);
			AddBlock(0, 2, color);
			AddBlock(1, 2, color);
		}
	}
	
}
