package {
	
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import flash.events.Event;
	
	public class PlayerPaddle extends Paddle {
		
		private static var R_Y:Number;
		
		public function PlayerPaddle() {
			x = 20;
			addEventListener(Event.ENTER_FRAME,frameHandler,false,0,true);
		}
		
		private function frameHandler(event:Event):void {
			if (stage) {
				y = stage.mouseY;
				
				if (this.y < 20+this.height/2) {
					this.y = 20+this.height/2;
				}
				if (this.y > stage.stageHeight-40-this.height/2) {
					this.y = stage.stageHeight-40-this.height/2;
				}
			}
			
			R_Y = y;
		}
		
		public static function get getY():Number {
			return R_Y;
		}
	}
}