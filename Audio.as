package
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.SharedObject;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import net.flashpunk.utils.*;
	import net.flashpunk.tweens.misc.*;
	import net.flashpunk.*;
	
	public class Audio
	{
		[Embed(source="audio/giggle.mp3")]
		public static var Giggle1Sfx:Class;
		
		[Embed(source="audio/giggle2.mp3")]
		public static var Giggle2Sfx:Class;
		
		[Embed(source="audio/giggle3.mp3")]
		public static var Giggle3Sfx:Class;
		
		[Embed(source="audio/01.mp3")] public static const Talk1Sfx:Class;
		[Embed(source="audio/02.mp3")] public static const Talk2Sfx:Class;
		[Embed(source="audio/03.mp3")] public static const Talk3Sfx:Class;
		[Embed(source="audio/04.mp3")] public static const Talk4Sfx:Class;
		[Embed(source="audio/05.mp3")] public static const Talk5Sfx:Class;
		[Embed(source="audio/06.mp3")] public static const Talk6Sfx:Class;
		[Embed(source="audio/07.mp3")] public static const Talk7Sfx:Class;
		[Embed(source="audio/08.mp3")] public static const Talk8Sfx:Class;
		[Embed(source="audio/09.mp3")] public static const Talk9Sfx:Class;
		[Embed(source="audio/10.mp3")] public static const Talk10Sfx:Class;
		[Embed(source="audio/11.mp3")] public static const Talk11Sfx:Class;
		[Embed(source="audio/12.mp3")] public static const Talk12Sfx:Class;
		[Embed(source="audio/13.mp3")] public static const Talk13Sfx:Class;
		[Embed(source="audio/14.mp3")] public static const Talk14Sfx:Class;
		[Embed(source="audio/15.mp3")] public static const Talk15Sfx:Class;
		
		public static var sounds:Object = {};
		
		private static var _mute:Boolean = false;
		private static var so:SharedObject;
		private static var menuItem:ContextMenuItem;
		
		public static function init (o:InteractiveObject):void
		{
			// Setup
			
			/*so = SharedObject.getLocal("audio");
			
			_mute = so.data.mute;
			
			addContextMenu(o);*/
			
			if (o.stage) {
				initStage(o.stage);
			} else {
				o.addEventListener(Event.ADDED_TO_STAGE, stageAdd);
			}
			
			// Create sounds
			
			for (var i:int = 1; i <= 15; i++) {
				sounds[""+i] = new Sfx(Audio["Talk" + i + "Sfx"]);
			}
			
			for (i = 1; i <= 3; i++) {
				sounds["giggle"+i] = new Sfx(Audio["Giggle" + i + "Sfx"]);
			}
		}
		
		public static function giggle ():void
		{
			//sounds["giggle" + int(FP.rand(3)+1)].play();
		}
		
		public static function play (sound:String):void
		{
			if (! _mute && sounds[sound]) {
				sounds[sound].play();
			}
		}
		
		// Getter and setter for mute property
		
		public static function get mute (): Boolean { return _mute; }
		
		public static function set mute (newValue:Boolean): void
		{
			if (_mute == newValue) return;
			
			_mute = newValue;
			
			menuItem.caption = _mute ? "Unmute" : "Mute";
			
			so.data.mute = _mute;
			so.flush();
		}
		
		// Implementation details
		
		private static function stageAdd (e:Event = null):void
		{
			initStage(e.target.stage);
		}
		
		private static function initStage (stage:Stage):void
		{
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
			
			//stage.addEventListener(Event.ACTIVATE, onFocusGain);
			//stage.addEventListener(Event.DEACTIVATE, onFocusLoss);
		}
		
		private static function addContextMenu (o:InteractiveObject):void
		{
			var menu:ContextMenu = o.contextMenu || new ContextMenu;
			
			menu.hideBuiltInItems();
			
			menuItem = new ContextMenuItem(_mute ? "Unmute" : "Mute");
			
			menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuListener);
			
			menu.customItems.push(menuItem);
			
			o.contextMenu = menu;
		}
		
		private static function keyListener (e:KeyboardEvent):void
		{
			if (e.keyCode == Key.M) {
				mute = ! mute;
			}
		}
		
		private static function menuListener (e:ContextMenuEvent):void
		{
			mute = ! mute;
		}
		
	}
}

