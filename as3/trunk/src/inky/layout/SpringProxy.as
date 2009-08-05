package inky.layout
{
	import flash.display.DisplayObject;

	public class SpringProxy extends Spring
	{
	    private var edgeName:String;
	    private var c:DisplayObject;
	    private var l:SpringLayout;

	    public function SpringProxy(edgeName:String, c:DisplayObject, l:SpringLayout)
		{
	        this.edgeName = edgeName;
	        this.c = c;
	        this.l = l;
	    }

	    private function getConstraint():Spring
		{
	        return l.getConstraints(c).getConstraint(edgeName);
	    }

		override public function getMinimumValue():Number
		{
	        return getConstraint().getMinimumValue();
	    }

	    override public function getPreferredValue():Number
		{
	        return getConstraint().getPreferredValue();
	    }

	    override public function getMaximumValue():Number
		{
	        return getConstraint().getMaximumValue();
	    }

	    override public function getValue():Number
		{
	        return getConstraint().getValue();
	    }

	    override public function setValue(size:Number):void
		{
	        getConstraint().setValue(size);
	    }

	    override internal function isCyclic(l:SpringLayout):Boolean
		{
	        return l.isCyclic(getConstraint());
	    }

	    public function toString():String
		{
	        return "SpringProxy for " + edgeName + " edge of " + c.name + ".";
	    }
	 } 
}