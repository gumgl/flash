package  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	
	public class EnemyRunner extends EnemyBase {
		
		
		public function EnemyRunner(theStage:Stage, player:Player) {			
			DAMAGE = 4;
			ATTACK_RATE = 3; // In attack/second
			VALUE = 10; // Points that will be added to player's score
			speed = 4;
			initialHealth = 1;
			health = initialHealth;
			
			BaseConstructor(theStage, player);
		}
	}
	
}