package {
	
	import flash.events.Event;
	
	public class NavigationEvent extends Event {
		
		public static const RESTART:String = "restart";
		public static const START:String = "start";
		public static const HELP:String = "help";
		public static const BACK:String = "back";

		public function NavigationEvent(type:String) {
			super(type);
		}
	}
}