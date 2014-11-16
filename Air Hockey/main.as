package  {
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	
	
	public class main extends MovieClip {
		
		public function main() {
			// constructor code
			this.addEventListener(Event.ENTER_FRAME, HitTest);
			this.addEventListener(Event.ENTER_FRAME, MoveComputer);
			Mouse.hide();
		}
		
		function HitTest(e:Event) {
			var player:Point = new Point(player_mc.x, player_mc.y);
			var pc:Point = new Point(pc_mc.x, pc_mc.y);
			var puck:Point = new Point(puck_mc.x, puck_mc.y);
			var radians_player = Math.atan2(puck.y - player.y, player.x - puck.x); // puck is the center
			var radians_pc = Math.atan2(puck.y - pc.y, pc.x - puck.x); // puck is the center
			//trace(puck_mc.speed);
			//trace("radians: pi*"+(radians+Math.PI)/Math.PI);
			//trace("angle: pi*"+puck_mc.angle/Math.PI);
			//trace(Math.round(puck_mc.angle * 100) - Math.round(radians * 100) - 2*Math.PI);
			if (Point.distance(player, puck) <= player_mc.width/2+puck_mc.width/2 && Math.abs(Math.round((puck_mc.angle - (radians_player+Math.PI)) * 100)) > 10) { // Hit b/w Player & Puck
				puck_mc.angle = radians_player + Math.PI; // opposite direction
				puck_mc.speed += player_mc.speed * 0.75;
			}
			if (Point.distance(pc, puck) <= pc_mc.width/2+puck_mc.width/2 && Math.abs(Math.round((puck_mc.angle - (radians_pc+Math.PI)) * 100)) > 10) { // Hit b/w Computer & Puck
				puck_mc.angle = radians_pc + Math.PI; // opposite direction
				if (puck_mc.speed <= 20)
					puck_mc.speed += pc_mc.speed * 0.75;
			}
		}
		
		function MoveComputer(e:Event) {
			if (puck_mc.x - pc_mc.x > pc_mc.speed)
				pc_mc.x += pc_mc.speed;
			else if (pc_mc.x - puck_mc.x > pc_mc.speed)
				pc_mc.x -= pc_mc.speed;
		}
	}
	
}
