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
	 *	@since  2009.06.30
	 *
	 */
	dynamic public class Conditions
	{
// TODO: Rename this?

		/**
		 *
		 */
		public function Conditions(obj:Object = null)
		{
			this._update(obj, false);
		}




		/**
		 *	
		 */
		public function test(testObject:Object):Boolean
		{
			var matches:Boolean = true;

			for (var prop:String in this)
			{
				var testValue:Object = this[prop];
				if (testValue is Function)
					matches = testValue(testObject[prop]);
				else if (testValue is RegExp && testObject[prop] is String)
					matches = testValue.test(testObject[prop]);
				else
					matches = EqualityUtil.objectsAreEqual(testValue, testObject[prop]);
				
				if (!matches)
					break;
			}
			
			return matches;
		}


		/**
		 *	
		 */
		private function _update(obj:Object, clear:Boolean = false):void
		{
			var prop:String;
			
			if (clear)
			{
				for (prop in this)
				{
					if (obj[prop] === undefined)
						delete this[prop];
				}
			}
			
			for (prop in obj)
				this[prop] = obj[prop];
		}




	}
}
