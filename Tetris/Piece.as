package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Piece extends MovieClip {
		public const SIZE = 4;
		
		public var color:Number = 0;
		public var grid_color:Number = 0;
		public var blocks:Array = new Array();
		public var ghost:Boolean = false;

		public function Piece() {
			for (var i=0; i<SIZE; i++)
				blocks[i] = new Array();
			
			ResetBlocksArray();
		}
		
		public function RotateCW() {
			var piece = new Array();
			for (var row=0; row<SIZE; row++) {
				for (var col=0; col<SIZE; col++) {
					if (blocks[row][col] != null) {
						piece.push(blocks[row][col]);
					}
				}
			}
			ResetBlocksArray();
			for each(var block in piece) {
				var temp = block.col;
				block.col = SIZE-1-block.row;
				block.row = temp;
				blocks[block.row][block.col] = block;
				block.x = Block.size * block.col;
				block.y = Block.size * block.row
			}
			RemoveLeftSpace();
		}
		
		public function RotateCCW() {
			var piece = new Array();
			for (var row=0; row<SIZE; row++) {
				for (var col=0; col<SIZE; col++) {
					if (blocks[row][col] != null) {
						piece.push(blocks[row][col]);
					}
				}
			}
			ResetBlocksArray();
			for each(var block in piece) {
				var temp = block.row;
				block.row = SIZE-1-block.col;
				block.col = temp;
				blocks[block.row][block.col] = block;
				block.x = Block.size * block.col;
				block.y = Block.size * block.row
			}
			RemoveTopSpace();
		}
		
		function RemoveTopSpace() {
			while (CountRow(0) == 0) {
				for (var row=0; row<SIZE-1; row++)
					for (var col=0; col<SIZE; col++)
						blocks[row][col] = blocks[row+1][col];
				for (var col=0; col<SIZE; col++)
					delete blocks[SIZE-1][col];
			}
			Reposition();
		}
		
		function RemoveLeftSpace() {
			while (CountColumn(0) == 0) {
				for (var row=0; row<SIZE; row++)
					for (var col=0; col<SIZE-1; col++)
						blocks[row][col] = blocks[row][col+1];
				for (var row=0; row<SIZE; row++)
					delete blocks[row][SIZE-1];
			}
			Reposition();
		}
		
		function CountRow(row:Number):Number {
			//trace(row);
			var count = 0;
			for (var i=0; i<SIZE; i++)
				if (blocks[row][i] != null)
					count ++;
			return count;
		}
		
		function CountColumn(col:Number):Number {
			var count = 0;
			for (var i=0; i<SIZE; i++)
				if (blocks[i][col] != null)
					count ++;
			return count;
		}
		
		function FirstEmptyInCol(col:Number):Number {
			for (var row=SIZE-1; row >= 0 && blocks[row][col] == null; row--)
				;
			return row + 1;
		}
		
		function FirstEmptyInRow(row:Number):Number {
			for (var col=SIZE-1; col >= 0 && blocks[row][col] == null; col--)
				;
			return col + 1;
		}
		
		function LastEmptyInRow(row:Number):Number {
			for (var col=0; col < SIZE && blocks[row][col] == null; col++)
				;
			return col - 1;
		}
		
		public function ResetBlocksArray() {
			for (var row=0; row<SIZE; row++)
				for (var col=0; col<SIZE; col++)
					delete blocks[row][col];
		}
		
		function Reposition() {
			for (var row=0; row<SIZE; row++) {
				for (var col=0; col<SIZE; col++) {
					if (blocks[row][col] != null) {						
						blocks[row][col].y = Block.size * row;
						blocks[row][col].x = Block.size * col;
						blocks[row][col].row = row;
						blocks[row][col].col = col;
					}
				}
			}
		}
		
		function AddBlock(row:Number, column:Number, newColor:Number) {
			var block = new Block(newColor);
			block.row = row;
			block.col = column;
			block.y = Block.size * row;
			block.x = Block.size * column;
			blocks[row][column] = block;
			
			addChild(block);
		}
		
		public function debug() {
			trace(this);
			for (var row=0; row<SIZE; row++) {
				var output:String = "";
				for (var col=0; col<SIZE; col++) {
					if (blocks[row][col] != null)
						output+="o";
					else
						output+=" ";
				}
				trace(output);
			}
		}
	}
	
}
