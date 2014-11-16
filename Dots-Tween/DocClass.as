package  {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	public class DocClass extends MovieClip {
		const ANIMATION = 0.5; // Animation duration in seconds
		var tweens:Array = new Array();
		
		public function DocClass() {
			var circle = AddCircle(stage.stageWidth / 2, stage.stageHeight / 2, stage.stageWidth / 2, null);
		}
		
		function AddCircle(posX, posY, radius:Number, origin:Circle) {
			var circle:Circle = new Circle();
			circle.width = radius * 2;
			circle.height = radius * 2;
			stage.addChild(circle);
			if (origin != null) {
				var distanceX = Math.cos(Math.PI/4) * origin.width / 4;
				var distanceY = Math.sin(Math.PI/4) * origin.width / 4;
				if (posX < origin.x)
					distanceX *= -1;
				if (posY < origin.y)
					distanceY *= -1;
				var colorTransform:ColorTransform = origin.transform.colorTransform;
				var tweenX = new Tween(circle, "x", None.easeNone, origin.x + distanceX, posX, ANIMATION, true);
				var tweenY = new Tween(circle, "y", None.easeNone, origin.y + distanceY, posY, ANIMATION, true);
				tweenX.addEventListener(TweenEvent.MOTION_FINISH, EndAddCircle);
				tweens.push(tweenX);
				tweens.push(tweenY);
			} else {
				var colorTransform:ColorTransform = circle.transform.colorTransform;
				colorTransform.color = Math.random() * 0xFFFFFF;
				circle.x = posX;
				circle.y = posY;
				circle.addEventListener(MouseEvent.MOUSE_OVER, StartSplit);
			}
			circle.transform.colorTransform = colorTransform;
			//return circle;
		}
		
		function EndAddCircle(e:TweenEvent) {
			e.target.obj.addEventListener(MouseEvent.MOUSE_OVER, StartSplit);
			var colorTransform:ColorTransform = e.target.obj.transform.colorTransform;
			colorTransform.color = Math.random() * 0xFFFFFF;
			e.target.obj.transform.colorTransform = colorTransform;
		}
		
		function StartSplit(e:MouseEvent) {
			var origin = DisplayObject(e.target);
			var radius = origin.width/4;
			AddCircle(origin.x - origin.width / 4, origin.y - origin.height / 4, radius, origin);
			AddCircle(origin.x - origin.width / 4, origin.y + origin.height / 4, radius, origin);
			AddCircle(origin.x + origin.width / 4, origin.y - origin.height / 4, radius, origin);
			AddCircle(origin.x + origin.width / 4, origin.y + origin.height / 4, radius, origin);
			//var tweenAlpha = new Tween(origin, "alpha", None.easeNone, origin.alpha, 0, ANIMATION, true);
			var tweenW = new Tween(origin, "width", None.easeNone, origin.width, origin.width/2, ANIMATION, true);
			var tweenH = new Tween(origin, "height", None.easeNone, origin.height, origin.height/2, ANIMATION, true);
			tweenW.addEventListener(TweenEvent.MOTION_FINISH, EndSplit);
			//tweens.push(tweenAlpha);
			tweens.push(tweenW);
			tweens.push(tweenH);
			origin.removeEventListener(MouseEvent.MOUSE_OVER, StartSplit);
		}
		function EndSplit(e:TweenEvent) {
			stage.removeChild(e.target.obj);			
		}
	}
	
}
