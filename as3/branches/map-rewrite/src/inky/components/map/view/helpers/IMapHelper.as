package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.HelperInfo;
	import inky.utils.IDestroyable;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.29
	 *
	 */
	public interface IMapHelper extends IDestroyable
	{

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		function initialize(helperInfo:HelperInfo):void;
		
	}
	
}