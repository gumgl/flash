package  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	
	public class EnemyZombie extends EnemyBase {
		
		
		public function EnemyZombie(theStage:Stage, player:Player) {
			DAMAGE = 10;
			ATTACK_RATE = 1; // In attack/second
			VALUE = 10; // Points that will be added to player's score
			speed = 2;
			initialHealth = 3;
			health = initialHealth;
			
			BaseConstructor(theStage, player);
		}
	}
	
}