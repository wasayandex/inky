package inky.components.gallery.views 
{
	import inky.components.gallery.models.GalleryItemModel;
	
	
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
		function get dataProvider():GalleryItemModel;
		/**
		 *	@private
		 */
		function set dataProvider(model:GalleryItemModel):void
	}
	
}
