package  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	
	public class EnemyTank extends EnemyBase {
		
		
		public function EnemyTank(theStage:Stage, player:Player) {
			DAMAGE = 20;
			ATTACK_RATE = 1; // In attack/second
			VALUE = 200; // Points that will be added to player's score
			speed = 1.5;
			initialHealth = 15;
			health = initialHealth;
			
			BaseConstructor(theStage, player);
		}
	}
	
}