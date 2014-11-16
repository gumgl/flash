package  {
	import flash.display.Stage;
	
	public class WeaponGlock extends WeaponBase {

		public function WeaponGlock(theStage:Stage, player:Player) {
			// Fully automatic rate of fire: 800 rounds per minute
			fireRate = 200;
			damage = 1;
			soundFire = new SoundGlock();
			Name = "Glock";
			speedFactor = 1.2;
			BaseConstructor(theStage, player);
		}

	}
	
}
