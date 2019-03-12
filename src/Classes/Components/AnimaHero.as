package Classes.Components
{
	
	/**
	 * date 08/12/2011
	 * @author David Aaron Rosini
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class AnimaHero extends MovieClip
	{
		
		private var ANIMA:String = new String("parado");
		
		private var hero_bmp:Bitmap;
		private var whip_bmp:Bitmap;
		private var herosheet_bmpData:BitmapData;
		
		private var tile_heroW:uint = 26;
		private var tile_heroH:uint = 45;
		
		private var aux_img:int =  0;
		private var aux_intervalo:int = 0;
		private var aux_whipdelay:int = 0;
		
		private var sprites:Object = new Object();
		
		public  var _turn:Boolean = false;
		public  var estado:String = new String("parado");
		
		public function AnimaHero()
		{
			herosheet_bmpData = new HeroSheet( );
			
			hero_bmp = new Bitmap( );
			whip_bmp = new Bitmap( );
			
			addChild(whip_bmp);
			addChild(hero_bmp);
	
			initial();
		}
		
		private function initial():void 
		{
			sprites["parado"] =	   { imagens:[ 0, 1, 2],                 estado:1, interval:4 };
			sprites["andando"] =   { imagens:[ 0, 1, 2, 3, 4, 5, 6, 7] , estado:2, interval:2 };
			sprites["abaixado"] =  { imagens:[ 0, 1, 2] ,                estado:3, interval:1 , parar:0 };
			sprites["pulando"] =   { imagens:[ 0, 1, 2, 3, 4, 5 ] ,      estado:4, interval:3 , parar:0 };
			sprites["atacando"] =  { imagens:[ 0, 1, 2, 3, 4, 5, 6] ,    estado:5, interval:0, voltar:0, excecao:0 };
			
			for (var nome:String in sprites)
			{
				
				sprites[nome].bmpdata = new Array;

				for (var i:int = 0; i < sprites[nome].imagens.length ; i++) 
				{
					var rect:Rectangle = new Rectangle(sprites[nome].imagens[i] * (nome == "atacando"?(tile_heroW + 18):tile_heroW), sprites[nome].estado * tile_heroH, (nome == "atacando"?(tile_heroW+18):tile_heroW), tile_heroH);
					var temphero_bmpData:BitmapData = new BitmapData((nome == "atacando"?(tile_heroW + 18):tile_heroW), tile_heroH, true, 0xFF00FF);
					
					temphero_bmpData.copyPixels(herosheet_bmpData, rect, new Point(0, 0), null, null, true);
					
					sprites[nome].bmpdata[i] = temphero_bmpData;
					
				}
				
				if (sprites[nome].hasOwnProperty("excecao"))
				{
					sprites[nome].whipbmp = new Array;
					
					for (var j:int = 0; j < 2; j++) 
					{
						rect = new Rectangle(0, j * 5, 50, 5);
						
						sprites[nome].whipbmp[j] = new BitmapData(rect.width, rect.height, true, 0xFF00FF);
						
						sprites[nome].whipbmp[j].copyPixels(herosheet_bmpData, rect, new Point(0, 0),null, null, true);
					}
				}
			}
				
			herosheet_bmpData = null;
			
		}
		
		public function anima():void 
		{
			
			if (aux_intervalo >= sprites[ANIMA].interval)
			{
				aux_intervalo = 0;
				
				if (aux_img > sprites[ANIMA].imagens.length - 1)
				{
				
					if (sprites[ANIMA].hasOwnProperty("parar"))
					{
						aux_img = sprites[ANIMA].imagens.length - 1;
				
					}else
					{
						aux_img = 0;
					}
					
					if (sprites[ANIMA].hasOwnProperty("voltar"))
					{
						estado = "parado";
					}
					
				}
				
				if (ANIMA != estado )
				{
					aux_img = 0;
					ANIMA = estado;
					aux_intervalo = 0;
				}
				
				hero_bmp.x = 0;
				hero_bmp.y = 0;
				
				whip_bmp.x = 0;
				whip_bmp.y = 0;
				
				if (!_turn)
				{
					hero_bmp.bitmapData = sprites[ANIMA].bmpdata[aux_img];
				}else
				{
					hero_bmp.bitmapData = new BitmapData(sprites[ANIMA].bmpdata[aux_img].width, sprites[ANIMA].bmpdata[aux_img].height, true, 0);
					
					flipaBtmData(sprites[ANIMA].bmpdata[aux_img], hero_bmp.bitmapData);
					
					hero_bmp.x -= 4 
				}
				
				//whip
				if (sprites[ANIMA].hasOwnProperty("excecao"))
				{
					if (!_turn)
					{
						switch (sprites[ANIMA].imagens[aux_img])
						{
							case 0:
								hero_bmp.x =  - 11;
								break;
							case 1:
								hero_bmp.x =  - 22;
								hero_bmp.y += 1;
								break;
							case 2:
								hero_bmp.x =  - 20;
								break;
							case 3:
								hero_bmp.x =  - 18;
								break;
							case 4:
								hero_bmp.x = -2;
								break;
							case 5:
								hero_bmp.x = -1;
								break;
							case 6:
								hero_bmp.x = -1;
								break;	
						}
					}else
					{
						switch (sprites[ANIMA].imagens[aux_img])
						{
							case 0:
								hero_bmp.x -= 7;
								break;
							case 1:
								hero_bmp.x -= -4;
								hero_bmp.y += 1;
								break;
							case 2:
								hero_bmp.x -= -2;
								break;
							case 4:
								hero_bmp.x -= 16;
								break;
							case 5:
								hero_bmp.x -= 17;
								break;
							case 6:
								hero_bmp.x -= 17;
								break;
						}
					}	
			
					//whip
					if (sprites[ANIMA].imagens[aux_img] == 5 || sprites[ANIMA].imagens[aux_img] == 6)
					{
						
						if (!_turn)
						{
							
							whip_bmp.bitmapData = sprites[ANIMA].whipbmp[aux_img - 5];
							whip_bmp.x = hero_bmp.width - 10; 
							
						}else
						{
							whip_bmp.bitmapData = new BitmapData(sprites[ANIMA].whipbmp[aux_img - 5].width, sprites[ANIMA].whipbmp[aux_img - 5].height, true, 0);
					
							flipaBtmData(sprites[ANIMA].whipbmp[aux_img - 5], whip_bmp.bitmapData);
							
							whip_bmp.x += - (10 + hero_bmp.width)  ;
						}	
						
						whip_bmp.y = 12;
						
						if (aux_whipdelay > 1)
						{
							aux_whipdelay = 0;
							whip_bmp.bitmapData = null;
						}else
						{
							if (aux_img == 6) 
							{
								aux_img = 5;
								aux_whipdelay++;
							}
						}
					}
				}
				
				aux_img++;
				
			}else
			{
				aux_intervalo++;
			}
			
		}
		
		private function flipaBtmData( btmDt_source:BitmapData, btmDt_novo:BitmapData ):void 
		{
			/* Faz o FLIP horizontal */
			var flipMatrix = new Matrix();
			flipMatrix.scale( -1, 1);
			flipMatrix.translate( btmDt_source.width, 0 );
			btmDt_novo.draw( btmDt_source, flipMatrix );
		}
	}
}