package com.exanimo.gallery.parsers
{
	import com.exanimo.gallery.data.GalleryModel;
	
	public interface IGalleryDataParser
	{
		function parse(data:XML):GalleryModel;
		
	}
}