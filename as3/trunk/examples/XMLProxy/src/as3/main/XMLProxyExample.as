package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import inky.xml.XMLProxy;
	import inky.binding.utils.BindingUtil;
	import inky.xml.XMLListProxy;
	import inky.xml.events.XMLPropertyChangeEvent;
	import inky.binding.events.PropertyChangeEvent;
	import inky.collections.IList;
	import inky.xml.XMLChildrenList;
	import inky.xml.IXMLListProxy;
	import inky.xml.events.XMLEvent;


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

			// Listen for property change event.
			var xmlProxy:XMLProxy = new XMLProxy(xml);
			xmlProxy.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._traceEvent);
			xmlProxy.@myProperty = "5";
			
			// Get a (live) children list.
			var childrenList:IXMLListProxy = new XMLChildrenList(xml);
			xmlProxy.addEventListener(XMLEvent.ADDED, this._traceEvent);
			
			// Add a new item to the live child list!
			childrenList.addItem(<newItem />);
			
			// ...or do it the normal way.
			xmlProxy.appendChild(<newerItem />);
		}



		private function _traceEvent(event:Event):void
		{
			trace(event);
		}


	}
}