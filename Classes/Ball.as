package {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	public class Ball extends MovieClip {
		
		public var ballSpeedX:int;
		public var ballSpeedY:int;
		public var resetBallTimer:Timer;
		public var resetOn:Boolean;
		public var ballXDirection:Number;
		public var ballYDirection:Number;
		public var powerUp:PowerUp;
		private static var R_Y:Number;
		
		public function Ball() {
			resetOn = true;
			resetBall();
						
			resetBallTimer = new Timer(1000);
			resetBallTimer.addEventListener(TimerEvent.TIMER, freeBall, false, 0, true);
			resetBallTimer.start();
			addEventListener(Event.ENTER_FRAME, frameHandler, false, 0, true);
		}
		
		private function frameHandler(event:Event):void {
			if (stage) {
				if (!resetOn) {
					x += ballSpeedX;
					y += ballSpeedY;
				}
				
				if (x <= width/2) {
					x = width/2;
					ballSpeedX *= -1;
				} 
				
				if (x >= stage.stageWidth-width/2) {
					x = stage.stageWidth-width/2;
					ballSpeedX *= -1;
				}
				
				if (y <= 20+height/2) {
					y = 20+height/2;
					ballSpeedY *= -1;
				}
				
				if (y >= stage.stageHeight-40-height/2) {
					y = stage.stageHeight-40-height/2;
					ballSpeedY *= -1;
				}
	
				R_Y = y;
			}
		}
		
		private function freeBall(timerEvent:TimerEvent):void {
			resetOn = false;
			resetBallTimer.stop();

			if (PowerUp.powerUpSpawnTimer!=null && PowerUp.powerUpSpawnTimer.running == false) {
				PowerUp.powerUpSpawnTimer.start();
			}
		}
		
		public function resetBall():void {
			x = 320;
			y = 240;
			
			if (PowerUp.powerUpSpawnTimer!=null && PowerUp.powerUpSpawnTimer.running == true) {
				PowerUp.powerUpSpawnTimer.stop();
			}
			
			ballXDirection = (Math.random()<0.7) ? -1 : 1;
			ballYDirection = (Math.random()<0.5) ? -1 : 1;
			
			ballSpeedX = ballXDirection*Math.floor(Math.random()*6+10);
			ballSpeedY = ballYDirection*Math.floor(Math.random()*4+2);

			resetOn = true;
		}
				
		public static function get getY():Number {
			return R_Y;
		}
	}
}