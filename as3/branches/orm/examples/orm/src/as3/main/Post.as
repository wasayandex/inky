package  
{
	import inky.orm.XMLConfigDataMapperResource;
	import inky.orm.inspection.XMLTypeInspector;
	import inky.orm.inspection.ITypeInspector;
	import inky.orm.relationships.RelationshipType;
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
	public class Post extends XMLConfigDataMapperResource
	{
		private static const XML_CONFIG:XML =
			<type>
				<property name="id" type="Serial" />
				<property name="title" type="String" />
				<property name="body" type="Text" />
				<property name="creationTime" type="DateTime" />

				<association name="comments" type={RelationshipType.HAS_N} />
				<association name="categorizations" type={RelationshipType.HAS_N} />
				<association name="categories" type={RelationshipType.HAS_N} through="categorizations" />
			</type>

		/**
		 *
		 */
		public function Post()
		{
			super(XML_CONFIG);
		}

/*
		class Post
			include DataMapper::Resource

			property :id,         Serial   # An auto-increment integer key
			property :title,      String   # A varchar type string, for short strings
			property :body,       Text     # A text block, for longer string data.
			property :created_at, DateTime # A DateTime, for any date you might like.

			has n, :comments
			has n, :categorizations
			has n, :categories, :through => :categorizations

		end
*/

		/**
		 * 
		 */
		public static function mapper():IDataMapper
		{
			return DataMapperResource.getDataMapper(Post);
		}
		
	}
	
}
