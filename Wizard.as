package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Wizard extends Entity
	{
		public var vx: Number = 0;
		public var vy: Number = 0;
		
		[Embed(source="images/wizardtalking.png")] public static const Gfx: Class;
		
		public var sprite:Spritemap;
		
		public function Wizard ()
		{
			x = 165;
			y = 105;
			
			sprite = new Spritemap(Gfx, 33, 58);
			
			sprite.add("walk", [2,3], 0.1);
			sprite.add("talk", [1,0], 0.05);
			
			//sprite.play("walk");
			
			graphic = sprite;
			
			sprite.originY = sprite.height;
		}
		
		public override function update (): void
		{
			//x += int(Input.check(Key.RIGHT)) - int(Input.check(Key.LEFT));
			//y += int(Input.check(Key.DOWN)) - int(Input.check(Key.UP));
		}
	}
}

