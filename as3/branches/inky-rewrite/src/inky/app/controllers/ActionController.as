package inky.app.controllers
{
	import inky.utils.EventDispatcherProxy;
	import flash.utils.flash_proxy;

	use namespace flash_proxy;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.27
	 *
	 */
	dynamic public class ActionController extends EventDispatcherProxy
	{



		public function preDispatch():void
		{
		}
		
		public function postDispatch():void
		{
		}




	   /**
	     * Dispatch the requested action
	     *
	     * @param string action Method name of action
	     * @param object params Parameters to be passed to the action.
	     * @return void
	     */
	    public function dispatch(action:String, params:Object = null):void
	    {
			this.preDispatch();
			this[action](params);
			this.postDispatch();
	    }


























		//
		// overridable proxy methods.
		//


		/**
		 * @private
		 */
	    override flash_proxy function callProperty(methodName:*, ... args):*
	    {
			if (Object.prototype[methodName])
				return Object.prototype[methodName].apply(this, args);
			else
			{
				trace(methodName + "()");
				return null;
			}
	    }


		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			throw new Error("You must override flash_proxy::deleteProperty()");
		} 


		/**
		 * @private
		 */
	    override flash_proxy function getDescendants(name:*):*
	    {
			throw new Error("You must override flash_proxy::getDescendants()");
	    }


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			if (Object.prototype[name])
			{
				return Object.prototype[name];
			}
			else
			{
				trace("getProperty\t" + name);
				return null;
			}	
//			throw new Error("You must override flash_proxy::getProperty()");
	    }


		/**
		 * @private
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
			throw new Error("You must override flash_proxy::hasProperty()");
	    }


		/**
		 * @private
		 */
		override flash_proxy function nextName(index:int):String
		{
			throw new Error("You must override flash_proxy::nextName()");
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextNameIndex(index:int):int
		{
			throw new Error("You must override flash_proxy::nextNameIndex()");
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextValue(index:int):*
	    {
			throw new Error("You must override flash_proxy::nextValue()");
	    }


		/**
		 * @private
		 */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
			throw new Error("You must override flash_proxy::setProperty()");
	    }



		
	}
	
}
