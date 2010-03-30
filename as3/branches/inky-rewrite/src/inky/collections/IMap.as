package inky.collections
{
	import inky.collections.ICollection;
	import inky.utils.IEquatable;


	/**
	 *
	 * 
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.06.21
	 *
	 */
    public interface IMap extends IEquatable
    {

		//
		// accessors
		//


		/**
		 *
		 *
		 */
		function get isEmpty():Boolean;




		//
		// public methods
		//


		/**
		 *
		 *
		 */
		function containsKey(key:Object):Boolean;


		/**
		 *
		 *
		 */
		function containsItem(item:Object):Boolean;


		/**
		 *
		 *
		 */
//		function entrySet():ISet;


		/**
		 *
		 *
		 */
		function getItemByKey(key:Object):Object;


		/**
		 *
		 *
		 */
		function getKeys():ICollection;

	
		/**
		 *
		 *
		 */
		function getValues():ICollection;


		/**
		 *
		 *
		 */
//		function keySet():ISet;


		/**
		 *
		 *
		 */
		function putItemAt(item:Object, key:Object):Object;


		/**
		 *
		 *
		 */
		function putItems(t:IMap):void;


		/**
		 *
		 *
		 */
		function removeAll():void;


		/**
		 *
		 *
		 */
		function removeItemByKey(key:Object):Object;




		//
		// accessors
		//


		/**
		 *
		 *
		 */
		function get length():int;




    }
}
