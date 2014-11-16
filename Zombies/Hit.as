package  {
	
	import flash.media.Sound;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	
	public class Hit extends Sound {
		
		public var Playing:Boolean = false;
		var soundChannel:SoundChannel;
		
		public function Hit() {
			// constructor code
		}
		
		public function Play() {
			soundChannel = this.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE, Loop);
			Playing = true;
		}
		
		public function Stop() {
			if (Playing)
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, Loop);
			Playing = false;
		}
		
		function Loop(e:Event) {
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, Loop);
			Play();
		}
		
	}
	
}
