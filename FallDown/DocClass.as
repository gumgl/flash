package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flashx.textLayout.formats.BlockProgression;
	
	public class DocClass extends MovieClip {
		const BLOCK_HEIGHT = 15; // in pixels
		const BLOCK_SPEED = 10; // in pixels/frame
		const BLOCK_DISTANCE = 150; // vertical distance between levels, in pixels
		const PLAYER_SPEED = 20; // in pixels/frame
		const WINDOW_WIDTH = 100; // space that player has to go through, in pixels
		const ROWS_COUNT = Math.ceil(stage.stageHeight / (BLOCK_HEIGHT + BLOCK_DISTANCE)); // Number of blocks that should appear on screen
		
		var blocksLeft:Array = new Array();
		var blocksRight:Array = new Array();
		var keysDown:Array = new Array();
		var player:Player = new Player();
		var playerRadius = player.width/2;
		
		public function DocClass() {
			trace("Row Count:", ROWS_COUNT);
			
			player.x = stage.stageWidth / 2; // Horizontal center
			player.y = playerRadius;
			//player.y = stage.stageHeight - player.height; // Vertical bottom
			stage.addChild(player);
			
			stage.addEventListener(Event.ENTER_FRAME, Frame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyUp);
			
			AddRow();
		}
		
		function Frame(e:Event) {
			// Move blocks up
			for each(var block in blocksLeft)
				block.y -= BLOCK_SPEED;
			for each(var block in blocksRight)
				block.y -= BLOCK_SPEED;
			
			// Move player left/right
			if (keysDown[Keyboard.A] || keysDown[Keyboard.LEFT]) {
				player.x -= PLAYER_SPEED;
				player.rotation -= PLAYER_SPEED / (player.width * Math.PI) * 180;
			}
			if (keysDown[Keyboard.D] || keysDown[Keyboard.RIGHT]) {
				player.x += PLAYER_SPEED;
				player.rotation += PLAYER_SPEED / (player.width * Math.PI) * 180;
			}
			if (player.x < playerRadius)
				player.x = playerRadius;
			else if (player.x > stage.stageWidth - playerRadius)
				player.x = stage.stageWidth - playerRadius;
			
			// Add rows
			if (blocksLeft.length < ROWS_COUNT && blocksLeft[blocksLeft.length - 1].x + BLOCK_HEIGHT < stage.stageHeight - BLOCK_DISTANCE) {
				AddRow();
			}
			else if (blocksLeft[0].y + BLOCK_HEIGHT <= 0) {// Check if top row is out of screen
				RemoveTopRow();
				AddRow(); // Add a new row at bottom of screen
			}
			
			// Check if player should go down
			var collision:Boolean = false;
			for (var i in blocksLeft) { // For all blocks
				if (player.hitTestObject(blocksLeft[i]) || player.hitTestObject(blocksRight[i])) { // Player touching a block
					//if (blocksLeft[i].y + BLOCK_SPEED - playerRadius + 2 <= player.y) { // Player is over a block (not in window)
						collision = true;
						player.y = blocksLeft[i].y - playerRadius;
						break;
					//}
				}
			}
			if (!collision)
				player.y += PLAYER_SPEED;
			if (player.y > stage.stageHeight - playerRadius)
				player.y = stage.stageHeight - playerRadius;
			
			/*var rowIndex;
			for (rowIndex in blocksLeft) // Find block row to look compare positions
				if (blocksLeft[rowIndex].y > player.y) // We found the first row that is below player
					break;
			trace("Row Index: "+rowIndex+"/"+blocksLeft.length);
			// Move player up
			if (player.y < stage.stageHeight - (BLOCK_HEIGHT + BLOCK_DISTANCE))
				player.y = blocksLeft[rowIndex].y - player.height;
			else
				player.y = stage.stageHeight - player.height;
			
			if (blocksLeft[rowIndex].width < player.x && player.x + player.width < blocksRight[rowIndex].x) {
				player.y = blocksLeft[rowIndex].y - player.height + BLOCK_HEIGHT + BLOCK_DISTANCE;
			}*/
		}
		
		function AddRow() {
			var posY:Number;
			if (blocksLeft.length > 0)
				posY = blocksLeft[blocksLeft.length - 1].y + BLOCK_HEIGHT + BLOCK_DISTANCE;
			else
				posY = stage.stageHeight;
			var windowX = Math.floor(Math.random() * (stage.stageWidth - WINDOW_WIDTH));
			var blocks:Array = new Array();
			
			for (var i=1; i<=2; i++) {
				var block:Block = new Block();
				block.y = posY;
				block.height = BLOCK_HEIGHT;
				stage.addChild(block);
				blocks.push(block);
			}
			blocks[0].x = 0;
			blocks[0].width = windowX;
			blocksLeft.push(blocks[0]);
			
			blocks[1].x = windowX + WINDOW_WIDTH;
			blocks[1].width = stage.stageWidth - blocks[1].x;
			blocksRight.push(blocks[1]);
			
		}
		
		function RemoveTopRow() {
			stage.removeChild(blocksLeft[0]);
			stage.removeChild(blocksRight[0]);
			blocksLeft.splice(0, 1);
			blocksRight.splice(0, 1);
		}
		
		function KeyDown(e:KeyboardEvent) {
			keysDown[e.keyCode] = true;
		}
		
		function KeyUp(e:KeyboardEvent) {
			keysDown[e.keyCode] = false;
		}
	}	
}
