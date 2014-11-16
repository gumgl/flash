package  {
	import flash.display.Stage;
	
	public class WeaponShotgun extends WeaponBase {

		public function WeaponShotgun(theStage:Stage, player:Player) {
			damage = 0.8;
			soundFire = new SoundShotgun();
			fireRate = 65;
			trace(fireRate);
			Name = "Shotgun";
			speedFactor = 1;
			accuracy = 50;
			price = 5000;
			shots = 10;
			BaseConstructor(theStage, player);
		}

	}
	
}
