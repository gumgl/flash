package  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	
	public class EnemyBoss extends EnemyBase {
		
		
		public function EnemyBoss(theStage:Stage, player:Player) {
			DAMAGE = 100;
			ATTACK_RATE = 1; // In attack/second
			VALUE = 1000; // Points that will be added to player's score
			speed = 1;
			initialHealth = 50;
			health = initialHealth;
			
			BaseConstructor(theStage, player);
		}
	}
	
}