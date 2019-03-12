package Classes.Components
{
	
	/**
	 * date 08/12/2011
	 * @author David Aaron Rosini
	 */
	
	import Classes.Static.Config;
	import flash.events.Event;
	import flash.display.Sprite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ContainerMap extends Sprite
	{
		private const point:Point = new Point( );
		
		private var rect:Rectangle;
		
		private var charObj:Object;
		
		private var currentMap:Array;
		private var spriteVector:Vector.<BitmapData>;
		
		private var containerWidth:int;
		private var containerHeight:int;
		
		private var mapWidth:int;
		private var mapHeight:int;
		
		private var posiX:int;
		private var posiY:int;
		
		private var maxLimitR:Number;
		private var maxLimitL:Number;
		private var maxLimitU:Number;
		private var maxLimitD:Number;
		
		public function ContainerMap(currentMap:Array,spriteVector:Vector.<BitmapData>,containerWidth:int,containerHeight:int,posiX:int = 0,posiY:int = 0)
		{
			this.posiX = posiX;
			this.posiY = posiY;
			
			this.containerWidth = containerWidth;
			this.containerHeight = containerHeight;
			
			this.currentMap = currentMap;
			this.spriteVector = spriteVector;
			
			this.mapWidth = currentMap[0].length;
			this.mapHeight = currentMap.length;
			
			this.rect = new Rectangle(0, 0, Config.TILESIZE, Config.TILESIZE);
			
			this.charObj = null;
			this.addEventListener(Event.ADDED_TO_STAGE, initiate);
		}
		
		private function initiate(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initiate);
			
			var visiX:uint = Math.floor(containerWidth / 2);
			var visiY:uint = Math.floor(containerHeight / 2);
			
			maxLimitR = (mapWidth - (containerWidth - visiX)) * Config.TILESIZE + Config.TILESIZE;
			maxLimitD = (mapHeight - (containerHeight - visiY)) * Config.TILESIZE + Config.TILESIZE;
			
			maxLimitL = Config.TILESIZE * visiX;
			maxLimitU = Config.TILESIZE * visiY;
			
			this.x = - Config.TILESIZE * posiX;
			this.y = - Config.TILESIZE * posiY;
			
			createContainer( );
		}
		
		public function createContainer():void 
		{
			for (var yt:int = posiY; yt < containerHeight+posiY; yt++) 
			{
				for (var xt:int = posiX; xt < containerWidth+posiX; xt++) 
				{
					var sprite:int = currentMap[yt][xt];
					
					//desenha tile
					createTile(sprite, xt, yt);
				}
			}
		}
		
		private function createTile(sprite:int, xt:int, yt:int):void 
		{
			var tile:Bitmap = new Bitmap();
			
			tile.bitmapData = new BitmapData(Config.TILESIZE, Config.TILESIZE,true,Config.COLORMASK);
			
			drawTile(sprite, tile.bitmapData);
			
			tile.x = xt * Config.TILESIZE;
			tile.y = yt * Config.TILESIZE;
			
			tile.name = ("t" + xt + "_" + yt);
			//tile.cacheAsBitmap = true;
			this.addChild(tile);
		}
		
		private function drawTile(sprite:int,tileBitMapData:BitmapData):void 
		{
			tileBitMapData.lock( );
			
			tileBitMapData.fillRect(rect, Config.COLORMASK);
			
			tileBitMapData.copyPixels(spriteVector[sprite], rect, point, null, null,false);
			
			tileBitMapData.unlock( );
		}
		
		private function moveColumn(tileOldPosiX:uint,tileNewPosiX:uint):void
		{
			var tile:Bitmap;
			
			for (var yt:int = posiY; yt < containerHeight+posiY; yt++) 
			{
				tile = Bitmap(getChildByName("t" + tileOldPosiX + "_" + yt));
				
				tile.x = tileNewPosiX * Config.TILESIZE;
				
				tile.name = ("t" + tileNewPosiX + "_" + yt);
				
				drawTile(currentMap[yt][tileNewPosiX], tile.bitmapData);
			}
		}
		
		private function moveRow(tileOldPosiY:uint,tileNewPosiY:uint):void
		{
			var tile:Bitmap;
			
			for (var xt:int = posiX; xt < containerWidth+posiX; xt++) 
			{
				tile = Bitmap(getChildByName("t" + xt + "_" + tileOldPosiY));
				
				tile.y = tileNewPosiY * Config.TILESIZE;
				
				tile.name = ("t" + xt + "_" + tileNewPosiY);
				
				drawTile( currentMap[tileNewPosiY][xt], tile.bitmapData);
			}
		}
		
		private function moveContainer():void 
		{
			if ((charObj.x >= maxLimitL) && (charObj.x <= maxLimitR))
			{	
				this.x = maxLimitL - charObj.x;
				
				if (posiX * Config.TILESIZE + maxLimitL < charObj.x - Config.TILESIZE)
				{
					moveColumn(posiX , posiX + containerWidth);
					posiX++;
				}
				else if (posiX * Config.TILESIZE + maxLimitL > charObj.x)
				{
					posiX--;
					moveColumn( posiX + containerWidth , posiX);
				} 
			}
			
			if ((charObj.y >= maxLimitU) && (charObj.y <= maxLimitD))
			{	
				this.y = maxLimitU - charObj.y;
				
				if (posiY * Config.TILESIZE + maxLimitU < charObj.y - Config.TILESIZE)
				{
					moveRow(posiY , posiY + containerHeight);
					posiY++;
				}
				else if (posiY * Config.TILESIZE + maxLimitU > charObj.y)
				{
					posiY--;
					moveRow( posiY + containerHeight , posiY);
				} 
			}
		}
		
		public function render( ):void
		{
			if (charObj != null)
			{
				moveContainer( );
			}
		}
		
		public function set _charObj(value:Object):void 
		{
			this.charObj = value;
		}
		
		public function get _currentMap():Array 
		{
			return this.currentMap;
		}
	}
}