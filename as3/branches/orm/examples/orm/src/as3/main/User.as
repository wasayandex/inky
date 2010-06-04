package
{
	import inky.orm.DataMapperResource;
	import inky.orm.IDataMapper;

//	[Property("id")]
//	[Property("firstName")]
//	[Property("lastName")]

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.09.29
	 *
	 */
	dynamic public class User extends DataMapperResource
	{
		public var id:int;
		public var firstName:String;
		public var lastName:String;
		
		/**
		 *
		 */
		public function User(firstName:String, lastName:String)
		{
			this.firstName = firstName;
			this.lastName = lastName;
		}
		
		/**
		 * 
		 */
		public static function mapper():IDataMapper
		{
			return DataMapperResource.getDataMapper(User);
		}
		
	}
}
