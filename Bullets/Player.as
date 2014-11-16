package {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	 
	public class Player extends MovieClip {
		
		public var speed = 4;
		public var angle = 0;
		public var bullets:Array = new Array();
		var keyCode = 0;
		var IsKeyDown:Array = new Array();
		var IsMouseDown:Boolean = false;
		
		public function Player() {
			stage.addEventListener(Event.ENTER_FRAME, Move);
			stage.addEventListener(Event.ENTER_FRAME, RemoveBullets);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, function(){Turn();});
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
			
			for (var i = 0; i < 128; i ++)
				IsKeyDown[i] = false;
		}
		
		public function RemoveBullets(e:Event) {
			for (var i = 0; i < bullets.length; i ++) {
				if (bullets[i] != null) {
					if (bullets[i].x < 0 || 
						bullets[i].y < 0 || 
						bullets[i].x > stage.stageWidth || 
						bullets[i].y > stage.stageHeight) {
						bullets[i].removeEventListener(Event.ENTER_FRAME, Move);
						stage.removeChild(bullets[i]);
						delete bullets[i];
					}
				}
			}
		}
		
		function key_down(e:KeyboardEvent) {
			IsKeyDown[e.keyCode] = true;
		}
		
		function key_up(e:KeyboardEvent) {
			IsKeyDown[e.keyCode] = false;
		}
		
		function mouse_down(e:MouseEvent) {
			IsMouseDown = true;
			this.addEventListener(Event.ENTER_FRAME, Shoot);
		}
		
		function mouse_up(e:MouseEvent) {
			IsMouseDown = false;
			this.removeEventListener(Event.ENTER_FRAME, Shoot);
		}
		
		function Shoot(e:Event) {
			var aBullet:Bullet = new Bullet();
			aBullet.x = this.x + Math.cos(angle) * this.width/2;
			aBullet.y = this.y + Math.sin(angle) * this.width/2;
			aBullet.speed = speed * 2;
			aBullet.angle = angle;
			aBullet.rotation = this.rotation;
			stage.addChild(aBullet);
			stage.setChildIndex(aBullet, 1);
			addBulletToArray(aBullet);
		}
		
		function Move(e:Event) {
			if (IsKeyDown[87] || IsKeyDown[38]) // Up
				this.y -= speed;
			if (IsKeyDown[68] || IsKeyDown[39]) // Right
				this.x += speed;
			if (IsKeyDown[83] || IsKeyDown[40]) // Down
				this.y += speed;
			if (IsKeyDown[65] || IsKeyDown[37]) // Left
				this.x -= speed;
			Turn();
		}
		
		function Turn() {
			angle = Math.atan2((stage.mouseY - this.y),(stage.mouseX - this.x));
			this.rotation = angle * 180 / Math.PI;
		}
		
		function addBulletToArray(aBullet:Bullet) {
			for (var i = 0; i < bullets.length; i ++) {
				if (bullets[i] == null) {
					aBullet.positionInArray = i;
					bullets[i] = aBullet;
				}
			}
		}
	}
}