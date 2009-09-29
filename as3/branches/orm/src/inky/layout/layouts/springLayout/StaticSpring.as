package inky.layout.layouts.springLayout 
{

    public class StaticSpring extends AbstractSpring {
        protected var min:Number;
        protected var pref:Number;
        protected var max:Number;

//!
/*        public function StaticSpring() {}

        public StaticSpring(int pref) {
            this(pref, pref, pref);
        }*/

        public function StaticSpring(minOrPref:Number = 0, pref:Number = 0, max:Number = 0) {
			if (arguments.length == 1)
			{
				this.min =
				this.pref =
				this.max =
				this.size = minOrPref;
			}
			else if (arguments.length == 3)
			{
	            this.min = minOrPref;
	            this.pref = pref;
	            this.max = max;
	            this.size = pref;
			}
			else if (arguments.length > 0)
			{
				throw new ArgumentError();
			}
        }

         public function toString():String {
             return "StaticSpring [" + min + ", " + pref + ", " + max + "]";
         }

        override public function getMinimumValue():Number {
            return min;
        }

		override public function getPreferredValue():Number {
            return pref;
        }

        override public function getMaximumValue():Number {
            return max;
        }
    }
	
}
