package inky.framework.components.gallery.parsers
{
	import inky.framework.collections.*;
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.models.*;
	import inky.framework.components.gallery.parsers.*;


	public class GalleryDataParser implements IGalleryDataParser
	{
	

		public function parse(data:XML):GalleryModel
		{
			var prop:XML;
			var model:GalleryModel = new GalleryModel();
			
			// Set the model properties
			for each (prop in data.attributes())
			{
				model[String(prop.localName())] = String(prop);
			}

			// Create the groups.
			for each (var groupXML:XML in data.group)
			{
				var group:GalleryGroupModel = new GalleryGroupModel();
				var groupProperties:Object = {};
				
				// Set the group properties.
				for each (prop in groupXML.attributes())
				{
					groupProperties[String(prop.localName())] = String(prop);
				}
				this.setGroupProperties(group, groupProperties);

				// Create the items.
				for each (var itemXML:XML in groupXML.item)
				{
					var item:GalleryItemModel = new GalleryItemModel();
					var itemProperties:Object = {};
					
					// Set the group properties.
					for each (prop in itemXML.attributes())
					{
						itemProperties[String(prop.localName())] = String(prop);
					}

					this.setItemProperties(item, itemProperties);
// FIXME: the next line should not be necessary. It should be done automatically by the group when an item is added.
					item.gallery_model::setGroup(group);
					group.items.addItem(item);
					
					// Create the images.
					for each (var imageXML:XML in itemXML.image)
					{
						var image:GalleryImageModel = new GalleryImageModel();
						var imageProperties:Object = {};
						
						// Set the image properties.
						for each (prop in imageXML.attributes())
						{
							imageProperties[String(prop.localName())] = String(prop);
						}
						
						this.setImageProperties(image, imageProperties);
// FIXME: the next line should not be necessary. It should be done automatically by the item when an image is added.
						image.gallery_model::setItem(item);
						item.images.addItem(image);
					}
				}
				
				if (!group.name)
				{
					throw new Error("Gallery group elements must have a name attribute.");
				}
				else
				{
					model.groups.putItemAt(group, group.name);
				}
			}
			
			return model;
		}





		protected function setImageProperties(image:GalleryImageModel, props:Object):void
		{
			this._setProperties(image, props);
		}

		protected function setItemProperties(item:GalleryItemModel, props:Object):void
		{
			this._setProperties(item, props);
		}
		
		private function _setProperties(obj:Object, props:Object):void
		{
			for (var prop:String in props)
			{
				obj[prop] = props[prop];
			}
		}

		protected function setGroupProperties(group:GalleryGroupModel, props:Object):void
		{
			this._setProperties(group, props);
		}



		
	}
}