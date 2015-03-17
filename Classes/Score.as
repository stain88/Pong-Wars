package
{
	import flash.text.TextField;
	
	public class Score extends Counter
	{
		
		public function Score()
		{
			super();
		}
		
		override public function updateDisplay():void
		{
			super.updateDisplay();
			scoreDisplay.text = currentValue.toString();
		}
	}
}