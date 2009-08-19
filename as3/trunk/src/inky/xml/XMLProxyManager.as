﻿package inky.xml {	import inky.collections.E4XHashMap;	import inky.collections.IMap;	import inky.xml.DirectXMLProxy;	import inky.xml.XMLListProxy;	/**	 *	 *  This class is used behind the scenes. Don't look at it.	 *		 * 	@langversion ActionScript 3	 *	@playerversion Flash 9.0.0	 *	 *	@author Matthew Tretter	 *	@since  2009.08.19	 *	 */	internal class XMLProxyManager	{		private static var _singletonEnforcer:Object = {};		private static var _instance:XMLProxyManager;		private static var _pool:E4XHashMap = new E4XHashMap(true);		/**		 *		 */		public function XMLProxyManager(enforcer:Object = null)		{			if (enforcer != _singletonEnforcer)				throw new ArgumentError("XMLProxyManager is a singleton. Use getInstance()");		}		public static function getInstance():XMLProxyManager		{			if (!_instance)				_instance = new XMLProxyManager(_singletonEnforcer);			return _instance;		}		/**		 *			 * 		 *  @param create    Specifies whether to create a new proxy if one doesn't already exist.		 */		public function getProxy(source:XML, create:Boolean = true):DirectXMLProxy		{			if (!source)				throw new ArgumentError("You can't get the proxy for a null object");			var proxy:DirectXMLProxy = _pool.getItemByKey(source) as DirectXMLProxy;			if (!proxy && create)			{				proxy = new DirectXMLProxy(source as XML);				_pool.putItemAt(proxy, source);			}			return proxy;		}			}	}