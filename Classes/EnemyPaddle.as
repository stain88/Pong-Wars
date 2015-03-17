package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class EnemyPaddle extends Paddle {
		
		private var enemySpeed:Number;
		private static var R_Y:Number;

		public function EnemyPaddle() {
			enemySpeed = 3;
			x = 620;
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
		}
		
		private function onAddToStage(event:Event):void {
			y = stage.stageHeight/2;
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.ENTER_FRAME, frameHandler, false, 0, true);
		}
		
		private function frameHandler(event:Event):void {
			if (stage) {
				if (y < Ball.getY - 10) {
					y += enemySpeed+(PongV2.getLev/2);
				} else if (y > Ball.getY + 10) {
					y -= enemySpeed+(PongV2.getLev/2);
				}
				if (y < 20 + height/2) {
					y = 20 + height/2;
				}
				if (y > stage.stageHeight-40-height/2) {
					y = stage.stageHeight-40-height/2;
				}
			}
			R_Y = y;
		}
		
		public static function get getY():Number {
			return R_Y;
		}
	}
}