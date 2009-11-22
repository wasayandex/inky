package inky.utils
{
	/**
	 *
	 * ArrayUtil.as
	 *
	 *	@author     matthew at exanimo dot com
	 *	@author     Ryan Sprake
	 *	@version    2007.11.05
	 *
	 */
	public class ArrayUtil
	{
		/**
		 *
		 *	
		 */
		public function ArrayUtil()
		{
			throw new Error('ArrayUtil contains static utility methods and cannot be instantialized.');
		}


		/**
		 *
		 *	Determines whether the first array contains all of the values in the
		 *	second.
		 * 
		 *	@param arr
		 *		The array to search.
		 *	@param values
		 *		An array of values to look for in the first array.
		 * 
		 *	@return
		 *		True if the first array contains all the values in the second.
		 *		False if it does not.
		 *	
		 */			
		public static function arrayContainsValues(arr:Array, values:Array):Boolean
		{
			var containsValues:Boolean = true;
			
			for each (var item:Object in values)
			{
				if (arr.indexOf(item) == -1)
				{
					containsValues = false;
					break;
				}
			}
			
			return containsValues;
		}


		/**
		 *
		 *	Determines whether the arrays are equal (i.e. have the same length
		 *	and the same items at the same positions).
		 * 
		 *	@param arr
		 *	@param arr2
		 * 
		 *	@return
		 *		True if the arrays are equal, otherwise false.
		 *	
		 */			
		public static function arraysAreEqual(arr:Array, arr2:Array):Boolean
		{
			var arraysAreEqual:Boolean = false;
			
			if (arr.length == arr2.length)
			{
				arraysAreEqual = true;

				for (var i:uint = 0; i < arr.length; i++)
				{
					if (arr[i] != arr2[i])
					{
						arraysAreEqual = false;
						break;
					}
				}
			}
			
			return arraysAreEqual;
		}


		/**
		 *
		 *	Creates an Array consisting of the values of the given property for
		 *	each item in the supplied Array.
		 * 
		 *	@param arr
		 *		The array to search.
		 *	@param field
		 *		The name of the property to use.
		 * 
		 *	@return
		 *		A new Array consisting of the field values of the provided
		 *      Array.
		 *	
		 */			
		public static function getFieldValues(arr:Array, field:String):Array
		{
			return arr.map(
				function(item:*, index:int, array:Array):*
				{
					return item[field];
				}
			);
		}



	}
}