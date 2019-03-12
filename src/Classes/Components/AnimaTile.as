package Classes.Components
{
	
	/**
	 * date 20/04/2011
	 * @author David Aaron Rosini
	 */
	 
	 import flash.display.Bitmap;
	 
	 import flash.events.Event;
	 import flash.events.IEventDispatcher;
	
	public class AnimaTile extends Bitmap implements IEventDispatcher
	{		
		private var currentFrame:uint;
		private var firstFrame:uint;
		private var lastFrame:uint;
		private var interval:uint;
		
		private var countInterval:uint;
		
		private var bitmapDataArray:Array;
			
		public function AnimaTile(bitmapDataArray:Array, interval:uint = 0, firstFrame:uint = 0, lastFrame:uint = 0)
		{
			super( );
			
			this.firstFrame = firstFrame;
			this.lastFrame = lastFrame;
			this.interval = interval;
			
			this.bitmapDataArray = bitmapDataArray;
			
			if (this.lastFrame == 0)
			{
				this.lastFrame = this.bitmapDataArray.length;
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, initiate);
		}
		
		private function initiate(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initiate);
			
			currentFrame = firstFrame;
			
			countInterval = 0; 
			
			this.bitmapData = bitmapDataArray[currentFrame];
		}
		
		private function animation():void 
		{
			if (countInterval == interval)
			{
				countInterval = 0;
				
				if (currentFrame > lastFrame - 1)
				{
					currentFrame = firstFrame;
				}
				
				this.bitmapData = bitmapDataArray[currentFrame];
				
				currentFrame++;
				
			}else
			{
				countInterval++;
			}
		}
		
		public function render():void 
		{
			animation( );
		}
	}
}