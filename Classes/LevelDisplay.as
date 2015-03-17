package
{
	
	public class LevelDisplay extends Counter
	{

		public function LevelDisplay() 
		{
			super();
		}
		
		override public function updateDisplay():void
		{
			super.updateDisplay();
			levelDisplay.text = currentValue.toString();
		}
		
		override public function reset():void
		{
			super.currentValue = 1;
			updateDisplay();
		}
	}
}
