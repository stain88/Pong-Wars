﻿package
{
	import flash.text.TextField;
	
	public class LoadingProgress extends Counter
	{

		public function LoadingProgress()
		{
			super();
		}
		
		override public function updateDisplay():void
		{
			super.updateDisplay();
			percentDisplay.text = currentValue.toString();
		}

	}
	
}
