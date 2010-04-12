package inky.components.gallery.parsers
{
	import inky.components.gallery.models.GalleryModel;
	
	public interface IGalleryDataParser
	{
		function parse(data:XML):GalleryModel;
		
	}
}