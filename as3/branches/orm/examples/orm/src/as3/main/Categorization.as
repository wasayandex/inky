package  
{
	import inky.orm.DataMapperResource;
	import inky.orm.IDataMapper;
	
//	[Property("id")]
//	[Property("creationTime")]
	[BelongsTo("category")]
	[BelongsTo("post")]
	
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
		public var id:int;
		public var creationTime:Date;

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
