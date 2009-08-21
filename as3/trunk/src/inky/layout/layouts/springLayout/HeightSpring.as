﻿package inky.layout.layouts.springLayout 
{
	import flash.display.DisplayObject;
	import inky.layout.utils.LayoutUtil;


     /*pp*/
  	public class HeightSpring extends AbstractSpring
	{
		internal var c:DisplayObject;

        public function HeightSpring(c:DisplayObject) {
            this.c = c;
        }

        override public function getMinimumValue():Number {
            return LayoutUtil.getMinimumSize(c).height;
        }

        override public function getPreferredValue():Number {
            return LayoutUtil.getPreferredSize(c).height;
        }

		override public function getMaximumValue():Number {
            return Math.min(Number.MAX_VALUE, LayoutUtil.getMaximumSize(c).height);
        }
    }

	
}