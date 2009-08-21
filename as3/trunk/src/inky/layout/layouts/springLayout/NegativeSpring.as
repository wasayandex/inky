package inky.layout.layouts.springLayout 
{
	


 	public class NegativeSpring extends Spring {
        private var s:Spring;

        public function NegativeSpring(s:Spring) {
            this.s = s;
        }

// Note the use of max value rather than minimum value here.
// See the opening preamble on arithmetic with springs.

        override public function getMinimumValue():Number {
            return -s.getMaximumValue();
        }

        override public function getPreferredValue():Number {
            return -s.getPreferredValue();
        }

        override public function getMaximumValue():Number {
            return -s.getMinimumValue();
        }

        override public function getValue():Number {
            return -s.getValue();
        }

        override public function setValue(size:Number):void {
            // No need to check for UNSET as
            // Integer.MIN_VALUE == -Integer.MIN_VALUE.
            s.setValue(-size);
        }

        /*pp*/
		override internal function isCyclic(l:SpringLayout):Boolean {
            return s.isCyclic(l);
        }
    }
	
}
