package inky.layout.layouts.springLayout 
{
	


    public class SumSpring extends CompoundSpring {
        public function SumSpring(s1:Spring, s2:Spring) {
            super(s1, s2);
        }

        override protected function op(x:Number, y:Number):Number {
            return x + y;
        }

        override public function setValue(size:Number):void {
            super.setValue(size);
            if (size == Spring.UNSET) {
                return;
            }
            s1.setStrain(this.getStrain());
            s2.setValue(size - s1.getValue());
        }
    }

}
