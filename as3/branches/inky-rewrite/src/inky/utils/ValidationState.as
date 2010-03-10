package inky.utils 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.10
	 *
	 */
	public class ValidationState
	{
		private var propertyIsInvalidMap:Object;

		/**
		 *
		 */
		public function ValidationUtil()
		{
			this.propertyIsInvalidMap = {};
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * 
		 */
		public function getInvalidProperties():Array
		{
			var list:Array = [];
			for (var property:String in this.propertyIsInvalidMap)
				list.push(property);
			return list;
		}
		
		/**
		 * 
		 */
		public function hasInvalidProperty():Boolean
		{
			var hasInvalidProperty:Boolean = false;
			for (var p:String in this.propertyIsInvalid)
			{
				hasInvalidProperty = true;
				break;
			}
			return hasInvalidProperty;
		}

		/**
		 * 
		 */
		public function markAllPropertiesAsValid():void
		{
			this.propertyIsInvalidMap = {};
		}

		/**
		 * 
		 */
		public function markPropertyAsInvalid(property:String):void
		{
			this.propertyIsInvalidMap[property] = true;
		}
		
		/**
		 * 
		 */
		public function markPropertyAsValid(property:String):void
		{
			delete this.propertyIsInvalidMap[property];
		}
		
		/**
		 * 
		 */
		public function propertyIsInvalid(property:String):Boolean
		{
			return this.propertyIsInvalid[property] || false;
		}
		
	}
	
}
