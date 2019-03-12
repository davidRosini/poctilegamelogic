package 
{
	import Classes.Game;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author David Aaron Rosini
	 */
	
	public class Main extends Sprite
	{
		public function Main():void
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init);
			
			var game:DisplayObject = new Game( );
			addChild(game);
		}
	}
}