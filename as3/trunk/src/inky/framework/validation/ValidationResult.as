package inky.framework.validation
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
	public class ValidationResult
	{
		public var isError:Boolean;
		public var subField:String;
		public var errorCode:String;
		public var errorMessage:String;




		/**
		 *
		 * 
		 *
		 */
	    public function ValidationResult(isError:Boolean, subField:String = '', errorCode:String = '', errorMessage:String = '')
	    {
			this.isError = isError;
			this.subField = subField;
			this.errorCode = errorCode;
			this.errorMessage = errorMessage;
	    }




	}
}
