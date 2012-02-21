package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		[Embed(source="images/bg.png")] public static const BgGfx: Class;
		[Embed(source="images/slaughter.png")] public static const DeathGfx: Class;
		
		public var player:Player;
		public var wizard:Wizard;
		public var death:Spritemap;
		public var text:Text;
		
		public var state:int = 0;
		public var waiting:Boolean = true;
		
		public var actions:Array = [];
		
		public var currentTween:Tween;
		public var currentSfx:Sfx;
		
		public function Level ()
		{
			var bg:Spritemap = new Spritemap(BgGfx, 160, 120);
			
			bg.add("anim", [0,1], 0.04);
			
			bg.play("anim");
			
			addGraphic(bg);
			
			add(player = new Player());
			add(wizard = new Wizard());
			
			death = new Spritemap(DeathGfx, 160, 60);
			
			death.visible = false;
			death.x = 0;
			death.y = player.y - 57;
			death.frame = -1;
			
			addGraphic(death);
			
			Text.size = 8;
			
			text = new Text("Press space");
			
			text.centerOO();
			
			text.x = FP.width*0.5;
			text.y = FP.height*0.9;
			
			addGraphic(text);
			
			actions = [
				movetalk(player, 48, 1),
				talk(player, 2),
				movetalk(wizard, 82, 3),
				talk(player, 4),
				talk(wizard, 5),
				talk(player, 6),
				interrupt(wizard, 7, player, 8),
				talk(wizard, 9),
				talk(player, 10),
				interrupt(wizard, 11, player, 12),
				interrupt(wizard, 13, player, 14),
				talk(wizard, 15),
				attack,
			];
		}
		
		public override function update (): void
		{
			super.update();
			
			if (Input.pressed(Key.SPACE)) {
				if (! waiting) {
					if (currentTween) currentTween.cancel();
					if (currentSfx) currentSfx.stop();
					waiting = true;
				}
				
				if (waiting) {
					waiting = false;
				
					var f:Function = actions[state];
				
					if (f != null) f();
				
					state++;
				}
			}
		}
		
		private function attack ():void
		{
			player.visible = false;
			wizard.visible = false;
			death.visible = true;
			
			death.frame = death.frame + 1;
			
			if (death.frame == 7) death.frame = 5;
			
			waiting = true;
			
			state--;
		}
		
		private function stab ():void
		{
			player.sprite.frame = 0;
		}
		
		private function both(f1:Function, f2:Function):Function
		{
			return function ():void {
				f1();
				f2();
			}
		}
		
		private function move (e:*, x:Number, next:Function = null):Function
		{
			return function ():void {
				doMove(e, x, next);
			}
		}
		
		private function movetalk (e:*, x:Number, i:int):Function
		{
			return move(e, x, talk(e, i));
		}
		
		private function talk (e:*, i:int, next:Function = null):Function
		{
			return function ():void {
				doTalk(e, i, next);
			}
		}
		
		private function interrupt (e1:*, s1:int, e2:*, s2:int):Function
		{
			return talk(e1, s1, talk(e2, s2));
		}
		
		private function doMove (e:*, x:Number, next:Function = null):void
		{
			if (next == null) next = waitForInput;
			
			e.sprite.play("walk");
			
			var dx:Number = x - e.x;
			
			var speed:Number = 1;
			var flip:Boolean = (e is Wizard) && (dx > 0);
			
			e.sprite.flipped = flip;
			
			var time:Number = Math.abs(dx) / speed;
			
			currentTween = FP.tween(e, {x: x}, time, function ():void {
				e.sprite.frame = 0;
				next();
			});
		}
		
		private function doTalk (e:*, i:int, next:Function = null):void
		{
			if (next == null) next = waitForInput;
			
			var sfx:Sfx = Audio.sounds[""+i];
			
			currentSfx = sfx;
			
			e.sprite.play("talk");
			
			sfx.complete = function ():void {
				e.sprite.frame = 0;
				next();
			}
			
			sfx.play();
		}
		
		private function waitForInput ():void
		{
			waiting = true;
		}
		
		public override function render (): void
		{
			text.visible = waiting;
			
			super.render();
		}
	}
}

