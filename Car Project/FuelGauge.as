package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	public class FuelGauge extends MovieClip {
		const ANGLE = 140;
		var carRef:MovieClip;
		
		public function FuelGauge(car:MovieClip) {
			carRef = car;
			this.addEventListener(MouseEvent.ROLL_OVER, over);
			this.addEventListener(MouseEvent.ROLL_OUT, out);
			this.addEventListener(MouseEvent.CLICK, Reset);
		}
		
		public function UpdateValue(percentage:Number) {
			needle_mc.rotation = (ANGLE-180)/2 - ANGLE + ANGLE * percentage;
		}
		
		public function Reset(e:MouseEvent) {
			var myTween:Tween = new Tween(needle_mc, "rotation", Bounce.easeOut, needle_mc.rotation, (ANGLE-180)/2, 2, true);
			myTween.addEventListener(TweenEvent.MOTION_FINISH, ResetFuel);
		}
		
		function ResetFuel(e:TweenEvent) {
			carRef.fuel = carRef.INITIAL_FUEL;
		}
		
		function over(e:MouseEvent) {
			Mouse.cursor = "button";
		}
		
		function out(e:MouseEvent) {
			Mouse.cursor = "arrow";
		}
	}
	
}
