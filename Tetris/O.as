package  {
	
	import flash.display.MovieClip;
	
	
	public class O extends Piece {
		
		
		public function O() {
			//color = 0xFFFF00;
			color = 0xffd93b;
			grid_color = 0xffb618;
			AddBlock(0, 0, color);
			AddBlock(0, 1, color);
			AddBlock(1, 0, color);
			AddBlock(1, 1, color);
		}
	}
	
}
