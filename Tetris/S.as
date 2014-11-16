package  {
	
	import flash.display.MovieClip;
	
	
	public class S extends Piece {
		
		
		public function S() {
			//color = 0x00FF00;
			color = 0x86ea33;
			grid_color = 0x63c710;
			AddBlock(0, 1, color);
			AddBlock(0, 2, color);
			AddBlock(1, 0, color);
			AddBlock(1, 1, color);
		}
	}
	
}
