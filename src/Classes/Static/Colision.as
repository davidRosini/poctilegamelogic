package Classes.Static
{
	import flash.geom.Point;
	/**
	 * date 18/05/2012
	 * @author David Aaron Rosini
	 */
		
	public class Colision
	{
		private static var currentMap:Array;
		
		public function Colision( )
		{}
		
		public static function setCurrentMap(_currentMap:Array):void
		{
			currentMap = _currentMap;
		}
		
		public static function checkHit(objChar:Object,point:Point):void
		{
			var objArr:Array = objChar.parent.getObjectsUnderPoint(point);
			
			for (var i:int = 0; i < objArr.length; i++) 
			{
				if (objArr[i].name == "character")
				{
					trace(objArr[i].name, "true");
					break;
				}
			}
		}
		
		public static function checkColision(x:Number,y:Number,objWidth:Number,objHeight:Number,objChar:Object):Boolean
		{
			var upY:int = Math.floor(y / Config.TILESIZE);
			var downY:int = Math.floor((y + objHeight - 1) / Config.TILESIZE);
			var middleY:int = Math.floor((y + ( objHeight / 2) - 1) / Config.TILESIZE);
			
			var leftX:int = Math.floor(x / Config.TILESIZE);
			var rightX:int = Math.floor((x + objWidth - 1) / Config.TILESIZE);
			var middleX:int = Math.floor((x + (objWidth / 2) - 1) / Config.TILESIZE);
			
			if (y > objChar.y)
			{
				if (isCloud(leftX, downY) || isCloud(middleX, downY) || isCloud(rightX, downY))
				{
					return false;
				}
			}
			
			var ul:Boolean = isWalkable(leftX, upY);
			var dl:Boolean = isWalkable(leftX, downY);
			var ur:Boolean = isWalkable(rightX, upY);
			var dr:Boolean = isWalkable(rightX, downY);
			
			var mu:Boolean = isWalkable(middleX, upY);
			var md:Boolean = isWalkable(middleX, downY);
			var mr:Boolean = isWalkable(leftX, middleY);
			var ml:Boolean = isWalkable(rightX, middleY);
			
			return ul && dl && ur && dr && mu && md && mr && ml;
		}
		
		private static function isWalkable(xt:int, yt:int):Boolean
		{
			if (currentMap[yt][xt] != Config.SOLID)
			{
				return true;
			}else
			{
				return false;
			}
		}
		
		private static function isCloud(xt:int, yt:int):Boolean 
		{
			if (currentMap[yt][xt] == Config.CLOUD)
			{
				return true;
			}else
			{
				return false;
			}
		}
		
		public static function isSlope(xt:int, yt:int):Boolean 
		{
			if (currentMap[yt][xt] == Config.STAIRDOWN || currentMap[yt][xt] == Config.STAIRUP)
			{
				return true;
			}else
			{
				return false;
			}
		}
		
		public static function tileType(xt:int, yt:int):int 
		{
			return currentMap[yt][xt];
		}
	}
}