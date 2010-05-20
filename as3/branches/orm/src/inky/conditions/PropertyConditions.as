package inky.conditions 
{
	import inky.utils.EqualityUtil;
	import inky.conditions.ICondition;

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
	dynamic public class PropertyConditions implements ICondition
	{

		/**
		 *
		 */
		public function PropertyConditions(obj:Object = null)
		{
			this._update(obj, false);
		}




		/**
		 *	
		 *	
		 *	
		 */
		public function test(testee:Object):Boolean
		{
			var matches:Boolean = true;

			for (var prop:String in this)
			{
				if (!testee.hasOwnProperty(prop))
				{
					matches = false;
				}
				else
				{
					var tester:Object = this[prop];
					if (tester is ICondition)
						matches = tester.test(testee[prop]);
					else if (tester is Function)
						matches = tester(testee[prop]);
					else if (tester is RegExp && testee[prop] is String)
						matches = tester.test(testee[prop]);
					else
						matches = EqualityUtil.objectsAreEqual(tester, testee[prop]);
				}
				
				if (!matches)
					break;
			}
			
			return matches;
		}



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
			{
				this[prop] = obj[prop];
			}
		}




	}
}
