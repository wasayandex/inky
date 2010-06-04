package  
{
	import inky.orm.DataMapperResource;
	import inky.orm.IDataMapper;

//	[Property("id")]
//	[Property("name")]
	[HasMany("categorizations")]
	[HasMany("posts", through="categorizations")]

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
	public class Category extends DataMapperResource
	{
		public var id:int;
		public var name:String;
		
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
