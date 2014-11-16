package  {
	import flash.display.Stage;
	
	public class WeaponAK47 extends WeaponBase {

		public function WeaponAK47(theStage:Stage, player:Player) {
			fireRate = 400;
			damage = 1;
			soundFire = new SoundAK47();
			Name = "AK-47";
			speedFactor = 1;
			accuracy = 5;
			price = 2500;
			BaseConstructor(theStage, player);
		}

	}
	
}
