package inky.framework.binding 
{


	/**
	 *
	 * An object that stores information about a single instance of
	 * databinding. This class should be considered an implementation detail
	 * and subject to change.
	 * 
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @author Eric Eldredge
	 * @since  2008.08.13
	 *
	 */
	public class Binding
	{
		public var destObjFunc:Function;
		public var destProp:String;
		public var srcObjFunc:Function;
		public var srcProp:String;

		
		/**
		 *
		 *	
		 */
	    public function Binding(srcObjFunc:Function, srcProp:String, destObjFunc:Function, destProp:String)
	    {
			this.destObjFunc = destObjFunc;
			this.destProp = destProp;
			this.srcObjFunc = srcObjFunc;
			this.srcProp = srcProp;
		}




	}
}
