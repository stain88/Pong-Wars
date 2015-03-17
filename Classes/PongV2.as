package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class PongV2 extends MovieClip {
		
		private var playerPaddle:PlayerPaddle;
		private var enemyPaddle:EnemyPaddle;
		private var ball:Ball;
		private var playerHealth:Number;
		private var enemyHealth:Number;
		private var level:Number;
		private static var currLevel:Number;
		private var rocket:Rocket;
		private var rocketSymbol:RocketSymbol;
		private var rocketArray:Array;
		private var enemyRocketArray:Array;
		private var rocketsHeld:Number;
		private var homingRocket:HomingRocket;
		private var homingRocketSymbol:HomingRocketSymbol;
		private var homingArray:Array;
		private var enemyHomingArray:Array;
		private var homingRocketsHeld:Number;
		private var minigunBullet:MinigunBullet;
		private var minigunSymbol:MinigunSymbol;
		private var minigunArray:Array;
		private var enemyMinigunArray:Array;
		private var minigunHeld:Number;
		private var pMinigunTimer:Timer;
		private var eMinigunTimer:Timer;
		private var healthSymbol:HealthSymbol;
		private var healthHeld:Number;
		private var lastHit:Number;
		private var powerUp:PowerUp;
		private var powerUpArray:Array;
		public static const powerUpPickup:String = "powerUpPickup";

		public function PongV2() {
			lastHit = 1;
			rocketsHeld = 1;
			homingRocketsHeld = 1;
			minigunHeld = 1;
			healthHeld = 1;
			qRocket.text = rocketsHeld.toString();
			qHomingRocket.text = homingRocketsHeld.toString();
			qMinigun.text = minigunHeld.toString();
			qHealth.text = healthHeld.toString();
			
			playerPaddle = new PlayerPaddle();
			playerPaddle.y = mouseY;
			addChild(playerPaddle);

			enemyPaddle = new EnemyPaddle();
			addChild(enemyPaddle);
			
			playerHealth = 100;
			enemyHealth = 100;
			level = 1;
			currLevel = level;
			
			ball = new Ball();
			addChild(ball);
			
			powerUp = new PowerUp();
			powerUpArray = new Array();
			
			rocketArray = new Array();
			enemyRocketArray = new Array();
			homingArray = new Array();
			enemyHomingArray = new Array();
			minigunArray = new Array();
			enemyMinigunArray = new Array();
			pMinigunTimer = new Timer(300,4);
			pMinigunTimer.addEventListener(TimerEvent.TIMER, pMinigunFire, false, 0, true);
			pMinigunTimer.addEventListener(TimerEvent.TIMER_COMPLETE, pMinigunFinish, false, 0, true);
			eMinigunTimer = new Timer(300,4);
			eMinigunTimer.addEventListener(TimerEvent.TIMER, eMinigunFire, false, 0, true);
			eMinigunTimer.addEventListener(TimerEvent.TIMER_COMPLETE, eMinigunFinish, false, 0, true);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
		}
		
		private function onAddToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress, false, 0, true);
			addEventListener(Event.ENTER_FRAME, frameHandler, false, 0, true);
		}

		private function frameHandler(event:Event):void {
			powerUp.addEventListener(PowerUp.rocketSpawn, spawnRocketSymbol, false, 0, true);
			powerUp.addEventListener(PowerUp.homingSpawn, spawnHomingSymbol, false, 0, true);
			powerUp.addEventListener(PowerUp.minigunSpawn, spawnMinigunSymbol, false, 0, true);
			powerUp.addEventListener(PowerUp.healthSpawn, spawnHealthSymbol, false, 0, true);
			powerUp.addEventListener(PowerUp.removePower, removePower, false, 0, true);
			
			if (ball.x <=ball.width/2) {
				playerHealth-=10;
				playerInfo.addToValue(-10);
				checkHealth();
			}
			if (ball.x >= stage.stageWidth-ball.width/2) {
				enemyHealth-=10;
				enemyInfo.addToValue(-10);
				checkHealth();
			}
			
			if (PPCD.isColliding(playerPaddle,ball,this,true)) {
				if (ball.ballSpeedX<0) {
					ball.ballSpeedX*= -(1+level/100);
					ball.ballSpeedY = calculateBallAngle(playerPaddle.y, ball.y);
					gameScore.addToValue(10*level)
				}
				lastHit = 1;
			}
			
			if (PPCD.isColliding(enemyPaddle,ball,this,true)) {
				if (ball.ballSpeedX>0) {
					ball.ballSpeedX*= -1;
					ball.ballSpeedY = calculateBallAngle(enemyPaddle.y, ball.y);
				}
				lastHit = -1;
			}
						
			if (rocketSymbol && PPCD.isColliding(ball,rocketSymbol,this,true)) {
				removePower();
				dispatchEvent(new Event(powerUpPickup, true));
				if (lastHit==1) {
					if (rocketsHeld<9) {
						rocketsHeld+=1;
						updateWeapons();
					}
				} else {
					rocket = new Rocket("enemy", enemyPaddle.x, enemyPaddle.y);
					addChild(rocket);
					enemyRocketArray.push(rocket);
				}
			}
			
			if (homingRocketSymbol && PPCD.isColliding(ball,homingRocketSymbol,this,true)) {
				removePower();
				dispatchEvent(new Event(powerUpPickup, true));
				if (lastHit==1) {
					if (homingRocketsHeld<9) {
						homingRocketsHeld+=1;
						updateWeapons();
					}
				} else {
					homingRocket = new HomingRocket("enemy", enemyPaddle.x, enemyPaddle.y);
					addChild(homingRocket);
					enemyHomingArray.push(homingRocket);
				}
			}

			if (minigunSymbol && PPCD.isColliding(ball,minigunSymbol,this,true)) {
				removePower();
				dispatchEvent(new Event(powerUpPickup, true));
				if (lastHit==1) {
					if (minigunHeld<9) {
						minigunHeld+=1;
						updateWeapons();
					}
				} else {
					eMinigunTimer.start();
					minigunBullet = new MinigunBullet("enemy", enemyPaddle.x, enemyPaddle.y);
					addChild(minigunBullet);
					enemyMinigunArray.push(minigunBullet);
				}
			}

			if (healthSymbol && PPCD.isColliding(ball,healthSymbol,this,true)) {
				removePower();
				dispatchEvent(new Event(powerUpPickup, true));
				if (lastHit==1) {
					if (healthHeld<3) {
						healthHeld+=1;
						updateWeapons();
					}
				} else {
					enemyHealth+=50;
					enemyInfo.addToValue(50);
				}
			}
			
			testRocketHit();
			testERocketHit();
			testHomingHit();
			testEHomingHit();
			testMinigunHit();
			testEMinigunHit();
			
			currLevel = level;
					
		} //end frame
		
		private function testRocketHit():void {
			var iRocket:int = rocketArray.length - 1;
			var pRocket:Rocket;
			while (iRocket > -1) {
				pRocket = rocketArray[iRocket];
				if (PPCD.isColliding(enemyPaddle,pRocket,this,true)) {
					pRocket.kill();
					removeChild(pRocket);
					rocketArray.splice(iRocket,1);
					enemyHealth-=25;
					enemyInfo.addToValue(-25);
					gameScore.addToValue(25*level);
					checkHealth();
				}
				if (pRocket.x > stage.stageWidth+50) {
					pRocket.kill();
					removeChild(pRocket);
					rocketArray.splice(iRocket,1);
				}
				iRocket--;
			}
		}
		
		private function testERocketHit():void {
			var iRocket:int = enemyRocketArray.length - 1;
			var eRocket:Rocket;
			while (iRocket > -1) {
				eRocket = enemyRocketArray[iRocket];
				if (PPCD.isColliding(playerPaddle,eRocket,this,true)) {
					eRocket.kill();
					removeChild(eRocket);
					enemyRocketArray.splice(iRocket,1);
					playerHealth-=25;
					playerInfo.addToValue(-25);
					checkHealth();
				}
				if (eRocket.x < -50) {
					eRocket.kill();
					removeChild(eRocket);
					enemyRocketArray.splice(iRocket,1);
				}
				iRocket--;
			}
		}
		
		private function testHomingHit():void {
			var iHoming:int = homingArray.length - 1;
			var pHoming:HomingRocket;
			while (iHoming > -1) {
				pHoming = homingArray[iHoming];
				if (PPCD.isColliding(enemyPaddle, pHoming, this, true)) {
					pHoming.kill();
					removeChild(pHoming);
					homingArray.splice(iHoming,1);
					enemyHealth-=20;
					enemyInfo.addToValue(-20);
					gameScore.addToValue(20*level);
					checkHealth();
				}
				if (pHoming.x > stage.stageWidth+50) {
					pHoming.kill();
					removeChild(pHoming);
					homingArray.splice(pHoming,1);
				}
				iHoming--;
			}
		}
		
		private function testEHomingHit():void {
			var iHoming:int = enemyHomingArray.length - 1;
			var eHoming:HomingRocket;
			while (iHoming > -1) {
				eHoming = enemyHomingArray[iHoming];
				if (PPCD.isColliding(playerPaddle,eHoming,this,true)) {
					eHoming.kill();
					removeChild(eHoming);
					enemyHomingArray.splice(eHoming,1);
					playerHealth-=20;
					playerInfo.addToValue(-20);
					checkHealth();
				}
				if (eHoming.x < -50) {
					eHoming.kill();
					removeChild(eHoming);
					enemyHomingArray.splice(eHoming,1);
				}
				iHoming--;
			}
		}
		
		private function testMinigunHit():void {
			var iMinigun:int = minigunArray.length - 1;
			var pMinigun:MinigunBullet;
			while (iMinigun > -1) {
				pMinigun = minigunArray[iMinigun];
				if (PPCD.isColliding(enemyPaddle, pMinigun, this, true)) {
					pMinigun.kill();
					removeChild(pMinigun);
					minigunArray.splice(iMinigun,1);
					enemyHealth-=15;
					enemyInfo.addToValue(-15);
					gameScore.addToValue(15*level);
					checkHealth();
				}
				if (pMinigun.x > stage.stageWidth+50) {
					pMinigun.kill();
					removeChild(pMinigun);
					minigunArray.splice(iMinigun,1);
				}
				iMinigun--;
			}
		}
		
		private function testEMinigunHit():void {
			var iMinigun:int = enemyMinigunArray.length - 1;
			var eMinigun:MinigunBullet;
			while (iMinigun > -1) {
				eMinigun = enemyMinigunArray[iMinigun];
				if (PPCD.isColliding(playerPaddle, eMinigun, this, true)) {
					eMinigun.kill();
					removeChild(eMinigun);
					enemyMinigunArray.splice(iMinigun,1);
					playerHealth-=15;
					playerInfo.addToValue(-15);
					checkHealth();
				}
				if (eMinigun.x < -50) {
					eMinigun.kill();
					removeChild(eMinigun);
					enemyMinigunArray.splice(iMinigun,1);
				}
				iMinigun--;
			}
		}

		private function removePower(event:Event=null):void {
			if (powerUpArray.length != 0) {
				removeChild(powerUpArray[0]);
				powerUpArray.splice(0,1);
			}
		}
		
		private function spawnRocketSymbol(event:Event=null):void {
			rocketSymbol = new RocketSymbol(Math.floor(Math.random()*400+100),Math.floor(Math.random()*360+40));
			addChild(rocketSymbol);
			powerUpArray.push(rocketSymbol);
		}
		
		private function spawnHomingSymbol(event:Event=null):void {
			homingRocketSymbol = new HomingRocketSymbol(Math.floor(Math.random()*400+100),Math.floor(Math.random()*360+40));
			addChild(homingRocketSymbol);
			powerUpArray.push(homingRocketSymbol);
		}
						
		private function spawnMinigunSymbol(event:Event=null):void {
			minigunSymbol = new MinigunSymbol(Math.floor(Math.random()*400+100),Math.floor(Math.random()*360+40));
			addChild(minigunSymbol);
			powerUpArray.push(minigunSymbol);
		}

		private function spawnHealthSymbol(event:Event=null):void {
			healthSymbol = new HealthSymbol(Math.floor(Math.random()*400+100),Math.floor(Math.random()*360+40));
			addChild(healthSymbol);
			powerUpArray.push(healthSymbol);
		}
		
		private function updateWeapons():void {
			qRocket.text = rocketsHeld.toString();
			qHomingRocket.text = homingRocketsHeld.toString();
			qMinigun.text = minigunHeld.toString();
			qHealth.text = healthHeld.toString();
		}

		private function calculateBallAngle(paddleY:Number, ballY:Number):Number {
			return 7*(ballY-paddleY)/25+0.5;
		}
				
		private function onKeyPress(keyboardEvent:KeyboardEvent):void {
			if (keyboardEvent.keyCode == Keyboard.NUMBER_1 && rocketsHeld>0) {
				useRocket();
			}
			if (keyboardEvent.keyCode == Keyboard.NUMBER_2 && homingRocketsHeld>0) {
				useHoming();
			}
			if (keyboardEvent.keyCode == Keyboard.NUMBER_3 && minigunHeld>0) {
				useMinigun();
			}
			if (keyboardEvent.keyCode == Keyboard.NUMBER_4 && healthHeld>0) {
				useHealth();
			}
		}
		
		private function useRocket():void {
			rocketsHeld--;
			updateWeapons();
			rocket = new Rocket("player", playerPaddle.x, playerPaddle.y);
			addChild(rocket);
			rocketArray.push(rocket);
		}
		
		private function useHoming():void {
			homingRocketsHeld--;
			updateWeapons();
			homingRocket = new HomingRocket("player", playerPaddle.x, playerPaddle.y);
			addChild(homingRocket);
			homingArray.push(homingRocket);
		}
		
		private function useMinigun():void {
			minigunHeld--;
			updateWeapons();
			pMinigunTimer.start();
			minigunBullet = new MinigunBullet("player", playerPaddle.x, playerPaddle.y);
			addChild(minigunBullet);
			minigunArray.push(minigunBullet);
		}
		
		private function pMinigunFire(timerEvent:TimerEvent):void {
			minigunBullet = new MinigunBullet("player", playerPaddle.x, playerPaddle.y);
			addChild(minigunBullet);
			minigunArray.push(minigunBullet);
		}
		
		private function pMinigunFinish(timerEvent:TimerEvent):void {
			pMinigunTimer.reset();
		}
		
		private function eMinigunFire(timerEvent:TimerEvent):void {
			minigunBullet = new MinigunBullet("enemy", enemyPaddle.x, enemyPaddle.y);
			addChild(minigunBullet);
			enemyMinigunArray.push(minigunBullet);
		}
		
		private function eMinigunFinish(timerEvent:TimerEvent):void {
			eMinigunTimer.reset();
		}
		
		private function useHealth():void {
			healthHeld--;
			updateWeapons();
			playerHealth+=50;
			playerInfo.addToValue(50);
		}
						
		private function checkHealth():void {
			if (enemyHealth <= 0) {
				if (powerUpArray.length>0) {
					removePower();
					PowerUp.powerUpRemoveTimer.stop();
				}
				while (rocketArray.length>0) {
					removeChild(rocketArray.pop());
				}
				while (enemyRocketArray.length>0) {
					removeChild(enemyRocketArray.pop());
				}
				while (homingArray.length>0) {
					removeChild(homingArray.pop());
				}
				while (enemyHomingArray.length>0) {
					removeChild(enemyHomingArray.pop());
				}
				while (minigunArray.length>0) {
					removeChild(minigunArray.pop());
				}
				while (enemyMinigunArray.length>0) {
					removeChild(enemyMinigunArray.pop());
				}
				enemyInfo.setValue(100);
				enemyHealth = 100;
				level++;
				levelInfo.addToValue(1);
				ball.resetBall();
				ball.resetBallTimer.start();
				enemyPaddle.y = stage.stageHeight/2;
			}
			if (playerHealth <= 0) {
				removeEventListener(Event.ENTER_FRAME,frameHandler);
				removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
				if (powerUpArray.length>0) {
					removePower();
					PowerUp.powerUpRemoveTimer.stop();
				}
				PowerUp.powerUpSpawnTimer.stop();
				dispatchEvent(new PlayerEvent(PlayerEvent.DEAD));
			}
		}
						
		public function getFinalScore():Number {
			return gameScore.currentValue;
		}
		
		public function getFinalLevel():Number {
			return levelInfo.currentValue;
		}
		
		public static function get getLev():Number {
			return currLevel;
		}
	}
}