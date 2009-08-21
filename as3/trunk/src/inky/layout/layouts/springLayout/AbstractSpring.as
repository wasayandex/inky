package inky.layout.layouts.springLayout 
{
	
    /*pp*/ 
	public class AbstractSpring extends Spring {
        protected var size:int = UNSET;

        override public function getValue():Number {
            return size != UNSET ? size : getPreferredValue();
        }

        override public function setValue(size:Number):void {
            if (size == UNSET) {
                clear();
                return;
            }
            this.size = size;
        }

        protected function clear():void {
            size = UNSET;
        }
    }
	
}
