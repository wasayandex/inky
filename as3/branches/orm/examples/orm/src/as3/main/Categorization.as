package  
{
	import inky.orm.DataMapperResource;
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
	public class Categorization extends DataMapperResource
	{
		private static const XML_CONFIG:XML =
			<type>
				<property name="id" />
				<property name="creationTime" type="Date" />

				<belongsTo SOMETHING="category" />
				<belongs to="post" />
			</type>
		
		/**
		 * 
		 */
		override protected function _createTypeInspector():ITypeInspector
		{
			return new XMLTypeInspector(XML_CONFIG);
		}

		/*

		class Categorization
			include DataMapper::Resource

			property :id,         Serial
			property :created_at, DateTime

			belongs_to :category
			belongs_to :post
		end
		
		*/

	}
	
}
