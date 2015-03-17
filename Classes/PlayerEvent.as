package {
	
	import flash.events.Event;
	
	public class PlayerEvent extends Event {
		
		public static const DEAD:String = "dead";

		public function PlayerEvent(type:String) {
			super(type);
		}
	}
}