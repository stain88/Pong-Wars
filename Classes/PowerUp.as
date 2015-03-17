package {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	public class PowerUp extends MovieClip {
		
		public static var powerUpSpawnTimer:Timer;
		public static var rocketSpawn:String = "rocketSpawned";
		public static var homingSpawn:String = "homingSpawned";
		public static var minigunSpawn:String = "minigunSpawned";
		public static var healthSpawn:String = "healthSpawned";
		public static var removePower:String = "removed";
		public static var powerUpRemoveTimer:Timer;
		private var powerUpArray:Array;
		public var rocketSymbol:RocketSymbol;

		public function PowerUp() {
			powerUpSpawnTimer = new Timer(Math.floor(Math.random()*1000+300));
			powerUpSpawnTimer.addEventListener(TimerEvent.TIMER, spawnPowerUp, false, 0, true);
			addEventListener(Event.ENTER_FRAME, frameHandler, false, 0, true);
			addEventListener(PongV2.powerUpPickup, removeCall, false, 0, true);
		}
		
		private function frameHandler(event:Event):void {
			addEventListener(PongV2.powerUpPickup, removeCall, false, 0, true);
		}
				
		private function spawnPowerUp(timerEvent:TimerEvent):void {
			powerUpSpawnTimer.stop();
			powerUpSpawnTimer.delay = Math.floor(Math.random()*1000+3000);
			powerUpRemoveTimer = new Timer(5000);
			powerUpRemoveTimer.start();
			powerUpRemoveTimer.addEventListener(TimerEvent.TIMER, removePowerUp, false, 0, true);
			var powerUpType:Number = Math.random();
			if (powerUpType < 0.1) {
				dispatchEvent(new Event(PowerUp.healthSpawn, true));
			} else if (powerUpType < 0.5) {
				dispatchEvent(new Event(PowerUp.rocketSpawn, true));
			} else if (powerUpType < 0.7) {
				dispatchEvent(new Event(PowerUp.homingSpawn, true));
			} else {
				dispatchEvent(new Event(PowerUp.minigunSpawn, true));
			}
		}
		
		private function removePowerUp(timerEvent:TimerEvent=null):void {
			powerUpRemoveTimer.stop();
			dispatchEvent(new Event(PowerUp.removePower, true));
			powerUpSpawnTimer.start();
		}
		
		private function removeCall(event:Event):void {
			removePowerUp();
		}
	}
}