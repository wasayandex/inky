package inky.framework.components.gallery.views 
{
	import inky.framework.components.gallery.models.GalleryItemModel;
	
	
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
	 *	@since  2009.03.30
	 *
	 */
	public interface IGalleryItemView
	{
		
		/**
		 *	
		 */
		function get model():GalleryItemModel;
		/**
		 *	@private
		 */
		function set model(model:GalleryItemModel):void
	}
	
}
