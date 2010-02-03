package inky.dynamic 
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import inky.utils.SimpleMap;

	use namespace flash_proxy;
	
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
	public class DynamicObject extends SimpleMap
	{
		private var _frozen:Boolean;


		/**
		 *
		 */	
	    public function DynamicObject(obj:Object = null)
	    {
			super(obj);
	    }




		//
		// flash_proxy methods
		//


		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
// TODO: Better error message.
			if (!this._frozen)
				throw new Error("You can't delete properties from a frozen DynamicObject.");
			
			return super.flash_proxy::deleteProperty(name);
		} 


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			if (this._frozen && !this.hasOwnProperty(name))
				throw new Error('Property "' + name + '" not found on ' + this);
			return super.flash_proxy::getProperty(name);
	    }


		/**
		 * @private
		 */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
			if (this._frozen && !this.hasOwnProperty(name))
				throw new Error('Property "' + name + '" cannot be created on ' + this.toString());
			super.flash_proxy::setProperty(name, value);
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
		 * 
		 */
		public function unfreeze():void
		{
			this._frozen = false;
		}



		
	}
	
}