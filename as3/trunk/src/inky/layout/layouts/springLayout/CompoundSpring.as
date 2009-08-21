﻿package inky.layout.layouts.springLayout 
{
	

	// Use the instance variables of the StaticSpring superclass to
	// cache values that have already been calculated.
	    /*pp*/
	public class CompoundSpring extends StaticSpring {
	        protected var s1:Spring;
	        protected var s2:Spring;

	        public function CompoundSpring(s1:Spring, s2:Spring) {
	            clear();
	            this.s1 = s1;
	            this.s2 = s2;
	        }

	        override public function toString():String {
	            return "CompoundSpring of " + s1 + " and " + s2;
	        }

	        override protected function clear():void {
	            min = pref = max = size = UNSET;
	        }

	        override public function setValue(size:Number):void {
	            if (size == UNSET) {
	                if (this.size != UNSET) {
	                    super.setValue(size);
	                    s1.setValue(UNSET);
	                    s2.setValue(UNSET);
	                    return;
	                }
	            }
	            super.setValue(size);
	        }

	        protected function op(x:int, y:int):int
			{
throw new Error();
			}

	        override public function getMinimumValue():Number {
	            if (min == UNSET) {
	                min = op(s1.getMinimumValue(), s2.getMinimumValue());
	            }
	            return min;
	        }

	       override public function getPreferredValue():Number {
	            if (pref == UNSET) {
	                pref = op(s1.getPreferredValue(), s2.getPreferredValue());
	            }
	            return pref;
	        }

	        override public function getMaximumValue():Number {
	            if (max == UNSET) {
	                max = op(s1.getMaximumValue(), s2.getMaximumValue());
	            }
	            return max;
	        }

	        override public function getValue():Number {
	            if (size == UNSET) {
	                size = op(s1.getValue(), s2.getValue());
	            }
	            return size;
	        }

	        /*pp*/
			override internal function isCyclic(l:SpringLayout):Boolean {
	            return l.isCyclic(s1) || l.isCyclic(s2);
	        }
	    };
	
}
