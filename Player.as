package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Player extends Entity
	{
		public var vx: Number = 0;
		public var vy: Number = 0;
		
		[Embed(source="images/kidstalking.png")] public static const Gfx: Class;
		
		public var sprite:Spritemap;
		
		public function Player (_x:Number = 0, _y:Number = 0, _vx:Number = 0, _vy:Number = 0)
		{
			x = -30;
			y = 105;
			
			sprite = new Spritemap(Gfx, 48, 48);
			
			sprite.add("walk", [0,1], 0.05);
			sprite.add("talk", [3,2], 0.05);
			
			sprite.play("walk");
			
			graphic = sprite;
			
			sprite.originX = sprite.width*0.5;
			sprite.originY = sprite.height;
		}
		
		public override function update (): void
		{
			/*var dx:Number = int(Input.check(Key.RIGHT)) * 1.0;
			
			x += dx;
			
			var max:int = 240;
			
			if (x > max) {
				x = max;
				sprite.frame = 0;
			}
			
			//world.camera.x = Math.max(x - 80 + sprite.width, 0);
			
			if (Input.pressed(Key.SPACE)) {
				Audio.play(""+sound);
				
				sound++;
			}*/
		}
		
		private static var sound:int = 1;
	}
}

