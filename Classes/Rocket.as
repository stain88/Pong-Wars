package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Rocket extends MovieClip {
		
		private var rocketSpeed:Number;
		private var playerFired:Boolean = false;
		private var enemyFired:Boolean = false;

		public function Rocket(from:String, xVar:Number, yVar:Number) {
			rocketSpeed = 8;
			
			if (from=="player") {
				playerFire();
				x = xVar + this.width;
				y = yVar;
			} else {
				this.rotation=180;
				enemyFire();
				x = xVar - this.width;
				y = yVar;
			}
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
		}
		
		private function onAddToStage(event:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.ENTER_FRAME, frameHandler, false, 0, true);
		}
		
		private function frameHandler(event:Event):void {
			if (playerFired) {
				this.x += rocketSpeed;
			}
			if (enemyFired) {
				this.x -= rocketSpeed;
			}
		}
		
		private function playerFire(event:Event=null):void {
			playerFired = true;
		}
				
		private function enemyFire(event:Event=null):void {
			enemyFired = true;
		}
		
		public function kill():void {
			this.removeEventListener(Event.ENTER_FRAME, frameHandler);
		}
	}
}