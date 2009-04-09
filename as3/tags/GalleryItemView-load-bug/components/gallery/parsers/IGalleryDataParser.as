package inky.framework.components.gallery.parsers
{
	import inky.framework.components.gallery.models.GalleryModel;
	
	public interface IGalleryDataParser
	{
		function parse(data:XML):GalleryModel;
		
	}
}