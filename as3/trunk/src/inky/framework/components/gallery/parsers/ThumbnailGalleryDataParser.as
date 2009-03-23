package inky.framework.components.gallery.parsers
{
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.models.*;
	import inky.framework.components.gallery.parsers.*;


	public class ThumbnailGalleryDataParser extends GalleryDataParser
	{
	




		override protected function setItemProperties(item:GalleryItemModel, props:Object):void
		{
			for (var prop:String in props)
			{
				var match:Object = prop.match(/^thumbnail(.)(.*)$/);
				var actualProp:String = null;
				if (match)
				{
 					actualProp = match[1].toLowerCase() + match[2];
 					item[actualProp] = props[prop];
				}
				else
				{
					// If there isn't a thumbnail version of the property, then use this version.
					var thumbnailProp:String = "thumbnail" + prop.substr(0, 1).toUpperCase() + prop.substr(1);
					if (props[thumbnailProp] == null)
					{
						item[prop] = props[prop];
					}
				}
			}
		}



		
	}
}