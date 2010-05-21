package  
{
	import inky.orm.XMLConfigDataMapperResource;
	import inky.orm.inspection.XMLTypeInspector;
	import inky.orm.inspection.ITypeInspector;
	import inky.orm.IDataMapper;
	import inky.orm.DataMapperResource;
	
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
	public class Categorization extends XMLConfigDataMapperResource
	{
		private static const XML_CONFIG:XML =
			<type>
				<property name="id" type="Serial" />
				<property name="creationTime" type="DateTime" />

				<association name="category" type={RelationshipType.BELONGS_TO} />
				<association name="post" type={RelationshipType.BELONGS_TO} />
			</type>
		
		/**
		 *
		 */
		public function Categorization()
		{
			super(XML_CONFIG);
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
		
		/**
		 * 
		 */
		public static function mapper():IDataMapper
		{
			return DataMapperResource.getDataMapper(Categorization);
		}

	}
	
}
