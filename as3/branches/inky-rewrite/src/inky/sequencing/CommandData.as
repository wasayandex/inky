package inky.sequencing 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.29
	 *
	 */
	public class CommandData
	{
		public var command:Object;
		public var propertyGetters:Object;
		
		/**
		 *
		 */
		public function CommandData(command:Object, propertyGetters:Object)
		{
			this.command = command;
			this.propertyGetters = propertyGetters;
		}
	}
	
}
