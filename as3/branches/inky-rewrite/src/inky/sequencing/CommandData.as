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
		public var injectors:Array;
		
		/**
		 *
		 */
		public function CommandData(command:Object, injectors:Array)
		{
			this.command = command;
			this.injectors = injectors;
		}
	}
	
}
