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
		public var callee:Function;
		public var scope:Object;
		public var arguments:Array = [];
		public var result:*;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (this.callee == null)
			{
				this.result = undefined;
				throw new Error("You must specify a callee.");
			}

			this.result = this.callee.apply(this.scope, this.arguments);
		}
		
	}
	
}
