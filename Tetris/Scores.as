package  {
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.net.*;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	
	public class Scores extends MovieClip {
		const PHP_PASSWORD = "oG6M6n9R"; // password to access database
		
		public var IsOpen:Boolean = false;
		
		var score:Number;
		var s:Stage;
		var p:Object;
		
		public function Scores(theStage:Stage, Parent:Object) {
			// constructor code
			s = theStage;
			p = Parent;
			
			var myformat:TextFormat = link.getTextFormat();
			myformat.underline = true;
			link.setTextFormat(myformat);
			
			btnSubmit.addEventListener(MouseEvent.CLICK, Submit);
			btnCancel.addEventListener(MouseEvent.CLICK, function(){Close();});
		}
		
		public function Open(playerScore:Number, accuracy:Number, zombiesKilled:Number, duration:Number) {
			IsOpen = true;
			Mouse.show();
			score = playerScore;
			this.x = s.stageWidth / 2 - this.width / 2;
			this.y = s.stageHeight / 2 - this.height / 2;
			s.addChild(this);
			lblTime.text = String(Math.floor(duration / 3600)) + "h " + String(Math.floor(duration / 60)) + "m " + String(duration) + "s";
			lblZombies.text = String(zombiesKilled);
			lblAccuracy.text = String(accuracy) + " %";
			lblScore.text = String(score) + " points";
		}
		
		function Submit(e:MouseEvent) {
			if (txtName.text.length > 0) {
				var filename:String = LoaderInfo(this.root.loaderInfo).url.split("/").pop();
				//trace("password="+PHP_PASSWORD+"&username="+escape(txtName.text)+"&score="+String(score));
				var url_variables:URLVariables = new URLVariables("game="+filename+"&password="+PHP_PASSWORD+"&username="+escape(txtName.text)+"&score="+String(score));
			
				var url_request:URLRequest = new URLRequest("scores.php");
				url_request.method = URLRequestMethod.POST;
				url_request.data = url_variables;
				
				var url_loader:URLLoader = new URLLoader();
				url_loader.dataFormat = URLLoaderDataFormat.TEXT;
				url_loader.addEventListener(Event.COMPLETE, function(){Close();});
				url_loader.addEventListener(IOErrorEvent.IO_ERROR, function(){Close();});
				url_loader.load(url_request);
				p.NewGame();
			}
		}
		
		function Close() {
			IsOpen = false;
			s.removeChild(this);
			Mouse.hide();
			p.NewGame();
		}
	}
	
}
