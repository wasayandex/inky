package inky.app.data
{
	import inky.app.inky;
	import inky.app.data.IApplicationData;
	import inky.dynamic.DynamicObject;
	import inky.app.data.SectionDataCollection;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.28
	 *
	 */
	dynamic public class ApplicationData extends DynamicObject implements IApplicationData
	{
		private var _data:Object;


		/**
		 *
		 */
		public function ApplicationData(data:Object = null)
		{
			super(null);
			this._data = data;
		}




		//
		// accessors
		//


		/**
		 *
		 */
		public function get sections():SectionDataCollection
		{ 
			return this._sections || (this._sections = new SectionDataCollection()); 
		}




	}
	
}
