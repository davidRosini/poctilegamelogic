package Classes
{
	import Classes.Static.*;
	import Classes.Components.*;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * date 08/12/2011
	 * @author David Aaron Rosini
	 */
	
	public class Game extends Sprite
	{
		private var hero:Character;
		private var enemy:Character;
		private var containerMap:ContainerMap;
		
		private var debugTFX:TextField;
		private var debugTFY:TextField;
		
		public function Game()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			MapContainer.initializeMaps( );
			
			var spriteVector:Vector.<BitmapData> = SpriteCutter.spriteCutter(new MapSheet( ) , Config.TILESIZE, Config.TILESIZE);
			
			containerMap = new ContainerMap(MapContainer.mapObj["0_0"] ,spriteVector ,(stage.stageWidth / Config.TILESIZE) + 1 ,(stage.stageHeight / Config.TILESIZE) + 1);
			
			this.addChild(containerMap);
			
			spriteVector = SpriteCutter.spriteCutter(new HeroSheet( ), 26, 45, true, true);
			
			Colision.setCurrentMap(containerMap._currentMap);
			
			hero = new Character(spriteVector,2,2);
			
			enemy = new Character(spriteVector, 12, 2);
			
			containerMap.addChild(enemy);
			containerMap.addChild(hero);
			
			containerMap._charObj = hero;
			
			KeyControl.startControl(stage,hero);
			
			debugTFX = new TextField( );
			debugTFY = new TextField( );
			
			addChild(debugTFX);
			addChild(debugTFY);
			
			debugTFX.textColor = 0xFF0000;
			debugTFX.x = 30;
			debugTFX.y = 30;
			
			debugTFY.textColor = 0xFF0000;
			debugTFY.x = 30;
			debugTFY.y = 40;
			
			this.addEventListener(Event.ENTER_FRAME, renderizar);
		}
		
		private function renderizar(e:Event = null):void 
		{
			enemy.render( );
			hero.render( );
			containerMap.render( );
			
			debugTFX.text = ("Hero X: " +hero.x);
			debugTFY.text = ("Hero Y: " +hero.y);
		}
	}
}