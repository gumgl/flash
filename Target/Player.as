package {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	 
	public class Player extends MovieClip {
		
		public var speed = 10;
		public var angle = 0;
		var keyCode = 0;
		
		public function Player() {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, function(){Turn();});
			stage.addEventListener(MouseEvent.CLICK, Shoot);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
		}
		
		function Shoot(e:MouseEvent) {
			var aBullet:Bullet = new Bullet();
			aBullet.x = this.x;
			aBullet.y = this.y;
			aBullet.speed = speed * 2;
			aBullet.angle = angle;
			aBullet.rotation = this.rotation;
			stage.addChild(aBullet);
		}
		
		function key_down(e:KeyboardEvent) {
			if (e.keyCode >= 37 && e.keyCode <= 40) // If arrow is pressed
			{
				keyCode = e.keyCode
				this.addEventListener(Event.ENTER_FRAME, Move);
			}
		}
		
		function key_up(e:KeyboardEvent) {
			this.removeEventListener(Event.ENTER_FRAME, Move);
		}
		
		function Move(e:Event) {
			switch (keyCode) {
				case 37: // Left
					this.x -= speed;
					break;
				case 38: // Up
					this.y -= speed;
					break;
				case 39: // Right
					this.x += speed;
					break;
				case 40: // Down
					this.y += speed;
					break;
			}
			Turn();
		}
		
		function Turn() {
			angle = Math.atan2((stage.mouseY - this.y),(stage.mouseX - this.x));
			this.rotation = angle * 180 / Math.PI;
		}
	}
}