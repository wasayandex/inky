package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import inky.data.XMLProxy;
	import inky.binding.utils.BindingUtil;
	import inky.data.XMLListProxy;
	import inky.data.events.XMLPropertyChangeEvent;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.17
	 *
	 */
	public class XMLProxyExample extends Sprite
	{
		private var _loader:URLLoader;

		
		/**
		 *
		 */
		public function XMLProxyExample()
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this._dataCompleteHandler);
			loader.load(new URLRequest("books.xml"));
			this._loader = loader;
		}


		/**
		 *	
		 */
		private function _dataCompleteHandler(event:Event):void
		{
			var xml:XML = new XML(event.currentTarget.data);

			var xmlProxy:XMLProxy = new XMLProxy(xml);

//xmlProxy.addEventListener(XMLPropertyChangeEvent.CHANGE, function(event:Event):void{trace(event);});
//			BindingUtil.bindSetter(this._changedHandler, xmlProxy.book[0], "myProperty");


xmlProxy..author[1].@myProperty = 5;
trace(xmlProxy..author[1].@myProperty is Number)

//xmlProxy.myProperty = "5";
//trace(xmlProxy.toXMLString());
// trace(xmlProxy..myProperty.toXMLString())
		}


		private function _changedHandler(value:Object):void
		{
			trace("!!!!!!!!!!!! " + value);
		}


	}
}