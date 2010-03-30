package inky.sequencing.commands 
{
	import inky.sequencing.commands.IAsyncCommand;
	import flash.events.EventDispatcher;
	
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
	public class WaitCommand extends EventDispatcher implements IAsyncCommand
	{
		public var forObject:Object;
		public var to:String;
		
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
trace("waiting for " + this.forObject);
		}

		
	}
	
}