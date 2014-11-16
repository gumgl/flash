package  {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class WeaponBase extends MovieClip {
		
		public var fireRate:Number; // in rounds/minute (works with fractions too!) (must be <= 60FPS)
		public var damage:Number;
		public var Name;
		public var speedFactor = 1;
		public var accuracy = 0; // In degrees. 0 = perfect accuracy
		public var price = 0;
		public var shots = 1; // Number of shots fired at a time
		public var soundFire:Sound;
		public var soundChannel:SoundChannel;
		public var soundRepeat:Boolean = false;
		public var soundPlaying:Boolean = false;
		
		var s:Stage;
		var p:Player;
		var bulletsFrame:Number;

		public function WeaponBase() {
			gotoAndStop(this.totalFrames);
			//TestNormal();
		}
		
		function BaseConstructor(theStage:Stage, player:Player) {
			s = theStage;
			p = player;
			bulletsFrame = 0;//60*s.frameRate/fireRate;
		}
		
		public function Shoot(bullets:Array) {
			/* from bulletRate to frames interval for 1 bullet
			  FPS = F/S
			  BPS = B/S
			B/BPS = F/FPS
			    F = FPS/BPS = FPM/BPM = 60*FPS/BPM
			*/			
			if (bulletsFrame >= 60*s.frameRate/fireRate && !p.gamePaused) {
				for (var i=1; i<=shots; i++) {
					var bullet:Bullet = new Bullet(p);
					
					if (accuracy == 0 || (bulletsFrame > 60*s.frameRate/fireRate + 1 && shots == 1)) // Perfect accuracy
						bullet.angle = p.angle;
					else
						bullet.angle = p.angle + (GaussRand(-0.5, 0.5, 3) * accuracy) / 180 * Math.PI;
					
					bullet.x = p.x + Math.cos(p.angle) * p.width/2;
					bullet.y = p.y - Math.sin(p.angle) * p.width/2;
					//aBullet.speed = p.speed * 3;
					bullet.rotation = -1 * bullet.angle * 180 / Math.PI;
					bullet.damage = damage;
					s.addChild(bullet);
					s.setChildIndex(bullet, s.getChildIndex(p));
					AddBulletToArray(bullets, bullet);
				}
				if (soundRepeat && !soundPlaying) {
					var e:Event = new Event(Event.SOUND_COMPLETE);
					RepeatSound(e);
				}
				else if (!soundRepeat)
					soundFire.play();
				
				gotoAndPlay(1);
				bulletsFrame = 0;
			}
		}
		
		public function StopRepeatSound() {
			if (soundRepeat && soundPlaying) {
				soundChannel.stop();
				soundPlaying = false;
			}
		}
		
		function RepeatSound(e:Event) {
			soundChannel = soundFire.play(0, 20000);
			soundChannel.addEventListener(Event.SOUND_COMPLETE, RepeatSound);
			soundPlaying = true;
		}
		
		function AddBulletToArray(bullets:Array, bullet:Bullet) {
			var len = bullets.length;
			
			for (var i=0; i<=len; i++) {
				if (i == len) {
					bullets.push(bullet);
					//trace("Bullet #"+i+" added.");
					//trace("bullets.length =", bullets.length);
				}
				else if (bullets[i] == undefined) {
					bullets[i] = bullet;
					//trace("Bullet #"+i+" added.");
					//trace("bullets.length =", bullets.length);
					break;
				}
			}
		}
		
		function CenterRand() {
			// Returns a number (-0.5, 0.5)
			var n = Math.random() - 0.5;
			
			var a = Math.random() * n;
			
			return n - a;
		}
		
		function GaussRand(lower:Number, upper:Number, stdDev:Number) {
			var range = upper - lower;
			var middle = (lower + upper) / 2;
			
			// For more details: http://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
			var U1 = Math.random();
			var U2 = Math.random();
			var Z1 = Math.sqrt(-2 * Math.log(U1)) * Math.cos(2 * Math.PI * U2);
			//var Z2 = Math.sqrt(-2 * Math.log(U1)) * Math.sin(2 * Math.PI * U2);
			var ajusted = Z1 / (range * stdDev);
			return ajusted + middle;
		}
		
		function TestNormal() {
			/*var numbers:Array = new Array();
			var ranges:Array = new Array();
			var rangeSize = 0.1;
			var lower = -3;
			var upper = 3;
			var middle = (lower + upper) / 2;
			var under = 0;
			var over = 0;
			
			for (var i=0; i<(upper-lower)/rangeSize; i++)
				ranges[i] = 0;
			
			for (var i=0; i<1000000; i++)
				numbers.push(GaussRand());
			
			for each (var n in numbers) {
				if (n < lower)
					under ++;
				else if (n > upper)
					over ++;
				else
					ranges[Math.floor((n-lower) / rangeSize)] ++;
			}
			
			trace("Under "+lower+": "+under);
			for (var i in ranges) {
				var visual:String = "";
				for (var j=0; j<ranges[i]; j+=500)
					visual += "+";
				trace("Between "+Number(i*rangeSize+lower).toFixed(2)+" and "+Number((i+1)*rangeSize+lower).toFixed(2)+": "+visual);
			}
				trace("Over "+upper+": "+over);*/
			/*for (var i=0; i<100; i++)
				trace(GaussRand());*/
		}

	}
	
}
