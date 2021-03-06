﻿package inky.layout.layouts.springLayout 
{
	


    public class ScaleSpring extends Spring {
        private var s:Spring;
        private var factor:Number;

        public function ScaleSpring(s:Spring, factor:Number) {
            this.s = s;
            this.factor = factor;
        }

        override public function getMinimumValue():Number {
            return Math.round((factor < 0 ? s.getMaximumValue() : s.getMinimumValue()) * factor);
        }

        override public function getPreferredValue():Number {
            return Math.round(s.getPreferredValue() * factor);
        }

        override public function getMaximumValue():Number {
            return Math.round((factor < 0 ? s.getMinimumValue() : s.getMaximumValue()) * factor);
        }

        override public function getValue():Number {
            return Math.round(s.getValue() * factor);
        }

        override public function setValue(value:Number):void {
            if (value == Spring.UNSET) {
                s.setValue(Spring.UNSET);
            } else {
                s.setValue(Math.round(value / factor));
            }
        }

        /*pp*/
 		override internal function isCyclic(l:SpringLayout):Boolean {
            return s.isCyclic(l);
        }
    }
	
}
