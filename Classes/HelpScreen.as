package {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class HelpScreen extends MovieClip {
		
		public function HelpScreen() {
			backBtn.addEventListener(MouseEvent.CLICK, onClickBack, false, 0, true);
		}
		
		private function onClickBack(mouseEvent:MouseEvent):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.BACK));
		}
	}
}