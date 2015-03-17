package {
	
	import flash.events.Event;
	
	public class PowerUpEvent extends Event {
		
		public static const REMOVED:String = "removed";

		public function PowerUpEvent(type:String) {
			super(type);
		}
	}
}