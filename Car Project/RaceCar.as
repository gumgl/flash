package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	
	
	public class RaceCar extends MovieClip {
		const ENGINE_DELAY = 5; // When car stops, keep making smoke for X seconds
		public const INITIAL_FUEL = 10000;
		public var speed = 0;
		public var angle = 0;
		public var radius:Number;
		public var fuel:Number = INITIAL_FUEL;
		public var ROTATION = 4; // in degrees
		public var WHEELS_ROTATION = ROTATION * 6; // in degrees
		public var TOP_SPEED:Number = 20; // in pixels/frame
		public var MIN_SPEED:Number = 1; // in pixels/frame
		public var DECCELERATION:Number = 2; // in % of current speed/frame
		public var ACCELERATION:Number = TOP_SPEED * (DECCELERATION / 100);
		
		var frames_stopped:Number;
		var isKeyDown:Array = new Array();
		var left_exhaust:Smoke;
		var right_exhaust:Smoke;
		var s:Stage;
		var sound_acceleration:Acceleration = new Acceleration();
		var sound_top:TopAcceleration = new TopAcceleration();
		var sound_stop:StopAcceleration = new StopAcceleration();
		var sound_idle:EngineIdle = new EngineIdle();
		var is_top:Boolean = false;
		var is_idle:Boolean = true;
		
		public function RaceCar(theStage:Stage) {
			s = theStage;
			left_exhaust = new Smoke(s, this);
			right_exhaust = new Smoke(s, this);
			sound_acceleration.Repeat = false;
			//sound_acceleration.SetVolume(1/10);
			sound_stop.Repeat = false;
			sound_idle.SetVolume(1/4);
			Init();
			//this.addEventListener(Event.ENTER_FRAME, Move);
			s.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressed);
			s.addEventListener(KeyboardEvent.KEY_UP, KeyReleased);
			s.addChild(this);
		}
		
		public function Init() {
			angle = -1 * this.rotation / 180 * Math.PI;
			radius = this.width/2;
			frames_stopped = ENGINE_DELAY * s.frameRate;
			//ACCELERATION = this.width / (s.frameRate * 4);// in % of car length
			for (var i = 0; i <= 127; i++)
				isKeyDown[i] = false;
		}
		
		public function Move() {
			
			speed *= (1 - DECCELERATION / 100);
			
			var slowing_down = true;
			
			var speed_change = 0;
			
			if (isKeyDown[Keyboard.W] || isKeyDown[Keyboard.UP])
				speed_change += 1;
			if (isKeyDown[Keyboard.S] || isKeyDown[Keyboard.DOWN])
				speed_change -= 1;
			
			if (speed_change != 0 && (fuel > 0 || speed*speed_change < 0))
			{
				speed += ACCELERATION * speed_change;
				
				if (speed*speed_change > 0 && fuel > 0) { // Accelerating
					slowing_down = false;
				
					left_exhaust.PARTICLES_PER_FRAME = 2;
					right_exhaust.PARTICLES_PER_FRAME = 2;
					
					sound_idle.Stop();
					if (!sound_acceleration.Playing && is_top)
						sound_top.Play();
					if (!sound_acceleration.Playing && !sound_top.Playing) {
						sound_acceleration.Play();
						is_top = true;
					}
				}				
			}
			
			var moving = (Math.abs(speed) >= MIN_SPEED);
			
			var engine_on = ((moving || frames_stopped < s.frameRate * ENGINE_DELAY) && fuel > 0);
			
			if (slowing_down)
			{
				left_exhaust.PARTICLES_PER_FRAME = 1;
				right_exhaust.PARTICLES_PER_FRAME = 1;
				
				sound_acceleration.Stop();
				sound_top.Stop();
				is_top = false;
				
				if (engine_on)
					sound_idle.Play();
				else {
					left_exhaust.PARTICLES_PER_FRAME = 0;
					right_exhaust.PARTICLES_PER_FRAME = 0;
					sound_idle.Stop();
				}
				if (moving)
					frames_stopped = 0;
				else {
					speed = 0;
					frames_stopped ++;
				}
			}
			
			var rotation_change = 0;
			if (isKeyDown[Keyboard.A] || isKeyDown[Keyboard.LEFT])
				rotation_change += 1;
			if (isKeyDown[Keyboard.D] || isKeyDown[Keyboard.RIGHT])
				rotation_change -= 1;
				
			if (rotation_change != 0 && speed != 0)
			{
				if (Math.abs(speed) < MIN_SPEED * 2) {
					angle += rotation_change * ROTATION * (speed / (MIN_SPEED * 2)) / 180 * Math.PI;
					rotation -= rotation_change * ROTATION * speed/(MIN_SPEED * 2);
				} else {
					angle += rotation_change * ROTATION*Math.abs(speed)/speed / 180 * Math.PI;
					rotation -= rotation_change * ROTATION*Math.abs(speed)/speed;
				}
				left_wheel_mc.rotation = -rotation_change * WHEELS_ROTATION;
				right_wheel_mc.rotation = -rotation_change * WHEELS_ROTATION;
			}
			else
			{
				left_wheel_mc.rotation = 0;
				right_wheel_mc.rotation = 0;
			}
			if (fuel > 0)
				fuel -= Math.abs(speed);
			else
				fuel = 0;
			
			left_exhaust.UpdatePos(this.x + Math.cos(angle + Math.PI*0.9)*radius, this.y - Math.sin(angle + Math.PI*0.9)*radius, angle + Math.PI);
			right_exhaust.UpdatePos(this.x + Math.cos(angle + Math.PI*1.1)*radius, this.y - Math.sin(angle + Math.PI*1.1)*radius, angle + Math.PI);
			s.setChildIndex(this, s.numChildren - 1);
		}
		
		function KeyPressed(e:KeyboardEvent) {
			isKeyDown[e.keyCode] = true;
		}
		
		function KeyReleased(e:KeyboardEvent) {
			isKeyDown[e.keyCode] = false;
		}
		
		public function xor(lhs:Boolean, rhs:Boolean):Boolean {
			return !( lhs && rhs ) && ( lhs || rhs );
		}
		
	}
	
}
