package inky.layout.layouts.springLayout 
{
	
    public class MaxSpring extends CompoundSpring {

        public function MaxSpring(s1:Spring, s2:Spring) {
            super(s1, s2);
        }

        override protected function op(x:int, y:int):int {
            return Math.max(x, y);
        }

        override public function setValue(size:Number):void {
            super.setValue(size);
            if (size == UNSET) {
                return;
            }
            // Pending should also check max bounds here.
            if (s1.getPreferredValue() < s2.getPreferredValue()) {
                s1.setValue(Math.min(size, s1.getPreferredValue()));
                s2.setValue(size);
            }
            else {
                s1.setValue(size);
                s2.setValue(Math.min(size, s2.getPreferredValue()));
            }
        }
    }
	
}
