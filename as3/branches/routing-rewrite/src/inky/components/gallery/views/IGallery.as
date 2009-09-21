package inky.components.gallery.views
{
	import inky.utils.IDisplayObject;
	import inky.components.gallery.*;
	import inky.components.gallery.models.*;
	import inky.components.gallery.loading.*;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.01.12
	 *
	 */
	public interface IGallery extends IDisplayObject
	{
		
		//
		// accessors
		//


		/**
		 *
		 *	
		 */
		function get model():GalleryModel;
		/**
		 * @private
		 */
		function set model(model:GalleryModel):void;



		/**
		 *
		 *	
		 */
		function get loadManager():IGalleryLoadManager;
		/**
		 * @private
		 */
		function set loadManager(value:IGalleryLoadManager):void;



	}
}