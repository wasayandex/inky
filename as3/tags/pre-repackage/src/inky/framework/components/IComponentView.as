package inky.framework.components
{
	import inky.framework.display.IDisplayObject;


	/**
	 *
	 *  	
	 *	 	 
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	
	 *	@author Matthew Tretter
	 *	@since  2008.01.14
	 *
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *	
	 */
	public interface IComponentView extends IDisplayObject
	{

		/**
		 *
		 */
		function get model():Object;
		/**
		 * @private
		 */
		function set model(model:Object):void;


	}
}
