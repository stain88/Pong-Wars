package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class DocumentClass extends MovieClip {
		
		private var menuScreen:MenuScreen;
		private var playScreen:PongV2;
		private var helpScreen:HelpScreen;
		private var gameOverScreen:GameOverScreen;
		private var loadingProgress:LoadingProgress;

		public function DocumentClass() {
			QuickKong.connectToKong(stage);
			loadingProgress = new LoadingProgress();
			loadingProgress.x = 320;
			loadingProgress.y = 240;
			addChild(loadingProgress);
			loaderInfo.addEventListener(Event.COMPLETE, onCompletelyDownloaded, false, 0, true);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressMade, false, 0, true);
			stage.stageFocusRect = false;
		}
		
		private function onProgressMade(progressEvent:ProgressEvent):void {
			loadingProgress.setValue(Math.floor(100 * loaderInfo.bytesLoaded/loaderInfo.bytesTotal));
		}
		
		private function onCompletelyDownloaded(event:Event):void {
			removeChild(loadingProgress);
			gotoAndStop(3);
			showMenuScreen();
		}
		
		private function showMenuScreen():void {
			menuScreen = new MenuScreen();
			menuScreen.x = 0;
			menuScreen.y = 0;
			menuScreen.addEventListener(NavigationEvent.START, onRequestStart, false, 0, true);
			menuScreen.addEventListener(NavigationEvent.HELP, onRequestHelp, false, 0, true);
			addChild(menuScreen);
		}
		
		private function onRequestStart(navigationEvent:NavigationEvent):void {
			playScreen = new PongV2();
			playScreen.addEventListener(PlayerEvent.DEAD, onGameOver, false, 0, true);
			addChild(playScreen);
			
			removeChild(menuScreen);
			menuScreen = null;
			
			stage.focus = playScreen;
		}
		
		private function onRequestHelp(navigationEvent:NavigationEvent):void {
			helpScreen = new HelpScreen();
			helpScreen.addEventListener(NavigationEvent.BACK, onClickBack, false, 0, true);
			addChild(helpScreen);
			
			removeChild(menuScreen);
			menuScreen = null;
			
			stage.focus = helpScreen;
		}
		
		private function onClickBack(navigationEvent:NavigationEvent):void {
			removeChild(helpScreen);
			helpScreen = null;
			showMenuScreen();
		}
		
		private function onGameOver(playerEvent:PlayerEvent):void {
			var finalScore:Number = playScreen.getFinalScore();
			var finalLevel:Number = playScreen.getFinalLevel();
			
			gameOverScreen = new GameOverScreen();
			gameOverScreen.addEventListener(NavigationEvent.RESTART, onRequestRestart, false, 0, true);
			gameOverScreen.x = 0;
			gameOverScreen.y = 0;
			gameOverScreen.setFinalScore(finalScore);
			gameOverScreen.setFinalLevel(finalLevel);
			addChild(gameOverScreen);
			stage.focus = gameOverScreen;
			
			removeChild(playScreen);
			playScreen = null;
		}
		
		private function onRequestRestart(navigationEvent:NavigationEvent):void {
			restartGame();
		}
		
		private function restartGame():void {
			menuScreen = new MenuScreen();
			menuScreen.x = 0;
			menuScreen.y = 0;
			menuScreen.addEventListener(NavigationEvent.START, onRequestStart, false, 0, true);
			menuScreen.addEventListener(NavigationEvent.HELP, onRequestHelp, false, 0, true);
			addChild(menuScreen);
			
			removeChild(gameOverScreen);
			gameOverScreen = null;
			
			stage.focus = menuScreen;
		}
	}
}