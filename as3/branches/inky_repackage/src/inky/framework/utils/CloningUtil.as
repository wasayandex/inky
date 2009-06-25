package inky.framework.utils
{
	import inky.framework.utils.ICloneable;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2008.03.17
	 *
	 */
	public class CloningUtil
	{
		/**
		 *
		 *	
		 */
		public function CloningUtil()
		{
			throw new Error('CloningUtil contains static utility methods and cannot be instantialized.');
		}




		//
		// public methods
		//


		/**
		 *
		 * Clones a simple object.
		 *
		 * @param obj:Object
		 *     the object to clone
		 * @return Object
		 *     the object
		 * @throws Error
		 *     thrown if a clone could not be created
		 *	
		 */
		public static function clone(obj:Object):Object
		{
			var clone:Object;

			if (obj === null)
			{
				clone = null;
			}
			else if (obj is ICloneable)
			{
				clone = obj.clone();
			}
			else if ((obj is String) || (obj is Number) || (obj is int) || (obj is uint))
			{
				clone = obj;
			}
			else if (obj.constructor == Object)
			{
				clone = {};
				for (var i:String in obj)
				{
					clone[i] = CloningUtil.clone(obj[i]);
				}
			}
			else
			{
				throw new ArgumentError('Object ' + obj + ' cannot be cloned.');
			}
			
			return clone;
		}




	}
}
