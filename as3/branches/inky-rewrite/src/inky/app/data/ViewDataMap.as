package inky.app.data 
{
	import flash.utils.flash_proxy;
	import inky.utils.SimpleMap;
	import inky.app.data.IViewDataMap;
	import inky.app.data.IApplicationData;

	use namespace flash_proxy;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.02.03
	 *
	 */
	public class ViewDataMap extends SimpleMap implements IViewDataMap
	{
		private var _appData:IApplicationData;
		
		/**
		 *
		 */
		public function ViewDataMap(appData:IApplicationData)
		{
			if (!appData)
				throw new ArgumentError("Illegal null argument.");
			this._appData = appData;
		}




		//
		// flash_proxy methods
		//


		/**
		 * @inheritDoc
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var value:*;
			
			if (super.flash_proxy::hasProperty(name))
			{
				value = super.flash_proxy::getProperty(name);
			}
			else
			{
				// Get the value from the app data sections.
trace(name);
//!
			}
			
			return value;
		}


		/**
		 * @inheritDoc
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
			return super.flash_proxy::hasProperty(name) || (this.flash_proxy::getProperty(name) != undefined);
	    }




	}
}