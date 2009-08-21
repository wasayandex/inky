﻿package inky.layout.layouts.springLayout 
{
	


    public class SumSpring extends CompoundSpring {
        public function SumSpring(s1:Spring, s2:Spring) {
            super(s1, s2);
        }

        override protected function op(x:int, y:int):int {
            return x + y;
        }

        override public function setValue(size:Number):void {
            super.setValue(size);
            if (size == UNSET) {
                return;
            }
            s1.setStrain(this.getStrain());
            s2.setValue(size - s1.getValue());
        }
    }

}
