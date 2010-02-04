package inky.app.data 
{
	import inky.utils.SimpleMap;
	import flash.utils.flash_proxy;
	import inky.app.data.ISectionData;
	
	use namespace flash_proxy;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.02.04
	 *
	 */
	public class SectionDataCollection extends SimpleMap
	{
		
		/**
		 * Adds a section.
		 */
		public function add(sectionData:ISectionData):void
		{
			if (!sectionData)
				throw new ArgumentError("Illegal null argument!");
			
			var id:String = sectionData.id;
			if (!id)
				throw new ArgumentError("SectionData must have a non-empty id.");
			if (this[id])
				throw new ArgumentError("There is already a section with the id " + id);
			super.flash_proxy::setProperty(id, sectionData);
		}




		//
		// flash_proxy methods
		//


		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			throw new Error("You can't delete sections once they're added.");
		} 


		/**
		 * @private
		 */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
			throw new Error("You can't set properties on SectionDataCollections. Use the add() method.");
	    }



		
	}
	
}