package inky.app.data 
{
	import inky.app.data.IViewData;
	
	/**
	 *
	 *  Adapts the SectionData object to the IViewData interface.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.02.03
	 *
	 */
	public class SectionViewData implements IViewData
	{
		/**
		 *
		 */
		public function SectionViewData(sectionData:ISectionData)
		{
			
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get stack():Array
		{
		}
		
	}
	
}