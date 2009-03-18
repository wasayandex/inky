package inky.framework.utils
{
	import inky.framework.utils.ICloneable;
	import inky.framework.utils.IEquatable;


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
	public class ObjectUtil
	{
		/**
		 *
		 *	
		 */
		public function ObjectUtil()
		{
			throw new Error('ObjectUtil contains static utility methods and cannot be instantialized.');
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
					clone[i] = ObjectUtil.clone(obj[i]);
				}
			}
			else
			{
				throw new ArgumentError('Object ' + obj + ' cannot be cloned.');
			}
			
			return clone;
		}


		/**
		 *
		 * 
		 *	
		 */
		public static function objectsAreEqual(objA:Object, objB:Object):Boolean
		{
			var objectsAreEqual:Boolean;
		
			if (objA is IEquatable)
			{
				objectsAreEqual = objA.equals(objB);
			}
			else if (objB is IEquatable)
			{
				objectsAreEqual = objB.equals(objA);
			}
			else
			{
				objectsAreEqual = objA == objB;
			}
			
			return objectsAreEqual;
		}




	}
}
