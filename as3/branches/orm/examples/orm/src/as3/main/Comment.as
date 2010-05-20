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
	dynamic public class Comment extends DataMapperResource
	{
		private static const XML_CONFIG:XML =
			<type>
			</type>	

		/*

		class Comment
			include DataMapper::Resource

			property :id,         Serial
			property :posted_by,  String
			property :email,      String
			property :url,        String
			property :body,       Text
			
			belongs_to :post
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
