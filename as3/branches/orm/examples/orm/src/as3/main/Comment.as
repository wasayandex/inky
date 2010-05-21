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
	dynamic public class Comment extends XMLConfigDataMapperResource
	{
		private static const XML_CONFIG:XML =
			<type>
				<property name="id" type="Serial" />
				<property name="author" type="String" />
				<property name="email" type="String" />
				<property name="url" type="String" />
				<property name="body" type="Text" />
				
				<association name="post" type={RelationshipType.BELONGS_TO} />
			</type>

		/**
		 *
		 */
		public function Comment()
		{
			super(XML_CONFIG);
		}

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
		
		/**
		 * 
		 */
		public static function mapper():IDataMapper
		{
			return DataMapperResource.getDataMapper(Comment);
		}

	}
	
}
