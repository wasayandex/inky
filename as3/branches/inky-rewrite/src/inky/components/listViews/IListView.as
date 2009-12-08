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
		function get model():IList;
		/**
		 * @private
		 */
		function set model(model:IList):void;
		
		/**
		 *
		 */
		function get itemViewClass():Class;
		/**
		 * @private
		 */
		function set itemViewClass(itemViewClass:Class):void;


		/**
		 *
		 */
		function showItemAt(index:int):void;


	}
}
