package 
{

	import flash.display.MovieClip;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;

	public class DocClass extends MovieClip
	{
		const ANIMATION_TIME = 1.5; // switching gems (in seconds)
		var NumTypes:Number = 4;
		var BoardSize:Number = 8;
		var Type:Array = [Square,Circle,Triangle,Diamond];
		var Board:Array = new Array(BoardSize);
		var FirstGemClicked:Boolean = false;
		var FirstGemRow:Number;
		var FirstGemCol:Number;
		var BorderRef:Border = new Border  ;

		public function DocClass()
		{
			BorderRef.visible = false;
			stage.addChild(BorderRef);

			for (var i = 0; i < Board.length; i++)
			{
				Board[i] = new Array(BoardSize);
			}

			for (var i = 0; i < BoardSize; i++)
			{
				for (var j = 0; j < BoardSize; j++)
				{
					var RandomSlot:Number = Math.floor(Math.random() * NumTypes);
					var NextGem:Gem = new Type[RandomSlot  ];
					NextGem.Row = i;
					NextGem.Column = j;
					Board[i][j] = NextGem;
					NextGem.addEventListener(MouseEvent.MOUSE_DOWN, SwapGems);
					NextGem.y = i * 35;
					NextGem.x = j * 35;
					NextGem.width = 25;
					NextGem.height = 25;
					stage.addChild(NextGem);
				}
			}

		}

		public function SwapGems(e:MouseEvent):void
		{
			if (FirstGemClicked)
			{
				if (Math.abs(e.target.Row - FirstGemRow) + Math.abs(e.target.Column - FirstGemCol) == 1)
				{
					var Temp = Board[FirstGemRow][FirstGemCol];
					Temp.Row = e.target.Row;
					Temp.Column = e.target.Column;
					Board[FirstGemRow][FirstGemCol] = Board[e.target.Row][e.target.Column];
					e.target.Row = FirstGemRow;
					e.target.Column = FirstGemCol;
					Board[Temp.Row][Temp.Column] = Temp;
					var myTween1:Tween = new Tween(e.target, "y", Strong.easeOut, e.target.y, e.target.Row * 35, ANIMATION_TIME, true);
					var myTween2:Tween = new Tween(e.target, "x", Strong.easeOut, e.target.x, e.target.Column * 35, ANIMATION_TIME, true);
					var myTween3:Tween = new Tween(Temp, "y", Strong.easeOut, Temp.y, Temp.Row * 35, ANIMATION_TIME, true);
					var myTween4:Tween = new Tween(Temp, "x", Strong.easeOut, Temp.x, Temp.Column * 35, ANIMATION_TIME, true);
				}
				FirstGemClicked = false;
				BorderRef.visible = false;
			}
			else
			{
				FirstGemRow = e.target.Row;
				FirstGemCol = e.target.Column;
				FirstGemClicked = true;
				addBorder(e.target);
			}
		}

		public function addBorder(Target:Object):void
		{			
			BorderRef.x = Target.Column * 35;
			BorderRef.y = Target.Row * 35;
			BorderRef.visible = true;
		}

	}

}