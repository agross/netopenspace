package 
{
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.external.ExternalInterface;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
		
	/**
	 * ...
	 * @author mhoyer
	 */
	public class Main extends Sprite 
	{
		private var containerWidth:Number;
		private var containerHeight:Number;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(MouseEvent.MOUSE_DOWN, copy);
			
			containerWidth = parseInt(getParameter("width", stage.width.toString()));
			containerHeight = parseInt(getParameter("height", stage.height.toString()));
			
			//trace("\n\ncontainer dimension: " + containerWidth + "x" + containerHeight);

			addChild(loadContent(getParameter("backgroundAsset", "nos-badge-125x125.png")));
		}
		
		private function getParameter(name:String, defaultValue:String = null):String
		{
			var result:String = loaderInfo.parameters[name];
			
			if (result == null)
			{
				return defaultValue;
			}

			return result;
		}
		
		private function copy(e:Event = null):void
		{
			var clipboardContent:String = getParameter("clipboard");
			
			if (clipboardContent != null)
			{
				System.setClipboard(clipboardContent);
			}
			else
			{
				System.setClipboard("No parameters set.");
			}
			
			executeCommand(getParameter("callback"));
		}
		
		private function executeCommand(callback:String) : Object
		{
			trace("callback: " + callback);
			
			if (ExternalInterface.available && callback != null)
				return ExternalInterface.call(
					"eval",
					callback
				);
				
			return null;
		}
		
		public function loadContent(url:String):Loader
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_Completed);
			loader.load(new URLRequest(url));
			
			return loader;
		}
		
		private function loader_Completed(event:Event):void
		{
			var li:LoaderInfo = event.target as LoaderInfo;
			
			li.loader.x = (100 - containerWidth) / 2;
			li.loader.y = (100 - containerHeight) / 2;
			
			// trace("Loader: " + li.loader.x + ":" + li.loader.y + " (dim= " + li.loader.width + "x" + li.loader.height + ")");
			// trace(stage.width);
		}
	}
}