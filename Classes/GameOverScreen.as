package
{
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.net.SharedObject;
	
	public class GameOverScreen extends MovieClip 
	{
		public var sharedObject:SharedObject;
		
		public function GameOverScreen() 
		{
			Mouse.show();
			restartBtn.addEventListener(MouseEvent.CLICK, onClickRestart, false, 0, true);
			sharedObject = SharedObject.getLocal("PongWarScores");
		}
		
		public function onClickRestart(mouseEvent:MouseEvent):void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.RESTART));
		}
		
		public function setFinalScore(scoreValue:Number):void
		{
			finalScore.text = scoreValue.toString();
			if (sharedObject.data.bestScore == null)
			{
				sharedObject.data.bestScore = scoreValue;
			}
			else if (scoreValue > sharedObject.data.bestScore)
			{
				sharedObject.data.bestScore = scoreValue;
			}
			bestScore.text = sharedObject.data.bestScore.toString();
			sharedObject.flush();
			QuickKong.stats.submit("Highscore", sharedObject.data.bestScore);
		}
		
		public function setFinalLevel(levelValue:Number):void {
			if (sharedObject.data.highestLevel == null) {
				sharedObject.data.highestLevel = levelValue;
			} else if (levelValue > sharedObject.data.highestLevel) {
				sharedObject.data.highestLevet = levelValue;
			}
			bestLevel.text = sharedObject.data.highestLevel.toString();
			sharedObject.flush();
			QuickKong.stats.submit("Highest Level", sharedObject.data.highestLevel);
		}
	}
	
}
