package  {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
    import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.*;
    import flash.geom.ColorTransform;
	import flash.ui.Keyboard;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	TweenPlugin.activate([TintPlugin]);
	
	public class DocClass extends MovieClip {
		const ANIMATION = 0.5; // Animation duration in seconds
		const MINIMUM_SIZE = 2;
		var shapeTypes:Array = new Array(Circle, Octagon, Square, Diamond, Star8, Star16);
		var shapeID:Number = 0;
		var canvas:Sprite = new Sprite();
		var shapes:Array = new Array();
		
		public function DocClass() {
			stage.addChild(canvas);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, function(){StageResize();});
			StageResize();
			Init();
		}
		
		function Init() {
			for each (var shape in shapes) {
				shape.removeEventListener(MouseEvent.MOUSE_OVER, StartSplit);
				canvas.removeChild(shape); 
			}
			shapes.splice(0, shapes.length);
			/*stage.removeChild(canvas);
			canvas = new Sprite();
			stage.addChild(canvas);*/
			AddShape(stage.stageWidth / 2, stage.stageHeight / 2, stage.stageWidth, stage.stageHeight, null);
		}
		
		function AddShape(posX, posY, W:Number, H:Number, origin:MovieClip) {
			var shape:MovieClip = new shapeTypes[shapeID];
			shape.width = W;
			shape.height = H;
			if (origin != null) {
				var distanceX = Math.sqrt(2)/2 * origin.width / 4;
				var distanceY = Math.sqrt(2)/2 * origin.height / 4;
				if (posX < origin.x)
					distanceX *= -1;
				if (posY < origin.y)
					distanceY *= -1;
				shape.x = origin.x+distanceX;
				shape.y = origin.y+distanceY;
				shape.transform.colorTransform = origin.transform.colorTransform;
				var oldColor = origin.transform.colorTransform.color;
				var newColor = Math.random() * 0xFFFFFF;
				var myTween:TweenLite = TweenLite.to(shape, ANIMATION, {ease:Linear.easeNone, tint: newColor, x:posX, y:posY, onComplete:EndAddShape, onCompleteParams:[shape]});
			} else {
				var colorTransform:ColorTransform = shape.transform.colorTransform;
				colorTransform.color = Math.random() * 0xFFFFFF;
				shape.transform.colorTransform = colorTransform;
				shape.x = posX;
				shape.y = posY;
				shape.addEventListener(MouseEvent.MOUSE_OVER, StartSplit);
			}
			canvas.addChild(shape);
			shapes.push(shape);
		}
		
		function EndAddShape(shape:MovieClip) {
			if (shape.width > MINIMUM_SIZE)
				shape.addEventListener(MouseEvent.MOUSE_OVER, StartSplit);
		}
		
		function StartSplit(e:MouseEvent) {
			var origin = DisplayObject(e.target);
			var W = origin.width/2;
			var H = origin.height/2;
			AddShape(origin.x - origin.width / 4, origin.y - origin.height / 4, W, H, origin);
			AddShape(origin.x - origin.width / 4, origin.y + origin.height / 4, W, H, origin);
			AddShape(origin.x + origin.width / 4, origin.y - origin.height / 4, W, H, origin);
			AddShape(origin.x + origin.width / 4, origin.y + origin.height / 4, W, H, origin);
						
			var myTween:TweenLite = TweenLite.to(origin, ANIMATION, {ease:Linear.easeNone, alpha:0, width:origin.width/2, height:origin.height/2, onComplete:EndSplit, onCompleteParams:[origin]});
			origin.removeEventListener(MouseEvent.MOUSE_OVER, StartSplit);
		}
		function EndSplit(origin:MovieClip) {
			origin.visible = false;
			//canvas.removeChild(origin);			
		}
		
		function KeyDown(e:KeyboardEvent) {
			switch (e.keyCode) {
				case Keyboard.LEFT:
					if (shapeID > 0)
						shapeID --;
					else
						shapeID = shapeTypes.length - 1;
					break;
				case Keyboard.RIGHT:
					if (shapeID < shapeTypes.length - 1)
						shapeID ++;
					else
						shapeID = 0;
					break;
				case Keyboard.SPACE: case Keyboard.ENTER: case Keyboard.BACKSPACE:
					Init();
					break;
			}
		}
		
		function StageResize() {
			background_mc.width = stage.stageWidth;
			background_mc.height = stage.stageHeight;
		}
	}
	
}
