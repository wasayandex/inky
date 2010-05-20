package inky.xml 
{
	import inky.collections.E4XHashMap;
	import inky.xml.DirectXMLProxy;
	import inky.xml.IXMLProxy;
	import inky.collections.IIterator;
	import inky.utils.UIDUtil;
	import flash.utils.Dictionary;


	/**
	 *
	 *  This class is used behind the scenes. Don't look at it.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.19
	 *
	 */
	internal class XMLProxyManager
	{
		private static var _singletonEnforcer:Object = {};
		private static var _instance:XMLProxyManager;
		private static var _pool:Dictionary = new Dictionary(true);


		/**
		 *
		 */
		public function XMLProxyManager(enforcer:Object = null)
		{
			if (enforcer != _singletonEnforcer)
				throw new ArgumentError("XMLProxyManager is a singleton. Use getInstance()");
		}







		public static function getInstance():XMLProxyManager
		{
			if (!_instance)
				_instance = new XMLProxyManager(_singletonEnforcer);
			return _instance;
		}






		/**
		 *	
		 * 
		 *  @param create    Specifies whether to create a new proxy if one doesn't already exist.
		 */
		public function getProxy(source:Object, create:Boolean = true):DirectXMLProxy
		{
			if (!source)
				throw new ArgumentError("You can't get the proxy for a null object");
			else if (source is IXMLProxy)
				source = source.source;
			else if (!(source is XML))
				throw new ArgumentError("You can only get XML proxies for XML objects and IXMLProxy objects");

			var proxy:Object;
			var proxyFound:Boolean = false;

			for (proxy in _pool)
			{
				if (proxy.source === source)
				{
					proxyFound = true;
					break;
				}
			}
			
			if (!proxyFound)
			{
				if (create)
				{
					proxy = new DirectXMLProxy(source as XML);
					_pool[proxy] = null;
				}
				else
				{
					proxy = null;
				}
			}

			return proxy as DirectXMLProxy;
		}











		
	}
	
}
