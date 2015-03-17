package {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class MenuScreen extends MovieClip {
		
		public function MenuScreen() {
			Mouse.show();
			startBtn.addEventListener(MouseEvent.CLICK, onClickStart, false, 0, true);
			helpBtn.addEventListener(MouseEvent.CLICK, onClickHelp, false, 0, true);
		}
		
		private function onClickStart(mouseEvent:MouseEvent):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.START));
		}
		
		private function onClickHelp(mouseEvent:MouseEvent):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.HELP));
		}
	}
}