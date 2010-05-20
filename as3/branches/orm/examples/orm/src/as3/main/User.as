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
	 *	@since  2009.09.29
	 *
	 */
	dynamic public class User extends XMLConfigDataMapperResource
	{
		private static const XML_CONFIG:XML =
			<type storageName="usr">
				<property name="id" />
				<property name="firstName" />
				<property name="lastName" />
			</type>
		
		/**
		 *
		 */
		public function User(firstName:String, lastName:String)
		{
			super(XML_CONFIG);
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
