package Classes.Components
{
	/**
	 * date 24/04/2012
	 * @author David Aaron Rosini
	 */
	 
	 import Classes.Static.Colision;
	 import Classes.Static.Config;
	 import flash.display.Bitmap;
	 import flash.events.Event;
	 import flash.geom.Point;
	 
	 import flash.display.Sprite; 
	 import flash.display.BitmapData;
		
	public class Character extends Sprite
	{
		public  const _CHARCTER:Boolean = true;
		private const MOVESPEED:Number = 3;
		private const JUMPLIMIT:Number = 11;
		private const JUMPSPEED:Number = -12;
		
		public var animation:AnimaHero; 

		private var posiInicialX:int;
		private var posiInicialY:int;
		
		private var hitWidth:int;
		private var hitHeight:int;
		
		private var dirX:int; 
		private var dirY:int;
		
		private var heightCorr:int;
		
		private var speedCtrl:int = 0;
		private var flagJump:Boolean = false;
		private var jumpPower:Number = Infinity;
		
		private var flagSlope:Boolean = false;
		private var slopeType:int = Infinity; 
		private var offSetY:Number;
		
		private var flagAttack:Boolean = false;
		
		private var whip:Bitmap;
		private var attackInterval:int;
		
		private var spriteVector:Vector.<BitmapData>;
		
		public function Character(spriteVector:Vector.<BitmapData>, posiInicialX:int = 1, posiInicialY:int = 1)
		{
			this.spriteVector = spriteVector;
			
			this.posiInicialX = posiInicialX;
			this.posiInicialY = posiInicialY;
			
			for ( var i:int = 0; i < spriteVector.length; i++ )
			{
				hitWidth += spriteVector[i].width;
				hitHeight += spriteVector[i].height;
			}
			
			hitWidth = Math.round(hitWidth / spriteVector.length);
			hitHeight = Math.round(hitHeight / spriteVector.length);
			
			if (hitHeight > Config.TILESIZE)
			{ 
				heightCorr = Math.round(hitHeight / Config.TILESIZE) * Config.TILESIZE - hitHeight;
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, initiate);
		}
		
		protected function initiate(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initiate);
			
			//var testBMD:BitmapData = new BitmapData(hitWidth, hitHeight, true, 0xFF00FF);
			
			//var test:Bitmap = new Bitmap(testBMD);
			
			whip = new Bitmap( );
			
			animation = new AnimaHero();
			addChild( animation );
			
			this.parent.addChild(whip);
			//addChild(test);
			
			//test.name = "character";
			
 			this.x = posiInicialX * Config.TILESIZE;
			this.y = posiInicialY * Config.TILESIZE;
		}
		
		public function render( ):void
		{
			jumpChar( );
			
			moveChar( );
			
			checkForSlopes( );
			
			//attackChar( );
			
			animation.anima( );
		}
		
		private function attackChar():void 
		{
			if (flagAttack)
			{
				if (attackInterval == 0)
				{ 
					whip.bitmapData = new BitmapData(hitHeight, 5, true, 0xFF00FF);
				}
				
				whip.x = this.x + hitWidth;
				whip.y = this.y + 10;
				
				attackInterval++;
				
				if (attackInterval > 8)
				{
					Colision.checkHit(this, new Point( whip.x + whip.width, whip.y));
					
					whip.bitmapData = null;
					flagAttack = false;
					attackInterval = 0;
				}
			}
		}
		
		private function moveChar( ):void
		{
			if (dirX != 0)
			{
				if(!Colision.checkColision(this.x + dirX * MOVESPEED,this.y,hitWidth,hitHeight,this))
				{
					if (dirX < 0)
					{
						this.x = Math.floor(this.x / Config.TILESIZE) * Config.TILESIZE;
					}else if (dirX > 0)
					{
						this.x = Math.floor((this.x + hitWidth + MOVESPEED) / Config.TILESIZE) * Config.TILESIZE - this.hitWidth;
					}
				}else
				{
					this.x += dirX * (MOVESPEED + speedCtrl);
				}	
			}
		}
		
		private function jumpChar( ):void
		{
			if (jumpPower == Infinity)
			{
				if (flagJump)
				{	
					jumpPower = JUMPSPEED;
					
				}else if (Colision.checkColision(this.x, this.y + 1,hitWidth,hitHeight,this) && !flagSlope)
				{
					jumpPower = 0;
				}
			}
			
			if (jumpPower != Infinity)
			{
				jumpPower += Config.GRAVITY;
				
				if (jumpPower > JUMPLIMIT)
				{
					jumpPower = JUMPLIMIT;
					
				}else if (jumpPower < -JUMPLIMIT)
				{
					jumpPower = -JUMPLIMIT;
				}	
				
				if (Colision.checkColision(this.x, this.y + jumpPower,hitWidth,hitHeight,this))
				{
					this.y += jumpPower;
				}else
				{
					if (jumpPower < 0)
					{
						this.y = Math.floor(this.y / Config.TILESIZE) * Config.TILESIZE;
						jumpPower = 0;
						
					}else if(jumpPower > 0)
					{	
						animationReset( );
						this.y = Math.floor(this.y / Config.TILESIZE) * Config.TILESIZE + heightCorr;
						flagJump = false;
						jumpPower = Infinity;
					}
				}
			}
		}
			
		private function checkForSlopes():void 
		{
			var auxXT:int = Math.floor((this.x + (hitWidth / 2) - 1) / Config.TILESIZE);
			var auxYT:int = Math.floor((this.y + hitHeight - 1) / Config.TILESIZE);
			
			if (Colision.isSlope(auxXT, auxYT+1) && jumpPower == Infinity) 
			{
				auxYT += 1;
			}
			
			if (Colision.isSlope(auxXT, auxYT) && (jumpPower > 0))
			{
				
				if (jumpPower > -1)
				{
					flagJump = false;
					jumpPower = Infinity;
				}
				
				flagSlope = true;
				
				speedCtrl = -1;
				slopeType = Colision.tileType(auxXT,auxYT);
				
				offSetY = (this.x + hitWidth / 2) - auxXT * Config.TILESIZE;
				
				if (slopeType == Config.STAIRDOWN)
				{
					offSetY = Config.TILESIZE - offSetY;
				}
				
				this.y = (auxYT  * Config.TILESIZE) - (this.hitHeight - Config.TILESIZE) - offSetY;
			}
			else
			{
				if((slopeType == Config.STAIRUP && dirX > 0) || (slopeType == Config.STAIRDOWN && dirX < 0) && jumpPower == Infinity)
				{
					this.y = Math.floor(this.y / Config.TILESIZE) * Config.TILESIZE + heightCorr - 1;
				}
				
				if (flagSlope)
				{
					speedCtrl = 0;
					slopeType = Infinity;
					flagSlope = false;
				}
			}
		}
		
		public function set _flagJump(value:Boolean):void 
		{
			flagJump = value;
		}
		
		public function get _flagJump():Boolean 
		{
			return flagJump;
		}
		
		public function set _flagAttack(value:Boolean):void 
		{
			flagAttack = value;
		}
		
		public function get _flagAttack():Boolean 
		{
			return flagAttack;
		}
		
		public function set _dirX(value:int):void 
		{
			if (value > 0)
			{
				value = 1;
			}else if(value < 0)
			{
				value = -1;
			}
			
			this.dirX = value;
		}
		
		public function set _dirY(value:int):void 
		{
			if (value > 0)
			{
				value = 1;
			}else if(value < 0)
			{
				value = -1;
			}
			
			this.dirY = value;
		}
		
		public function animationReset():void 
		{
			if ( dirX == 0 )
			{
				animation.estado = "parado";
			}else
			{
				animation.estado = "andando";
			}	
		}
	}
}