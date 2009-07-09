package inky.framework.utils
{
	import flash.utils.Dictionary;


	/**
	 *
	 * <p>..</p>
	 *	
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Matthew Tretter
	 * @since  2007.11.02
	 *
	 */
	public class UIDUtil
	{
		private static var _itemCount:uint = 0;
		private static var _uidDictionary = new Dictionary(true);


		/**
		 *
		 *	
		 */
		public static function getUID(obj:Object):String
		{
			var index:Number = UIDUtil._uidDictionary[obj];
			if (isNaN(index))
			{
				index = UIDUtil._itemCount++;
				UIDUtil._uidDictionary[obj] = index;
			}
			return index.toString(36);
		}




	}
}
