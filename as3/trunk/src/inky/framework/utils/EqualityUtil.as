package inky.framework.utils
{
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
	public class EqualityUtil
	{
		/**
		 *
		 *	
		 */
		public function EqualityUtil()
		{
			throw new Error('EqualityUtil contains static utility methods and cannot be instantialized.');
		}




		//
		// public methods
		//


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


		/**
		 *
		 *	
		 */
		public static function propertiesMatch(objA:Object, objB:Object):Boolean
		{
			return EqualityUtil._propertiesMatch(objA, objB) && EqualityUtil._propertiesMatch(objB, objA);
		}


		private static function _propertiesMatch(objA:Object, objB:Object):Boolean
		{
			var propertiesMatch:Boolean;
			
			if ((objA && !objB) || (objB && !objA))
			{
				propertiesMatch = false;
			}
			else
			{
				propertiesMatch = true;
				var prop:String;
				for (prop in objA)
				{
					if (!objB.hasOwnProperty(prop) || !EqualityUtil.objectsAreEqual(objA[prop], objB[prop]))
					{
						propertiesMatch = false;
						break;
					}
				}
			}

			return propertiesMatch;
		}



	}
}
