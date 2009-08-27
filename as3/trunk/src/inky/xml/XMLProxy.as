﻿package inky.xml 
{
	import inky.xml.XMLProxy;
	import flash.utils.flash_proxy;
	import inky.xml.XMLProxyManager;
	import inky.xml.IXMLProxy;
	import flash.utils.Proxy;
	import flash.events.Event;
	import inky.events.EventManager;

//	use namespace flash_proxy;
	

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
	dynamic public class XMLProxy extends Proxy implements IXMLProxy
	{
		EventManager.registerNextTargetGetter(XMLProxy, XMLProxy._getNextTarget);


		private var _directProxy:DirectXMLProxy;
		private static var _proxyManager:XMLProxyManager = XMLProxyManager.getInstance();


		/**
		 *
		 * 
		 *
		 */	
	    public function XMLProxy(source:Object = null)
	    {
			this._directProxy = _proxyManager.getProxy(source || <root />);
	    }




		//
		// accessors
		//


		/**
		 *
		 */
		public function get source():XML
		{ 
			return this._directProxy.source; 
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc	
		 */
		public function equals(obj:Object):Boolean
		{
			return this._directProxy.equals(obj);
		}


		/**
		 * @copy Object#toString()
		 */
		public function toString():String 
		{
			return this._directProxy.toString();
		}




		//
		// xml methods
		//


		/**
		 *	@inheritDoc
		 */
		public function appendChild(child:Object):void
		{
			this._directProxy.appendChild(child);
		}


		/**
		 *	@inheritDoc
		 */
		public function child(propertyName:Object):IXMLListProxy
		{
			return this._directProxy.child(propertyName);
		}


		/**
		 *	@inheritDoc
		 */
		public function childIndex():int
		{
			return this._directProxy.childIndex();
		}


		/**
		 *	@inheritDoc
		 */
		public function children():IXMLListProxy
		{
			return this._directProxy.children();
		}
		
/**
 *	
 */
public function insertChildAfter(child1:Object, child2:Object):void
{
	this._directProxy.insertChildAfter(child1, child2);
}		


/**
 *	
 */
public function insertChildBefore(child1:Object, child2:Object):void
{
	this._directProxy.insertChildBefore(child1, child2);
}		


		/**
		 *	@inheritDoc
		 */
		public function localName():Object
		{
			return this._directProxy.localName();
		}


		/**
		 *	@inheritDoc
		 */
		public function parent():*
		{
			return this._directProxy.parent();
		}


		/**
		 *	
		 */
		public function removeChild(child:Object):void
		{
			this._directProxy.removeChild(child);
		}


		/**
		 * @copy XML#toXMLString()
		 */
		public function toXMLString():String 
		{
			return this._directProxy.toXMLString();
		}




		//
		// flash_proxy methods
		//


		/**
		 * @private
		 */
	    override flash_proxy function callProperty(methodName:*, ...args):*
	    {
			// For some weird reason, I can't access the arguments object.
			args.unshift(methodName);
			return this._directProxy.flash_proxy::callProperty.apply(null, args);
	    }


		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			return this._directProxy.flash_proxy::deleteProperty(name);
		} 


		/**
		 * @private
		 */
	    override flash_proxy function getDescendants(name:*):*
	    {
			return this._directProxy.flash_proxy::getDescendants(name);
	    }


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			return this._directProxy.flash_proxy::getProperty(name);
	    }


		/**
		 * @private
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
			return this._directProxy.flash_proxy::hasProperty(name);
	    }


		/**
		 * @private
		 */
		override flash_proxy function nextName(index:int):String
		{
// FIXME: Does this have to be unique to this instance (i.e. not delegated to _directProxy)?
			return this._directProxy.flash_proxy::nextName(index);
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextNameIndex(index:int):int
		{
// FIXME: Does this have to be unique to this instance (i.e. not delegated to _directProxy)?
			return this._directProxy.flash_proxy::nextNameIndex(index);
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextValue(index:int):*
	    {
// FIXME: Does this have to be unique to this instance (i.e. not delegated to _directProxy)?
			return this._directProxy.flash_proxy::nextValue(index);
	    }


		/**
		 * @private
		 */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
			this._directProxy.flash_proxy::setProperty(name, value);
	    }

















		//
		// event dispatcher methods
		//


		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this._directProxy.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}


		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return this._directProxy.dispatchEvent(event);
		}


		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return this._directProxy.hasEventListener(type);
		}


		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return this._directProxy.removeEventListener(type, listener, useCapture);
		}


		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this._directProxy.willTrigger(type);
		}












		//
		//
		//


		/**
		 *	
		 */
		private static function _getNextTarget(currentTarget:Object):Object
		{
			return currentTarget.source.parent() ? _proxyManager.getProxy(currentTarget.source.parent()) : null;
		}





	}
}