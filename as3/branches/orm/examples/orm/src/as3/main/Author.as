package
{
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
	dynamic public class Author extends DataMapperResource
	{
		/**
		 *
		 */
		public function Author(firstName:String = null, lastName:String = null)
		{
			if (firstName)
				this.firstName = firstName;
			if (lastName)
				this.lastName = lastName;
		}

		
	}
}
