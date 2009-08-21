﻿package inky.layout.layouts.springLayout
{
	import flash.display.DisplayObject;
	import inky.layout.utils.LayoutUtil;


	public class WidthSpring extends AbstractSpring
	{
	    internal var c:DisplayObject;

	    public function WidthSpring(c:DisplayObject/*Component*/) {
	        this.c = c;
	    }

	    override public function getMinimumValue():Number {
	        return LayoutUtil.getMinimumSize(c).width;
	    }

	    override public function getPreferredValue():Number {
	        return LayoutUtil.getPreferredSize(c).width;
	    }

		override public function getMaximumValue():Number {
	        // We will be doing arithmetic with the results of this call,
	        // so if a returned value is Integer.MAX_VALUE we will get
	        // arithmetic overflow. Truncate such values.
	        return Math.min(Number.MAX_VALUE, LayoutUtil.getMaximumSize(c).width);
	    }
	}
}