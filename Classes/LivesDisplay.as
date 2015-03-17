package
{
	import flash.text.TextField;
	
	public class LivesDisplay extends Counter
	{

		public function LivesDisplay()
		{
			super();
		}
		
		override public function updateDisplay():void
		{
			super.updateDisplay();
			livesDisplay.text = currentValue.toString();
		}
		
		override public function reset():void
		{
			super.currentValue = 100;
			updateDisplay();
		}
	}
}
