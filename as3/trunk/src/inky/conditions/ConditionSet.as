package inky.conditions 
{
	import inky.conditions.ICondition;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.02.09
	 *
	 */
	public class ConditionSet implements ICondition
	{
		private var _conditions:Array;
		
		/**
		 *
		 */
		public function ConditionSet()
		{
			this._conditions = [];
		}


		/**
		 * 
		 */
		public function add(condition:ICondition):void
		{
			this._conditions.push(condition);
		}


		/**
		 * @inheritDoc
		 */
		public function test(testee:Object):Boolean
		{
			var match:Boolean = true;
			for each (var condition:ICondition in this._conditions)
			{
				match = condition.test(testee);
				if (!match)
					break;
			}
			return match;
		}

	}
	
}