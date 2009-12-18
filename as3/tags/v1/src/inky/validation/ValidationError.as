package inky.validation
{


	/**
	 *
	 * ..
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Matthew Tretter
	 * @since  2008.11.17
	 *
	 */
	public class ValidationError
	{
		public var id:String;
		public var message:String;




		/**
		 *
		 * 
		 *
		 */
	    public function ValidationError(message:String, id:String = '')
	    {
			this.id = id;
			this.message = message;
	    }




	}
}