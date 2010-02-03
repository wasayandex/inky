package inky.utils 
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.15
	 *
	 */
	public class SimpleMap extends Proxy
	{
		private var _item:Object;
		private var _propertyList:Array;


		/**
		 *
		 */	
	    public function SimpleMap(obj:Object = null)
	    {
			this._item = obj || {};
	    }




		//
		// flash_proxy methods
		//
		

		/**
		 * @private
		 */
	    override flash_proxy function callProperty(methodName:*, ... args):*
	    {
			return this[methodName].apply(this, args);
	    }


		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			if (name in this._item)
			{
				delete this._item[name];
				return true;
			}
			return false;
		} 


		/**
		 * @private
		 */
	    override flash_proxy function getDescendants(name:*):*
	    {
	    	throw new TypeError('Error #1016: Descendants operator (..) not supported on this type.');
	    }


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			return this._item[name];
	    }


		/**
		 * @private
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	        return name in this._item;
	    }


		/**
		 * @private
		 */
		override flash_proxy function nextName(index:int):String
		{
			return this._propertyList[index - 1];
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextNameIndex(index:int):int
		{
			// initial call
			if (index == 0)
				this._setupPropertyList();
	     
			return index < this._propertyList.length ? index + 1 : 0;
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextValue(index:int):*
	    {
			// initial call
			if (index == 0)
				this._setupPropertyList();

			return this._item[this._propertyList[index - 1]];
	    }


		/**
		 * @private
		 */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
			this._item[name] = value;
	    }




		//
		// private methods
		//
		

		/**
		 *
		 *
		 *
		 */
		private function _setupPropertyList():void
		{
			this._propertyList = [];
			for (var x:* in this._item)
			{
				this._propertyList.push(x);
			}
		}		 		 		 		




		//
		// public methods
		//


		/**
		 * @copy Object#toString()
		 */
		public function toString():String 
		{
			return this._item.toString.call(this);
		}



		
	}
	
}