package inky.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 *
	 * Gets a reference to a nested DisplayObject using the specified path.
	 * 
	 * @param parent
	 *     The DisplayObject to which the path is relative
	 * @param path
	 *     The path to the descendant display object. A path is a list of
	 *     DisplayObject instance names delimited by forward slashes.
	 *
	 * @return
	 *     The DisplayObject at the specified location or null, if the
	 *     path does not point to a DisplayObject.
	 *	
	 */
	public function getDescendantByPath(parent:DisplayObjectContainer, path:String):DisplayObject
	{
		var names:Array = path.split('/');
		var tmp:DisplayObject = parent;
		var descendentWasFound:Boolean = true;
		var name:String;

		while (names.length && (tmp is DisplayObjectContainer))
		{
			name = names[0];
			names.shift();
			tmp = (tmp as DisplayObjectContainer).getChildByName(name);

			if (!tmp)
			{
				descendentWasFound = false;
				break;
			}
		}

		return descendentWasFound ? tmp : null;
	}


}