package inky.layout.layouts.springLayout 
{
	
    /*pp*/ 
	public class AbstractSpring extends Spring {
        protected var size:Number = Spring.UNSET;

        override public function getValue():Number {
            return size != Spring.UNSET ? size : getPreferredValue();
        }

        override public function setValue(size:Number):void {
            if (size == Spring.UNSET) {
                clear();
                return;
            }
            this.size = size;
        }

        protected function clear():void {
            size = Spring.UNSET;
        }
    }
	
}
