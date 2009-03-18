package inky.framework.components.gallery.parsers
{
	import inky.framework.components.gallery.data.GalleryModel;
	
	public interface IGalleryDataParser
	{
		function parse(data:XML):GalleryModel;
		
	}
}