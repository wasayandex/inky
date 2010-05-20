package
{
	import inky.orm.DataMapperResource;
	import inky.orm.inspection.XMLTypeInspector;
	import inky.orm.inspection.ITypeInspector;

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
			this.firstName = firstName;
			this.lastName = lastName;
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function _createTypeInspector():ITypeInspector
		{
			return new XMLTypeInspector(XML_CONFIG);
		}
		
	}
}
