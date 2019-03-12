package Classes.Static
{
	/**
	 * date 14/05/2012
	 * @author David Aaron Rosini
	 */
	
	import flash.display.Stage;
	
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	public class KeyControl
	{
		private static var playerObj:Object;
		
		public function KeyControl() 
		{}
		
		public static function startControl(stage:Stage,_playerObj:Object):void
		{
			playerObj = _playerObj;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, evtKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, evtKeyUp);
		}
		
		private static function evtKeyDown(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.UP:
					break;
				case Keyboard.DOWN:
					playerObj._dirX = 0;
					playerObj.animation.estado = "abaixado";
					break;
				case Keyboard.RIGHT:
					playerObj._dirX = 1;
					
					if (playerObj.animation._turn)
					{
						playerObj.animation._turn = false;
					}
					if (!playerObj._flagJump)
					{
						playerObj.animation.estado = "andando";
					}
					
					break;
				case Keyboard.LEFT:
					playerObj._dirX = -1;
					
					if (!playerObj.animation._turn)
					{
						playerObj.animation._turn = true;
					}
					if (!playerObj._flagJump)
					{
						playerObj.animation.estado = "andando";
					}
					
					break;
					
				case Keyboard.CONTROL:
					if (!playerObj._flagAttack)
					{
						playerObj._flagAttack = true;
					}
					playerObj.animation.estado = "atacando";
					break;
				case Keyboard.SPACE:
					if (!playerObj._flagJump)
					{
						playerObj._flagJump = true;
					}
					playerObj.animation.estado = "pulando";
					break;
			}	
		}
		
		private static function evtKeyUp(e:KeyboardEvent):void 
		{
			switch(true)
			{
				case (e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.LEFT):
					playerObj._dirX = 0;
					playerObj.animationReset( );
					break;
				case e.keyCode == Keyboard.DOWN:
					playerObj.animationReset( );
					break;
			}
		}
	}
}