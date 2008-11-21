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
		public var errors:Array;
		public var isError:Boolean;
		public var field:String;
		public var subFieldErrors:Object;
		public var subFieldResults:Object;




		/**
		 *
		 * 
		 *
		 */
	    public function ValidationResult(isError:Boolean, field:String = '', errors:Array = null, subFieldResults:Object = null, subFieldErrors:Object = null)
	    {
			this.isError = isError;
			this.field = field;
			this.errors = errors || [];
			this.subFieldResults = subFieldResults || {};
			this.subFieldErrors = subFieldErrors || {};
	    }




	}
}