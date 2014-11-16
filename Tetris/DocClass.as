package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	
	public class DocClass extends MovieClip {
		public var pieceTypes:Array = new Array(I, J, L, O, S, T, Z);
		
		var playing:Boolean = true;
		var grid_mc:Grid = new Grid(this);
		var playpause_mc = new PlayPause();
		var nextPiece:Piece;
		var nextID:Number;
		var frameCount:Number = 0;
		var score:Number = 0;
		
		public function DocClass() {
			grid_mc.x = (stage.stageWidth - grid_mc.width) / 2;
			grid_mc.y = 100;
			stage.addChild(grid_mc);
			playpause_mc.x = (stage.stageWidth - playpause_mc.width) / 2;
			playpause_mc.y = (stage.stageHeight - playpause_mc.height) / 2;
			stage.addChild(playpause_mc);
			playpause_mc.gotoAndStop(0);
			
			nextID = Math.floor(Math.random()*pieceTypes.length);
			nextPiece = new pieceTypes[nextID];
			stage.addChild(nextPiece);
			NewPiece();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, grid_mc.key_down);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			addEventListener(Event.ENTER_FRAME, Frame);
		}
		
		public function NewPiece() {
			score_txt.text = score+"";
			
			stage.removeChild(nextPiece);
			grid_mc.NewPiece(nextID);
			nextID = Math.floor(Math.random()*pieceTypes.length)
			nextPiece.ResetBlocksArray();
			nextPiece = new pieceTypes[nextID];
			nextPiece.x = 10;
			nextPiece.y = 140;
			stage.addChild(nextPiece);
		}
		
		function Frame(e:Event) {
			if (playing) {
				frameCount ++;
				if (frameCount%(stage.frameRate/2) == 0)
					grid_mc.MoveDown(grid_mc.piece);
			}
		}
		
		function key_down(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.P) {
				playing = !(playing);
				if (playing)
					playpause_mc.gotoAndPlay(2);
				else
					playpause_mc.gotoAndPlay(12);
			}
		}
	}
	
}
