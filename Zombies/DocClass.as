package  {
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.*;
	import flash.geom.ColorTransform;
    import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.globalization.CurrencyFormatter; // For money
	import flash.ui.Mouse;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent; 
	
	public class DocClass extends MovieClip {
		/*	http://desktoppub.about.com/od/choosingcolors/f/What-Color-Is-Blood-Red.htm
			#660000 | Blood Red
			#DC143C | Crimson
			#8B0000 | Dark Red
			#800000 | Maroon
			#CC1100 | Blood Orange
		*/		
		const ZOMBIES_RATE = 2; // in zombies/second
		const ZOMBIE_DENSITY = 12025; // in pixels/zombie
		const MAX_STAINS = 50;
		const ROUNDS_DELAY = 3; // Delay between rounds, in seconds
		const PANEL_ANIMATION = 0.5; // Duration of the panels slide in and out, in seconds
		const PANEL_HIDE = 20; // Size of the part of a panel that is hidden, in pixels
		const PANEL_SHOW = 5; // Size of the part of a panel that is always shown, in pixels
		const BLOOD_STAIN_RADIUS = 25; // Radius of blood stains in pixels
		const BLOOD_PARTICLES = 60; // Number of circles used to generate blood stains. more -> perfect circle
		const BLOOD_COLORS:Array = [0x660000, 0x8B0000]; // Center to edge: Dark to light
		//const BLOOD_COLORS:Array = [0xD6181E, 0x980002]; // Light to dark
				
		var MAX_ZOMBIES = (stage.stageWidth * stage.stageHeight) / ZOMBIE_DENSITY; // Maximum # of zombies on screen
		var zombiesFrame:Number = 0;
		var zombiesOnScreen:Number = 0;
		var zombiesAdded:Number = 0;
		var zombiesKilled:Number = 0;
		var IsMouseDown:Boolean = false;
		var bullets:Array = new Array();
		var zombies:Array = new Array();
		var stains:Array = new Array();
		var sound_shot:SoundShot = new SoundShot();
		var sound_start:SoundStart = new SoundStart();
		var sound_lose:SoundLose = new SoundLose();
		
		var enemyTypes:Array = new Array(EnemyZombie, EnemyRunner, EnemyTank, EnemyBoss);
		var roundID:Number = 0;
		var rounds:Array = new Array();
		var roundsTimer:Timer = new Timer(ROUNDS_DELAY * 1000, 1);
		var popMessage:PopMessage = new PopMessage();
		var cf:CurrencyFormatter = new CurrencyFormatter( "en-US" ); 
		var restartTimer:Boolean = false;
		
		var stats_bulletsHit:Number = 0;
		var stats_totalBullets:Number = 0;
		var stats_zombiesKilled:Number = 0;
		var stats_startTime:Date = new Date();
		var score = 0;
		var money = 0;
		
		var blood_mc:MovieClip = new MovieClip();
		var player_mc:Player = new Player(stage);
		var target_mc:CrossHair = new CrossHair();
		var scores_mc:Scores = new Scores(stage, this);
		var stats_panel:PanelStats = new PanelStats();
		var weapons_panel:PanelWeapons = new PanelWeapons();
		
		public function DocClass() {
			InitRounds();
			stage.addEventListener(Event.ENTER_FRAME, Frame);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, target_follow);
			stage.addEventListener(Event.MOUSE_LEAVE, mouse_leave);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.addEventListener(Event.RESIZE, function(){StageResize();});
			StageResize();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			Mouse.hide();
			
			//stats_panel.visible = false
			target_mc.visible = false;
			target_mc.cacheAsBitmap = true;
			blood_mc.cacheAsBitmap = true;
			stats_panel.cacheAsBitmap = true;
			stage.addChild(blood_mc);
			stage.addChild(player_mc);
			stage.addChild(target_mc);
			stage.addChild(money_txt);
			stage.addChild(health_txt);
			stage.addChild(score_txt);
			stage.addChild(weapon_txt);
			stage.addChild(popMessage);
			popMessage.gotoAndStop(popMessage.totalFrames);
			stage.addChild(stats_panel);
			stage.addChild(weapons_panel);
			stats_panel.y = -1 * stats_panel.height + PANEL_SHOW;
			weapons_panel.x = stage.stageWidth - PANEL_SHOW;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouse_wheel);
			roundsTimer.addEventListener(TimerEvent.TIMER, NewRound);
			
			NewGame();
			
			// To test blood stains performance:
			/*for (var row=0; row<15; row++)
				for (var col=0; col<15; col++)
					AddBloodStain(col * 40, row * 40, 15);*/
		}
		
		function InitRounds() {
			var i:Number = 0;
			// # of Zombies, Zombie Rate, Probability of Type 1, Probability of Type 2, ...
			rounds[i++] = new Array(-1, 0, 0 , 0, 0, 0); // Fake round before real game
			rounds[i++] = new Array(10, 0.5, 1, 1, 1, 1); // Test round
			rounds[i++] = new Array(10, 0.4, 1, 0, 0, 0);
			rounds[i++] = new Array(15, 0.8, 1, 0, 0, 0);
			rounds[i++] = new Array(20, 0.8, 2, 1, 0, 0);
			rounds[i++] = new Array(30, 1.2, 2, 2, 0, 0);
			rounds[i++] = new Array(40, 1.5, 4, 2, 1, 0);
			rounds[i++] = new Array(40, 2.0, 1, 0, 0, 0);
			rounds[i++] = new Array(40, 1.5, 0, 10, 1, 0);
			rounds[i++] = new Array(40, 3.0, 0, 1, 0, 0);
			rounds[i++] = new Array(2, 0.5, 0, 0, 0, 1);
			rounds[i++] = new Array(20, 1.5, 8, 8, 2, 1);
			rounds[i++] = new Array(20, 2.0, 30, 15, 3, 1);
		}
		
		function StopRound() {
			roundsTimer.start();
		}
		
		function NewRound(e:TimerEvent) {
			zombiesAdded = 0; // Reset counter for this round
			zombiesKilled = 0;
			
			if (roundID < rounds.length - 1) // Keep on playing the same round at the end
				roundID ++;
			
			DisplayMessage("Round "+String(roundID));
		}
		
		function ClearScreen() {
			for (var i=0; i<bullets.length; i++)
				if (bullets[i] != undefined)
					RemoveBullet(i);			
			for (var j=0; j<zombies.length; j++)
				if (zombies[j] != undefined)
					RemoveZombie(j);
			target_mc.visible = false;
			player_mc.visible = false;
			player_mc.healthBar_mc.visible = false;
		}
		
		function NewGame() {
			for (var i = 0; i < stains.length; i++) { // Fix bug where some stains is not removed
				blood_mc.removeChild(stains[i]);
				delete stains[i];
			}
			stains = new Array();
			player_mc.visible = true;
			//blood_mc.graphics.clear();
			player_mc.x = stage.stageWidth / 2 - player_mc.radius;
			player_mc.y = stage.stageHeight / 2 - player_mc.radius;
			player_mc.health = player_mc.INITIAL_HEALTH;
			player_mc.gamePaused = false;
			score = 0;
			money = 0;
			roundID = 0;
			stats_bulletsHit = 0;
			stats_totalBullets = 0;
			stats_zombiesKilled = 0;
			stats_startTime = new Date();
			sound_start.play();
			StopRound();
		}
		
		function Pause() {
			restartTimer = roundsTimer.running;
			roundsTimer.stop();
			stats_panel.rounds_txt.text = String(roundID);
			stats_panel.killed_txt.text = String(stats_zombiesKilled);
			if (stats_totalBullets > 0)
				stats_panel.accuracy_txt.text = String(Math.round(stats_bulletsHit / stats_totalBullets * 100 * 100) / 100)+"%";
			else
				stats_panel.accuracy_txt.text = "0%";
			stats_panel.score_txt.text = String(score);
			player_mc.gamePaused = true;
			Mouse.show();
			stage.setChildIndex(stats_panel, stage.numChildren - 1);
			stage.setChildIndex(weapons_panel, stage.numChildren - 1);
			var tween1:Tween = new Tween(stats_panel, "y", Regular.easeOut, stats_panel.y, -1 * PANEL_HIDE, PANEL_ANIMATION, true);
			var tween2:Tween = new Tween(weapons_panel, "x", Regular.easeOut, weapons_panel.x, stage.stageWidth - weapons_panel.width + PANEL_HIDE, PANEL_ANIMATION, true);
			for each (var enemy in zombies)
				enemy.stop();
			DisplayMessage("Pause");
		}
		
		function Resume() {
			if (restartTimer)
				roundsTimer.start();
			player_mc.gamePaused = false;
			Mouse.hide();
			target_mc.x = stage.mouseX;
			target_mc.y = stage.mouseY;
			var tween1:Tween = new Tween(stats_panel, "y", Regular.easeIn, stats_panel.y, -1 * stats_panel.height + PANEL_SHOW, PANEL_ANIMATION, true);
			var tween2:Tween = new Tween(weapons_panel, "x", Regular.easeIn, weapons_panel.x, stage.stageWidth - PANEL_SHOW, PANEL_ANIMATION, true);
			for each (var enemy in zombies)
				enemy.play();
			DisplayMessage("Resume");
		}
		
		function Frame(e:Event) {
			if (player_mc.gamePaused) {
				player_mc.weapon.StopRepeatSound();
			}
			else {
				CollisionDetection();
				
				player_mc.weapon.bulletsFrame ++;
				if (IsMouseDown)
					player_mc.weapon.Shoot(bullets);
				else
					player_mc.weapon.StopRepeatSound();
				
				AddZombies();
				zombiesFrame ++;
				
				if (player_mc.health <= 0.0001) // GAME OVER
				{
					player_mc.health = 0;
					player_mc.gamePaused = true;
					roundsTimer.stop();
					sound_lose.play();
					ClearScreen();
					if (stats_totalBullets == 0) {
						stats_totalBullets = 1;
					}
					var duration = Math.round(((new Date).getTime() - stats_startTime.getTime()) / 1000);
					scores_mc.Open(score, roundID, stats_zombiesKilled, Math.round(stats_bulletsHit/stats_totalBullets*1000)/10, duration);
					DisplayMessage("Game Over!");
				}
				
				money_txt.text = "Money: $" + money;
				var color = Math.floor(255 - 255*(player_mc.health/player_mc.INITIAL_HEALTH));
				health_txt.textColor = RGB2HEX(color, 0, 0);
				health_txt.text = "Health: " + String(player_mc.health);
				score_txt.text = "Score: " + String(score);
				weapon_txt.text = player_mc.weapon.Name;
				//stats_panel.visible = (stats_panel.y <= -1 * stats_panel.height + 20);			
				ReorderIndex();
			}
		}
		
		function ReorderIndex() {
			stage.setChildIndex(player_mc.healthBar_mc, stage.numChildren - 1);
			stage.setChildIndex(player_mc, stage.numChildren - 1);
			stage.setChildIndex(money_txt, stage.numChildren - 1);
			stage.setChildIndex(health_txt, stage.numChildren - 1);
			stage.setChildIndex(score_txt, stage.numChildren - 1);
			stage.setChildIndex(weapon_txt, stage.numChildren - 1);
			stage.setChildIndex(target_mc, stage.numChildren - 1);
		}
		
		function CollisionDetection() {
			for (var i in bullets) {
				// Remove off-screen bullets
				if (bullets[i].x < 0 || 
					bullets[i].y < 0 || 
					bullets[i].x > stage.stageWidth || 
					bullets[i].y > stage.stageHeight) {
					RemoveBullet(i);
					stats_totalBullets ++;
				}
				else {
					// Check for collisions b/w bullets and enemies
					var bulletPoint:Point = new Point(bullets[i].x, bullets[i].y);
					for (var j in zombies) {
					//trace("Zombie #", j);
						var zombiePoint:Point = new Point(zombies[j].x, zombies[j].y);
						if (Point.distance(bulletPoint, zombiePoint) <= bullets[i].radius + zombies[j].radius) {
							zombies[j].health -= bullets[i].damage;
							zombies[j].UpdateHealthBar();
							RemoveBullet(i);
							stats_bulletsHit ++;
							stats_totalBullets ++;
							if (zombies[j].health <= 0.0001) {
								sound_shot.play();
								score += zombies[j].VALUE;
								money += zombies[j].VALUE;
								stats_zombiesKilled ++;
								RemoveZombie(j);
							}
							break;
						}
					}
				}
			}
		}
		
		function AddZombies() {
			var sumProbability = 0;
			for (var n=2; n<rounds[roundID].length; n++) {
				sumProbability += rounds[roundID][n];
			}
			for (var i in enemyTypes) {
				if (zombiesOnScreen < MAX_ZOMBIES && Math.random() <= rounds[roundID][i+2] / sumProbability * (1 / (stage.frameRate/rounds[roundID][1])) && zombiesAdded < rounds[roundID][0]) {// zombiesFrame % (stage.frameRate/ZOMBIES_RATE) == 0 && 
					var zombie = new enemyTypes[i](stage, player_mc)
					
					// Place zombie on a circle around center of stage
					var randomAngle = 2 * Math.PI * Math.random();
					var stageMaxRadius = Math.sqrt(Math.pow(stage.stageWidth, 2) + Math.pow(stage.stageHeight, 2)) / 2; // half of length of stage diagonal
					zombie.x = stage.stageWidth / 2 + Math.cos(randomAngle) * stageMaxRadius;
					zombie.y = stage.stageHeight / 2 - Math.sin(randomAngle) * stageMaxRadius;
					
					// Bring zombie back on the borders of stage
					if (zombie.x <= 0)
						zombie.x = -2 * zombie.radius;
					else if (zombie.x >= stage.stageWidth)
						zombie.x = stage.stageWidth + zombie.radius * 2;
					
					if (zombie.y <= 0)
						zombie.y = -2 * zombie.radius;
					else if (zombie.y >= stage.stageHeight)
						zombie.y = stage.stageHeight + zombie.radius * 2;
									
					AddZombieToArray(zombie);
					
					zombiesFrame = 0;
					zombiesOnScreen ++;
					zombiesAdded ++;
				}
			}
		}
		
		function AddZombieToArray(enemy:EnemyBase) {
			var len = zombies.length;
			
			for (var i = 0; i <= len; i ++) {
				if (i == len) {
					zombies.push(enemy);
					//trace("Zombie #"+i+" added.");
					//trace("zombies.length =", zombies.length);
				}
				else if (zombies[i] == undefined) {
					zombies[i] = enemy;
					//trace("Zombie #"+i+" added.");
					//trace("zombies.length =", zombies.length);
					break;
				}
			}
		}
		
		function AddBloodStain(posX:Number, posY:Number, radius:Number) {
			//blood_mc.graphics.clear();
			//blood_mc.graphics.moveTo(posX, posY);
			var stain:Sprite = new Sprite();
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matrix:Matrix = new Matrix();
			var mini_radius = radius / 3;
			matrix.createGradientBox(radius*2, radius*2, 0, -radius, -radius);// posX-radius, posY-radius);
			
			for (var i=0; i<BLOOD_PARTICLES; i++) {
				var distance = Math.random() * radius - mini_radius;
				var angle = Math.random() * 2 * Math.PI;
				//blood_mc.graphics.beginFill(BLOOD_COLORS[0]); // For solid blood stain (i.e. no gradient)
				stain.graphics.beginGradientFill(GradientType.RADIAL, BLOOD_COLORS, alphas, ratios, matrix);
				stain.graphics.drawCircle(Math.cos(angle) * distance, Math.sin(angle) * distance, mini_radius);
			}
			stain.graphics.endFill();
			stain.cacheAsBitmap = true;
			stains.push(stain);
			blood_mc.addChild(stain);
			stain.x = posX;
			stain.y = posY;
		}
		
		function RemoveBullet(index:Number) {
			bullets[index].Remove();
			delete bullets[index];
			//trace("Bullet #"+index+" removed.");
		}
		
		function RemoveZombie(index:Number) {
			var explosion:Explosion = new Explosion();
			explosion.x = zombies[index].x;
			explosion.y = zombies[index].y;
			explosion.rotation = 360*Math.random();
			stage.addChild(explosion);
			
			AddBloodStain(zombies[index].x, zombies[index].y, zombies[index].radius * 0.8);
			
			zombiesOnScreen --;
			zombies[index].Remove();
			delete zombies[index];
			//trace("Zombie #"+index+" removed.");
			
			zombiesKilled ++;
			if (zombiesKilled >= rounds[roundID][0])
				StopRound();
		}
		
		function DisplayMessage(s:String) {
			stage.setChildIndex(popMessage, stage.numChildren - 1);
			popMessage.x = stage.stageWidth / 2; // center
			popMessage.y = stage.stageHeight / 3; // 1/3 from top
			popMessage.gotoAndPlay(1);
			popMessage.message_txt.message_txt.text = s;
			//stage.addChild(popMessage);
		}
			
		function mouse_down(e:MouseEvent) {
			IsMouseDown = true;
		}
		
		function mouse_up(e:MouseEvent) {
			IsMouseDown = false;
		}
		
		function mouse_wheel(e:MouseEvent) {			
			if (!player_mc.gamePaused) {
				if (e.delta < 0)
					player_mc.NextGun();
				else
					player_mc.PrevGun();
			}
		}
		
		function mouse_leave(e:Event) {
			target_mc.visible = false;
			//Pause();
			player_mc.ResetKeyArray();
		}
		
		function key_down(e:KeyboardEvent) {
			switch (e.keyCode) {
				case Keyboard.F11:
					if (stage.displayState == StageDisplayState.NORMAL)
						stage.displayState=StageDisplayState.FULL_SCREEN;
					else
						stage.displayState=StageDisplayState.NORMAL;
					break;
				case Keyboard.SPACE:
					if (player_mc.health > 0) {
						if (player_mc.gamePaused)
							Resume();
						else
							Pause();
					}
					break;
			}
		}
		
		function target_follow(e:MouseEvent) {
			if (player_mc.health > 0 && !player_mc.gamePaused) {
				target_mc.visible = true;
				target_mc.x = e.stageX;
				target_mc.y = e.stageY;
			}
		}
		
		function StageResize() {
			money_txt.y = stage.stageHeight - money_txt.height;
			health_txt.y = stage.stageHeight - health_txt.height;
			score_txt.y = stage.stageHeight - score_txt.height;
			weapon_txt.x = stage.stageWidth - weapon_txt.width;
			weapon_txt.y = stage.stageHeight - weapon_txt.height;
			
			scores_mc.x = stage.stageWidth / 2 - scores_mc.width / 2;
			scores_mc.y = stage.stageHeight / 2 - scores_mc.height / 2;
			MAX_ZOMBIES = (stage.stageWidth * stage.stageHeight) / ZOMBIE_DENSITY;
			
			// Panels:
			stats_panel.x = (stage.stageWidth - stats_panel.width) / 2;
			weapons_panel.y = (stage.stageHeight - weapons_panel.height) / 2;
			weapons_panel.x = stage.stageWidth - PANEL_SHOW;
		}
		
		function RGB2HEX(Red:Number, Green:Number, Blue:Number):Number {
			return 256*256*Red + 256*Green + Blue;
		}
	}
}