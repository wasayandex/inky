package inky.utils
{
	import inky.utils.IEquatable;


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
		public static function propertiesAreEqual(objA:Object, objB:Object):Boolean
		{
			return EqualityUtil._propertiesAreEqual(objA, objB) && EqualityUtil._propertiesAreEqual(objB, objA);
		}


		private static function _propertiesAreEqual(objA:Object, objB:Object):Boolean
		{
			var propertiesAreEqual:Boolean;
			
			if ((objA && !objB) || (objB && !objA))
			{
				propertiesAreEqual = false;
			}
			else
			{
				propertiesAreEqual = true;
				var prop:String;
				for (prop in objA)
				{
					if (!objB.hasOwnProperty(prop) || !EqualityUtil.objectsAreEqual(objA[prop], objB[prop]))
					{
						propertiesAreEqual = false;
						break;
					}
				}
			}

			return propertiesAreEqual;
		}



	}
}
