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
	public class SetPropertiesCommand
	{
		public var propertyValues:Object = {};
		public var target:Object;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (!this.target)
				throw new Error("SetPropertiesCommand requires a target.");
			if (!this.propertyValues)
				throw new Error("SetPropertiesCommand requires propertyValues.");
			
			for (var property:String in this.propertyValues)
				this.target[property] = this.propertyValues[property];
		}

		
	}
	
}
