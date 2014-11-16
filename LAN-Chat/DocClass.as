package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
    import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.GroupSpecifier;
	import flash.ui.Keyboard;
	
	public class DocClass extends MovieClip {
		private var nc:NetConnection;
		private var group:NetGroup;
		private var connected:Boolean = false;
		var message:Object = new Object();
		var groupspec:GroupSpecifier;
		
		public function DocClass() {
			
			btnSend.addEventListener(MouseEvent.CLICK, btnPressed);
			txtMessage.addEventListener(KeyboardEvent.KEY_UP, keyPressed);
			connect();
		}
		
		function connect() {
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			nc.connect("rtmfp:");
			
			txtUser.text = "user"+Math.round(Math.random()*1000);
			stage.focus = txtUser;
			txtUser.setSelection(0, txtUser.text.length);
		}
		
		function netStatus(event:NetStatusEvent) {
			//writeText("NetStatusEvent: "+event.info.code);
			
			switch(event.info.code) {
				case "NetConnection.Connect.Success":
					setupGroup();
					writeText("[Connecting...]");
					break;
				case "NetGroup.Connect.Success":
					connected = true;
					writeText("[Connection Successful]");
					//trace(nc.farID);
					trace(nc.nearID);
					break;
				case "NetGroup.Connect.Failed":
					connected = true;
					writeText("[Connection Failed]");
					break;
				case "NetGroup.Neighbor.Connect":
					writeText("[Peer Connected]" + event.info.peerID);
					break;
				case "NetGroup.Neighbor.Disconnect":
					writeText("[Peer Disconnected]");
					break;
				case "NetConnection.Connect.NetworkChange":
					connected = !connected;
					if (connected)
						writeText("[You disconnected]");
					else
						writeText("[You re-connected]");
					break;
				case "NetGroup.Posting.Notify":
					receiveMessage(event.info.message)
					break;
			}
		}
		
		function setupGroup() {
			groupspec = new GroupSpecifier("myGroup/groupOne");
			groupspec.postingEnabled = true;
			groupspec.ipMulticastMemberUpdatesEnabled = true;
			groupspec.addIPMulticastAddress("225.225.0.1:30303");

			group = new NetGroup(nc,groupspec.groupspecWithAuthorizations());
			group.addEventListener(NetStatusEvent.NET_STATUS,netStatus);
		}
		
		function sendMessage(txt:String) {
			if (connected) {
				message.text = txt;
				message.sender = group.convertPeerIDToGroupAddress(nc.nearID);
				message.userName = txtUser.text;
				
				group.post(message);
				
				receiveMessage(message);
			}
		}
		
		function receiveMessage(message:Object) {
			writeText(message.userName+": "+message.text);
		}
		
		function writeText(txt:String) {
			txtHistory.text += "\n"+txt;
		}
		
		function btnPressed(e:MouseEvent) {
			sendMessage( txtMessage.text );
			txtMessage.text = "";
		}
		
		function keyPressed(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.ENTER) {
				sendMessage(txtMessage.text);
				txtMessage.text = "";
			}
		}
	}
	
}
