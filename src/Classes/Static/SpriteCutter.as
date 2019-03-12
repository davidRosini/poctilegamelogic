package Classes.Static
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * date 11/04/2011
	 * @author David Aaron Rosini
	 */
	
	public class SpriteCutter
	{
		private static const point:Point = new Point(0,0);
		
		private static const REDCHANNELMASK:uint = 0xFF;
		private static const GREENCHANNELMASK:uint = 0x00;
		private static const BLUECHANNELMASK:uint = 0xFF;
		
		public function SpriteCutter( )
		{}
		
		public static function spriteCutter(spriteBitmapData:BitmapData, tileWidth:uint, tileHeight:uint, _transparent:Boolean = true, _reduceBoundary:Boolean = false):Vector.<BitmapData>
		{
			//variaveis de apoio
			var bitmapDataVector:Vector.<BitmapData> = new Vector.<BitmapData>( );
			var bitmapDataTemp:BitmapData
			var rect:Rectangle;
			var maxSprite:uint;
			var spriteColumns:uint;
			var spriteRows:uint;
			var columns:uint;
			var rows:uint;
			
			spriteBitmapData.lock( );
			
			spriteColumns = (spriteBitmapData.width / tileWidth);
			spriteRows = (spriteBitmapData.height / tileHeight); 
			maxSprite = spriteColumns * spriteRows;
			
			for (var i:int = 0; i < maxSprite; i++) 
			{
				columns = i % spriteColumns; 
				rows = Math.floor(i / spriteColumns);
				
				rect = new Rectangle(columns * tileWidth, rows * tileHeight, tileWidth, tileHeight);
				
				bitmapDataTemp = new BitmapData(tileWidth, tileHeight, _transparent, Config.COLORMASK);
				
				bitmapDataTemp.copyPixels(spriteBitmapData, rect, point, null, null, false);
				
				if (_reduceBoundary || _transparent)
				{
					bitmapDataTemp = pixelMaping(bitmapDataTemp,_reduceBoundary,_transparent);
				}
				
				bitmapDataVector.push(bitmapDataTemp);
			}
			
			spriteBitmapData.unlock( );
			
			spriteBitmapData.dispose( );
			
			spriteBitmapData = null;
			
			return bitmapDataVector;
		}
		
		private static function pixelMaping(bitmapDataTemp:BitmapData,_reduceBoundary:Boolean,_transparent:Boolean):BitmapData
		{
			var bitmapDataVector:Vector.<uint> = bitmapDataTemp.getVector( bitmapDataTemp.rect);
			
			var row:int;
			var col:int;
			var minHeight:int = bitmapDataTemp.height;
			var MaxHeight:int = 0;
			var minWidth:int = bitmapDataTemp.width;
			var maxWidth:int = 0;
			
			for ( var i:int = 0; i < bitmapDataVector.length ; i++ ) 
			{	
				if (_reduceBoundary)
				{
					if (bitmapDataVector[i] != Config.COLORMASK)
					{
						row = int(i/bitmapDataTemp.width);
						
						col = int(i -  row * bitmapDataTemp.width);
						
						if (col < minWidth)
						{
							minWidth = col;
						}
						
						if (col > maxWidth)
						{
							maxWidth = col;
						}
						
						if (row < minHeight)
						{
							minHeight = row;
						}
						
						if (row > MaxHeight)
						{
							MaxHeight = row;
						}
					}
				}
				
				if (_transparent)
				{
					bitmapDataVector[i] = applyAlpha(bitmapDataVector[i]);
				}
			}
			
			if (_transparent)
			{
				bitmapDataTemp.setVector(bitmapDataTemp.rect, bitmapDataVector);
			}
			
			if (_reduceBoundary)
			{
				var rect:Rectangle = new Rectangle(minWidth,minHeight,(maxWidth - minWidth) + 1,(MaxHeight - minHeight) + 1)
				
				var bitmapDataTempRB = new BitmapData(rect.width, rect.height, _transparent, Config.COLORMASK);
				
				bitmapDataTempRB.copyPixels(bitmapDataTemp, rect, point, null, null, false);
				
				bitmapDataTemp.dispose( );
				
				bitmapDataTemp = bitmapDataTempRB;
			}
			
			return bitmapDataTemp;
		}
		
		private static function applyAlpha(colorPixel:uint):uint
		{
			var alphaChannel:uint = colorPixel >>> 24;
			var redChannel:uint = (colorPixel >> 16) & 0xFF;
			var greenChannel:uint = (colorPixel >> 8) & 0xFF;
			var blueChannel:uint = colorPixel & 0x000000FF;
			
			if (redChannel == REDCHANNELMASK && greenChannel == GREENCHANNELMASK && blueChannel == BLUECHANNELMASK)
			{
				alphaChannel = alphaChannel & 00000000;
				
				colorPixel = alphaChannel  << 24 | redChannel << 16 | greenChannel << 8 | blueChannel;
			}
			
			return colorPixel;
		}
	}
}