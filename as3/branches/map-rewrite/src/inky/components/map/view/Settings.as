package inky.components.map.view 
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *
	 *  The settings object allows you to access functionality that has been added by a helper through the map.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.30
	 *
	 */
	dynamic public class Settings extends Proxy
	{
		private var propertyList:Array;
		private var propertyAccessors:Object = {};
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function defineProperty(propertyName:String, getter:Function, setter:Function):void
		{
			this.propertyAccessors[propertyName] = {
				getter: getter,
				setter: setter
			};
		}

		/**
		 * @copy Object#toString()
		 */
		public function toString():String 
		{
			return Object.prototype.toString.call(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function valueOf():Object
		{
			return this;
		}

		//---------------------------------------
		// flash_proxy methods
		//---------------------------------------
		
		/**
		 * @private
		 */
	    override flash_proxy function callProperty(methodName:*, ... args):*
	    {
			throw new Error("You cannot call methods on the settings object.");
// TODO: Maybe add a registerMethod, so you can?
	    }

		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			throw new Error("You cannot delete properties from the settings object.");
		} 

		/**
		 * @private
		 */
	    override flash_proxy function getDescendants(name:*):*
	    {
	    	throw new TypeError("Error #1016: Descendants operator (..) not supported on this type.");
	    }

		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			var getter:Function = (this.propertyAccessors[name] && this.propertyAccessors[name].getter) as Function;
			if (getter == null)
				throw new Error("No getter is registered for the property \"" + name + "\" on this Settings object.");

			return getter();
	    }

		/**
		 * @private
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	        return !!this.propertyAccessors[name];
	    }

		/**
		 * @private
		 */
		override flash_proxy function nextName(index:int):String
		{
			return this.propertyList[index - 1];
		}

		/**
		 * @private
		 */
	    override flash_proxy function nextNameIndex(index:int):int
		{
			// initial call
			if (index == 0)
				this.setupPropertyList();
	     
			return index < this.propertyList.length ? index + 1 : 0;
		}

		/**
		 * @private
		 */
	    override flash_proxy function nextValue(index:int):*
	    {
			// initial call
			if (index == 0)
				this.setupPropertyList();

			return this[this.propertyList[index - 1]];
	    }

		/**
		 * @private
		 */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
			var setter:Function = (this.propertyAccessors[name] && this.propertyAccessors[name].setter) as Function;
			if (setter == null)
				throw new Error("No setter is registered for the property \"" + name + "\" on this Settings object.");

			setter(value);
	    }

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 *
		 */
		private function setupPropertyList():void
		{
			this.propertyList = [];
			for (var x:String in this.propertyAccessors)
				this.propertyList.push(x);
		}		 		 		 		

	}
	
}
