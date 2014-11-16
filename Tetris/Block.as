package  {
	
	import flash.display.MovieClip;
    import flash.geom.ColorTransform;
	
	public class Block extends MovieClip {
		public static var size:Number = 18;
		
		public var color:Number = 0;
		public var row:Number = 0;
		public var col:Number = 0;
		
		public function Block(newColor:Number) {
			SetColor(newColor);
		}
		
		public function SetColor(newColor:Number) {
			var colorTransform:ColorTransform = fill_mc.transform.colorTransform;
			colorTransform.color = newColor;
			fill_mc.transform.colorTransform = colorTransform;
			color = newColor;
		}
	}
	
}
