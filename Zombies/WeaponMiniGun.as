package  {
	import flash.display.Stage;
	
	public class WeaponMiniGun extends WeaponBase {

		public function WeaponMiniGun(theStage:Stage, player:Player) {
			// Fully automatic rate of fire: 800 rounds per minute
			damage = 0.8;
			soundFire = new SoundMachineGun();
			soundRepeat = true;
			fireRate = 1000 * 60 / soundFire.length;
			Name = "Mini Gun";
			speedFactor = 0.5;
			accuracy = 20;
			price = 10000;
			BaseConstructor(theStage, player);
		}

	}
	
}
