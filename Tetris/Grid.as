package  {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import ColorUtil;
	
	public class Grid extends MovieClip {
		public static const WIDTH = 10;
		public static const HEIGHT = 20;
		
		const GHOST_OPACITY = 0.5;
		const GRID_DARKEN = 10; // in % of original block color
		
		var background:Sprite = new Sprite();
		var grid:Array = new Array();
		var piece:Piece = new Piece();
		var ghost:Piece = new Piece();
		var p:Object;
		
		public function Grid(parentRef:Object) {
			p = parentRef;
			addChild(ghost);
			
			for (var i=0; i<HEIGHT; i++)
				grid[i] = new Array();
			
			addChild(background);
			background.x = 0;
			background.y = 0;
			background.graphics.beginFill(0x1a1a1a);
			background.graphics.drawRect(0, 0, WIDTH * Block.size, HEIGHT * Block.size);
			background.graphics.lineStyle(3, 0x000000, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 0);
			for (var row=1; row<HEIGHT; row++) {
				background.graphics.moveTo(0, Block.size*row); 
				background.graphics.lineTo(Block.size*WIDTH-1, Block.size*row);
			}
			for (var col=1; col<WIDTH; col++) {
				background.graphics.moveTo(Block.size*col, 0); 
				background.graphics.lineTo(Block.size*col, Block.size*HEIGHT-1);
			}
			background.graphics.endFill();
		}
		
		public function NewPiece(nextID:Number) {
			piece.ResetBlocksArray();
			piece = new p.pieceTypes[nextID];
			piece.x = Math.floor((WIDTH-2)/ 2) * Block.size ;
			piece.y = 0;
			removeChild(ghost);
			ghost.ResetBlocksArray();
			ghost = new p.pieceTypes[nextID];
			ghost.ghost = true;
			ghost.alpha = GHOST_OPACITY;
			ResetGhost();
			//piece.debug();
			addChild(ghost);
			addChild(piece);
		}
		
		function ScanGrid() {
			var fullRow;
			var rowsRemoved = 0;
			do {
				fullRow = false;
				for (var row=HEIGHT-1; row>=0; row --) {
					if (!fullRow) { // Look for a full row
						fullRow = true;
						for (var col=0; col<WIDTH; col++) {
							if (grid[row][col] == null) {
								fullRow = false;
								break;
							}
						}
						if (fullRow) {
							for (var col=0; col<WIDTH; col++) {
								//trace("removing "+row+","+col);
								removeChild(grid[row][col]);
								delete grid[row][col];
							}
						}
					}
					else { // Full row found, move everything else down
						for (var col=0; col<WIDTH; col++) {
							grid[row+1][col] = grid[row][col];
							if (grid[row+1][col] != null) {
								//trace((row+1)+","+col+" <-- "+row+","+col);
								grid[row+1][col].y = (row+1)*Block.size;
								grid[row+1][col].x = (col)*Block.size;
							}
						}
					}
				}
				if (fullRow)
					rowsRemoved ++;
			} while (fullRow);
			p.score += rowsRemoved * rowsRemoved;
		}
		
		function MoveLeft() {
			var move = false;
			if (piece.x > 0)
				move = true;
			
			for (var row=0; row<piece.SIZE; row++)
				if (piece.LastEmptyInRow(row) < piece.SIZE-1 && grid[piece.y/Block.size+row][piece.x/Block.size+piece.LastEmptyInRow(row)] != null)
					move = false;
			
			if (move)
				piece.x -= Block.size;
			
			ResetGhost();
		}
		
		function MoveRight() {
			var move = false;
			if (WIDTH - piece.x/Block.size <= piece.SIZE) {
				if (piece.CountColumn(WIDTH - 1 - piece.x/Block.size) == 0)
					move = true;
			}
			else
				move = true;
			
			for (var row=0; row<piece.SIZE; row++)
				if (piece.FirstEmptyInRow(row) > 0 && grid[piece.y/Block.size+row][piece.x/Block.size+piece.FirstEmptyInRow(row)] != null)
					move = false;
			
			if (move)
				piece.x += Block.size;
			
			ResetGhost();
		}
		
		function MoveDown(aPiece:Piece):Boolean {
			
			//trace(piece.y/Block.size, piece.x/Block.size);
			var move = true;
			if (HEIGHT - aPiece.y/Block.size <= aPiece.SIZE && aPiece.CountRow(HEIGHT - 1 - aPiece.y/Block.size) > 0) {
				if (!aPiece.ghost)
					AddPieceToGrid();
				move = false
			}
			else {
				for (var col=0; col<aPiece.SIZE; col++)
					if (aPiece.FirstEmptyInCol(col) > 0 && grid[aPiece.y/Block.size+aPiece.FirstEmptyInCol(col)][aPiece.x/Block.size+col] != null)
						move = false;
				if (move)
					aPiece.y += Block.size;					
				else if (!aPiece.ghost)
					AddPieceToGrid();
			}
			BoundariesCheck();
			if (!aPiece.ghost && move) {
				p.frameCount = 0;
				ResetGhost();
			}
			return move;
		}
		
		function Drop(aPiece:Piece) {
			while (MoveDown(aPiece))
			{}
		}
		
		function AddPieceToGrid() {
			for (var row=0; row<piece.SIZE; row++) {
				for (var col=0; col<piece.SIZE; col++) {
					if (piece.blocks[row][col] != null) {
						AddBlockToGrid(piece.y/Block.size+row, piece.x/Block.size+col, piece.grid_color);
					}
				}
			}
			ScanGrid();
			removeChild(piece);
			p.NewPiece();
		}
		
		function AddBlockToGrid(row:Number, column:Number, newColor:Number) {
			//var block = new Block(ColorUtil.darkenColor(newColor, GRID_DARKEN));
			var block = new Block(newColor);
			block.row = row;
			block.col = column;
			block.y = Block.size * row;
			block.x = Block.size * column;
			grid[row][column] = block;
			
			addChild(block);
		}
		
		function ResetGhost() {
			ghost.x = piece.x;
			ghost.y = piece.y;
			Drop(ghost);
		}
		
		function BoundariesCheck() {
			while (WIDTH - piece.x/Block.size < piece.SIZE && piece.CountColumn(WIDTH - piece.x/Block.size) > 0)
					MoveLeft();
		}
		
		public function key_down(e:KeyboardEvent) {
			if (p.playing) {
				switch (e.keyCode) {
					case Keyboard.LEFT:
						MoveLeft();
						break;
					case Keyboard.RIGHT:
						MoveRight();
						break;
					case Keyboard.UP:
						piece.RotateCW();
						ghost.RotateCW();
						ResetGhost();
						BoundariesCheck();
						break;
					case Keyboard.DOWN:
						MoveDown(piece);
						break;
					case Keyboard.SPACE:
						Drop(piece);
						break;
				}
			}
		}
	}
	
}
