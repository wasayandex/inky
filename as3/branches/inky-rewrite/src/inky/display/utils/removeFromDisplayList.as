package inky.display.utils 
{
	import flash.display.DisplayObject;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.16
	 *
	 */
	public function removeFromDisplayList(child:DisplayObject):void
	{
		if (child && child.parent)
			child.parent.removeChild(child);
	}
	
}
