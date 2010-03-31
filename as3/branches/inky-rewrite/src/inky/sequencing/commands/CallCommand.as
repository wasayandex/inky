package inky.sequencing.commands 
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
	public class CallCommand
	{
		public var closure:Function;
		public var scope:Object;
		public var arguments:Array;
		public var result:*;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (this.closure == null)
			{
				this.result = undefined;
				throw new Error("You must specify a method closure.");
			}

			this.result = this.closure.apply(this.scope, this.arguments);
		}
		
	}
	
}
