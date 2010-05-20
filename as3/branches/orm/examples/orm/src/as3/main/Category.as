package  
{
	import inky.orm.DataMapperResource;
	import inky.orm.inspection.XMLTypeInspector;
	import inky.orm.inspection.ITypeInspector;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.05.19
	 *
	 */
	public class Category
	{
		private static const XML_CONFIG:XML =
			<type>
			</type>

		/*

		class Category
			include DataMapper::Resource

			property :id,         Serial
			property :name,       String

			has n, :categorizations
			has n, :posts,      :through => :categorizations
		end
		
		*/
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function _createTypeInspector():ITypeInspector
		{
			return new XMLTypeInspector(XML_CONFIG);
		}
	}
	
}
