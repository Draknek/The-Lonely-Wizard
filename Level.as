package
{
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		[Embed(source="images/bg.png")] public static const BgGfx: Class;
		[Embed(source="images/slaughter.png")] public static const DeathGfx: Class;
		
		[Embed(source = 'amiga4ever.ttf', embedAsCFF="false", fontFamily = 'test')]
		private static const FONT:Class;
		
		public var player:Player;
		public var wizard:Wizard;
		public var death:Spritemap;
		public var text:Text;
		public var title:Text;
		public var deathE:Entity;
		
		public var state:int = 0;
		public var waiting:Boolean = true;
		public var waitingClick:Boolean = true;
		public var stomping:Boolean = false;
		
		public var damage:int = 0;
		
		public var stompdelay:int = 0;
		
		public var screenflash:int = 0;
		public var screenshake:int = 0;
		
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
			
			deathE = addGraphic(death);
			
			Text.size = 8;
			Text.font = "test";
			
			title = new Text("The\nLonely\nWizard", 0, 0, {align:"center"});
			
			title.centerOO();
			
			title.x = 88;
			title.y = 26;
			
			addGraphic(title);
			
			text = new Text("Click to start");
			
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
				stomp,
			];
		}
		
		public override function update (): void
		{
			super.update();
			
			if (waitingClick) {
				if (Input.mousePressed) {
					waiting = true;
					waitingClick = false;
					
					text.text = "Press space";
					
					FP.tween(title, {alpha: 0}, 90);
				}
				
				return;
			}
			
			if (stomping) {
				
				damage -= 1;
				if (damage < 0) damage = 0;
			
				if (Input.check(Key.SPACE)) {
					if (stompdelay == 0) {
						Audio.pain();
						death.frame = 8;
						screenshake = 10;
						stompdelay = 1;	
						damage += 20;
						if (damage > 100) {
							damage = 100;
							stomping = false;
							brandish();
						}
					}
					stompdelay = 1;					
				}
				else {
					stompdelay = 0;
					if (screenshake > 0) {
						death.frame = 8;
					}else{
					  death.frame = 9;
					}
				}
			}
			
			if (Input.pressed(Key.SPACE)) {
				if (false){//! waiting) {
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
			
			if (death.frame < 7) {
				if (death.frame == 1) {
					FP.alarm(10, attack);
				}else if (death.frame == 2) {
					FP.alarm(4, attack);
				}else if (death.frame == 3) {	
					Audio.play("death2");
					screenflash = 5; screenshake = 20;
					FP.alarm(20, attack);
				}else if (death.frame == 4) {	
					FP.alarm(10, attack);
				}else {
					
				  if (death.frame < 2) {
			  	  FP.alarm(5, attack);	
					}else {
						FP.alarm(7, attack);	
					}
				}
				
			} else {
				waiting = true;
			}
		}
		
		private var flashCount:int = 0;
		
		private function brandish ():void
		{
			if (death.frame < 10) {
				screenflash = 5; screenshake = 20;
				death.frame = 10;
				Audio.play("finaldeath");
			} else if (death.frame == 10) {
				death.frame = 11;
			} else if (death.frame == 11) {
				screenflash = 10; screenshake = 60;
				
				flashCount++;
			}
			
			if (flashCount < 5) {
				FP.alarm(15, brandish);
			} else {
				//death.y -= 3;
				//death.frame = 12;
				
				var black:Image = Image.createRect(FP.width, FP.height, 0x0);
				
				black.alpha = 0;
				
				addGraphic(black);
				
				FP.tween(black, {alpha: 1}, 5, {delay: 30});
				
				var end:Text = new Text("The end");
				end.alpha = 0;
				end.centerOO();
				end.x = FP.width*0.5;
				end.y = FP.height*0.5;
				
				addGraphic(end);
				
				FP.tween(end, {alpha: 1}, 30, {delay: 40, complete: function ():void {
					death.alpha = 0;
					deathE.layer = -1;
					death.frame = 12;
				}});
				
				FP.tween(death, {alpha: 1}, 60, {delay: 240});
			}
		}
		
		private function stomp ():void
		{
			stomping = true;
			screenflash = 5; screenshake = 20;
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
			if (screenshake > 0) {
			  FP.camera.x = (Math.random() * 10) - 5;
			  FP.camera.y = (Math.random() * 10) - 5;
				screenshake--;
			}else {
			  FP.camera.x = 0;
			  FP.camera.y = 0;
			}
				
			super.render();
			if(screenflash>0){
			  FP.buffer.fillRect(new Rectangle(0, 0, 160, 120), 0x832212);
				screenflash--;
			}
			
			if(death.frame==8 || death.frame==9){
				FP.buffer.fillRect(new Rectangle(29, 9, 102, 7), 0x000000);
				FP.buffer.fillRect(new Rectangle(30, 10, 100, 5), 0x555555);
				FP.buffer.fillRect(new Rectangle(30, 10, damage, 5), 0x832212);
			}
		}
	}
}

