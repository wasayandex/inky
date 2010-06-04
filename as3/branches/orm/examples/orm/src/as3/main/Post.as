package  
{
	import inky.orm.DataMapperResource;
	import inky.orm.IDataMapper;

//	[Property("id")]
//	[Property("title")]
//	[Property("body")]
//	[Property("creationTime")]
	[HasMany("comments")]
	[HasMany("categorizations")]
	[HasMany("categories", through="categorizations")]

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
	public class Post extends DataMapperResource
	{
		public var id:int;
		public var title:String;
		public var body:String;
		public var creationTime:Date;
		
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
