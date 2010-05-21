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
	public class Category extends XMLConfigDataMapperResource
	{
		private static const XML_CONFIG:XML =
			<type>
				<property name="id" type="Serial" />
				<property name="name" type="String" />
				
				<association name="categorizations" type={RelationshipType.HAS_N} />
				<association name="posts" type={RelationshipType.HAS_N} through="categorizations" />
			</type>

		/**
		 *
		 */
		public function Category()
		{
			super(XML_CONFIG);
		}

		/*

		class Category
			include DataMapper::Resource

			property :id,         Serial
			property :name,       String

			has n, :categorizations
			has n, :posts,      :through => :categorizations
		end
		
		*/

		/**
		 * 
		 */
		public static function mapper():IDataMapper
		{
			return DataMapperResource.getDataMapper(Category);
		}

	}
	
}
