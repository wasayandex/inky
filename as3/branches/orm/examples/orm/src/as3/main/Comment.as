package  
{
	import inky.orm.DataMapperResource;
	import inky.orm.IDataMapper;

//	[Property("id")]
//	[Property("author")]
//	[Property("email")]
//	[Property("url")]
//	[Property("body")]
	[BelongsTo("post")]
	[BelongsTo("author", className="User")]
	[HasMany("comments")]

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
		public var id:int;
		public var email:String;
		public var url:String;
		public var body:String;
		
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
