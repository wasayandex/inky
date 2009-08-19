package inky.xml 
{
	import inky.collections.E4XHashMap;
	import inky.collections.IMap;
	import inky.xml.DirectXMLProxy;
	import inky.xml.DirectXMLListProxy;


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
		private static var _pool:E4XHashMap = new E4XHashMap(true); // A pool used for non-parented lists.
		private static var _pool2:E4XHashMap = new E4XHashMap(true); // A pool used for "parented" lists (lists created with the children() function)


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
		public function getProxy(source:XML, create:Boolean = true, parent:XML = null):DirectXMLProxy
		{
			return this._getProxy(source, create, parent) as DirectXMLProxy;
		}	


		/**
		 *
		 * Note: If you try to get a proxy for a list using a parent other than one you used to get the proxy the first time, weird stuff will probably happen.
		 * 
		 * @param parent    The parent xml. This should only be passed for children lists, as it will enable the add* methods for the resultant list.	
		 * 
		 */
		private function _getProxy(source:Object, create:Boolean = true, parent:XML = null):Object
		{
			if (!source)
			{
				throw new ArgumentError("You can't get the proxy for a null object");
			}

			var proxy:Object;

			// Select the pool to use based on whether this is a parented list.
			var pool:IMap = parent ? _pool2 : _pool;

			proxy = pool.getItemByKey(source);
			if (!proxy && create)
			{
				if (source is XML)
					proxy = new DirectXMLProxy(source as XML);
				else if (source is XMLList)
					proxy = new DirectXMLListProxy(source as XMLList, parent);
				else
					throw new Error();
				pool.putItemAt(proxy, source);
			}

			return proxy;
		}


		/**
		 *	
		 */
		public function getListProxy(source:XMLList, create:Boolean = true, parent:XML = null):DirectXMLListProxy
		{
			return this._getProxy(source, create, parent) as DirectXMLListProxy;
		}











		
	}
	
}