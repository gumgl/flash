package  {	
	import flash.display.MovieClip;
    import flash.geom.ColorTransform;
	
	public class HealthBar extends MovieClip {
		const HEALTH_BAR_WIDTH = 30;
		
		public var color:Number;
		
		public function HealthBar() {
			color = health_bar_mc.transform.colorTransform.color;
			this.visible = false;
		}
		
		public function Update(ratio:Number) {
			this.visible = true;
			health_bar_mc.width = ratio * HEALTH_BAR_WIDTH;
		}
		
		public function SetColor(newColor:Number) {
			var colorTransform:ColorTransform = health_bar_mc.transform.colorTransform;
			colorTransform.color = newColor;
			health_bar_mc.transform.colorTransform = colorTransform;
			color = newColor;
		}
	}	
}
