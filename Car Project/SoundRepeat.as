package  {
	
	import flash.media.Sound;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;	
	
	public class SoundRepeat extends Sound {
		
		public var Playing:Boolean = false;
		public var Repeat:Boolean = true;
		var Volume:Number = 1;
		var soundChannel:SoundChannel;
		
		public function SoundRepeat() {
			// constructor code
		}
		
		public function Play() {
			if (Playing == false) {
				soundChannel = this.play();
				soundChannel.addEventListener(Event.SOUND_COMPLETE, Loop);
				Playing = true;
				SetVolume(Volume);
			}
		}
		
		public function Stop() {
			if (Playing) {
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, Loop);
				soundChannel.stop();
				Playing = false;
			}
		}
		
		function Loop(e:Event) {
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, Loop);
			Playing = false;
			if (Repeat)
				Play();
		}
		
		function SetVolume(newVolume:Number) {
			Volume = newVolume;
			if (Playing) {
				var myTransform:SoundTransform = new SoundTransform();
				myTransform.volume = Volume;
				soundChannel.soundTransform = myTransform;
			}
		}
	}
}
