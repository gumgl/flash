package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class DocClass extends MovieClip {
		
		var car_mc:RaceCar = new RaceCar(stage);
		var fuel_gauge_mc = new FuelGauge(car_mc);
		var BGs:Array = new Array();
		var tempBGs:Array = new Array();
		
		public function DocClass() {
			car_mc.x = stage.stageWidth/2;
			car_mc.y = stage.stageHeight/2;
			stage.addChild(car_mc);
			fuel_gauge_mc.x = fuel_gauge_mc.width / 2 + 10;
			fuel_gauge_mc.y = stage.stageHeight - fuel_gauge_mc.height/2 - 10;
			stage.addChild(fuel_gauge_mc);
			
			stage.addEventListener(Event.ENTER_FRAME, MoveBackground);
			
			for(var i = 0; i < 9; i ++) {
				var BG:Background = new Background();
				stage.addChild(BG);
				BGs[i] = BG;
			}
			ResetBackgrounds(0,0);
		}
		
		function MoveBackground(e:Event) {
			car_mc.Move();
			
			stage.setChildIndex(fuel_gauge_mc, stage.numChildren - 1);
			fuel_gauge_mc.UpdateValue(car_mc.fuel/car_mc.INITIAL_FUEL);
			
			var changeX = Math.cos(car_mc.angle + Math.PI) * car_mc.speed;
			var changeY = Math.sin(car_mc.angle + Math.PI) * car_mc.speed;
			for each (var BG in BGs) {
				BG.x += changeX;
				BG.y -= changeY;
			}
			
			if (BGs[2].x < 0) { // LEFT
				var relX = BGs[2].x;
				swap(BGs[0], BGs[1]);
				swap(BGs[3], BGs[4]);
				swap(BGs[6], BGs[7]);
				swap(BGs[1], BGs[2]);
				swap(BGs[4], BGs[5]);
				swap(BGs[7], BGs[8]);
				ResetBackgrounds(relX, BGs[6].y%stage.stageHeight);
			}
			else if (BGs[0].x > 0) { // RIGHT
				var relX = BGs[0].x;
				swap(BGs[1], BGs[2]);
				swap(BGs[4], BGs[5]);
				swap(BGs[7], BGs[8]);
				swap(BGs[0], BGs[1]);
				swap(BGs[3], BGs[4]);
				swap(BGs[6], BGs[7]);
				ResetBackgrounds(relX, BGs[6].y%stage.stageHeight);
			}
			if (BGs[6].y < 0) { // UP
				var relY = BGs[6].y;
				swap(BGs[0], BGs[3]);
				swap(BGs[1], BGs[4]);
				swap(BGs[2], BGs[5]);
				swap(BGs[3], BGs[6]);
				swap(BGs[4], BGs[7]);
				swap(BGs[5], BGs[8]);
				ResetBackgrounds(BGs[2].x%stage.stageWidth, relY);
			}
			else if (BGs[0].y > 0) { // DOWN
				var relY = BGs[0].y;
				swap(BGs[3], BGs[6]);
				swap(BGs[4], BGs[7]);
				swap(BGs[5], BGs[8]);
				swap(BGs[0], BGs[3]);
				swap(BGs[1], BGs[4]);
				swap(BGs[2], BGs[5]);
				ResetBackgrounds(BGs[2].x%stage.stageWidth, relY);
			}
		}
		
		function ResetBackgrounds(relX:Number, relY:Number) {
			for(var row = 0; row < 3; row ++) {
				for (var col = 0; col < 3; col ++) {
					BGs[3*row+col].x = stage.stageWidth * (col - 1) + relX;
					BGs[3*row+col].y = stage.stageHeight * (row - 1) + relY;
				}
			}
		}
		
		function swap(one:Object, two:Object) {
			var temp:Object = one;
			one = two;
			two = temp;
		}
	}
	
}
