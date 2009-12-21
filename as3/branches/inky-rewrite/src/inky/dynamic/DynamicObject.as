package inky.dynamic 
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
	public class DynamicObject extends Proxy
	{
		private var _frozen:Boolean;
		private var _item:Object;
		private var _propertyList:Array;


		/**
		 *
		 */	
	    public function DynamicObject(obj:Object = null)
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
	    	throw new TypeError('Error #1016: Descendants operator (..) not supported on type ModelData.');
	    }


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			if (this._frozen && !this.hasOwnProperty(name))
				throw new Error('Property "' + name + '" not found on ' + this);
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
			if (this._frozen && !this.hasOwnProperty(name))
				throw new Error('Property "' + name + '" cannot be created on ' + this.toString());
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
// TODO: Should constructor accept a list of properties to add to the object and automatically freeze if present?
// TODO: Look to ecmascript proposals for better names than freeze() and unfreeze()
// TODO: Namespace freeze and unfreeze?
		/**
		 * 
		 */
		public function freeze():void
		{
			this._frozen = true;
		}


		/**
		 * @copy Object#toString()
		 */
		public function toString():String 
		{
			return this._item.toString.call(this);
		}


		/**
		 * 
		 */
		public function unfreeze():void
		{
			this._frozen = false;
		}

		
	}
	
}