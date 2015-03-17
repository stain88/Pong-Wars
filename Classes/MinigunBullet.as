package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MinigunBullet extends MovieClip {
		
		private var bulletSpeed:Number;
		private var playerFired:Boolean = false;
		private var enemyFired:Boolean = false;
		
		public function MinigunBullet(from:String, xVar:Number, yVar:Number) {
			bulletSpeed = 7;
			
			if (from=="player") {
				playerFire();
				x = xVar+this.width;
				y = yVar;
			} else {
				this.rotation=180;
				enemyFire();
				x = xVar-this.width;
				y = yVar;
			}
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
		}
		
		private function onAddToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.ENTER_FRAME, frameHandler, false, 0, true);
		}
		
		private function frameHandler(event:Event):void {
			if (playerFired) {
				this.x += bulletSpeed;
			}
			if (enemyFired) {
				this.x -= bulletSpeed;
			}
		}
		
		private function playerFire():void {
			playerFired = true;
		}
		
		private function enemyFire():void {
			enemyFired = true;
		}
		
		public function kill():void {
			this.removeEventListener(Event.ENTER_FRAME, frameHandler);
		}
	}
}