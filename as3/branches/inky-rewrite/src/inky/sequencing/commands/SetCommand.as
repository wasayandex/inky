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
	 *	@since  2010.03.31
	 *
	 */
	public class SetCommand
	{
		public var property:String;
		public var target:Object;
		public var value:*;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (!this.target)
				throw new Error("SetCommand requires a target.");
			if (!this.property)
				throw new Error("SetCommand requires a property.");
			
			this.target[this.property] = this.value;
		}

		
	}
	
}
