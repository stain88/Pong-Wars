package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class HomingRocket extends MovieClip {
		
		private var hHomingSpeed:Number;
		private var vHomingSpeed:Number;
		private var playerFired:Boolean;
		private var enemyFired:Boolean;
		
		public function HomingRocket(from:String, xVar:Number, yVar:Number) {
			hHomingSpeed = 5;
			vHomingSpeed = 2;
			
			if (from=="player") {
				playerFire();
				x = xVar + this.width;
				y = yVar;
			} else {
				this.rotation = 180;
				enemyFire();
				x = xVar - this.width;
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
				this.x += hHomingSpeed;
				if (this.y < EnemyPaddle.getY) {
					this.y += vHomingSpeed;
				} else if (this.y > EnemyPaddle.getY) {
					this.y -= vHomingSpeed;
				}
			}
			if (enemyFired) {
				this.x -= hHomingSpeed;
				if (this.y < PlayerPaddle.getY) {
					this.y += vHomingSpeed;
				} else if (this.y > PlayerPaddle.getY) {
					this.y -= vHomingSpeed;
				}
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