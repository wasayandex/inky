package inky.components.listViews
{
	import inky.collections.IList;
	import inky.utils.IDisplayObject;


	/**
	 *
	 *  	
	 *	 	 
	 * @author    Matthew Tretter (matthew@exanimo.com)
	 *
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *	
	 */
	public interface IListView extends IDisplayObject
	{

		/**
		 *
		 */
		function get dataProvider():IList;
		/**
		 * @private
		 */
		function set dataProvider(value:IList):void;
		
		/**
		 *
		 */
		function get rendererClass():Class;
		/**
		 * @private
		 */
		function set rendererClass(rendererClass:Class):void;


		/**
		 *
		 */
		function showItemAt(index:int):void;


	}
}
