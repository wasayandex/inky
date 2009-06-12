package inky.framework.styles 
{
	import inky.framework.collections.IList;
	import inky.framework.collections.ArrayList;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2009.06.11
	 *
	 */
	public class StyleSheetDeclaration
	{
		public var property:String;
		public var value:Object;
		
		
		/**
		 *	
		 */
		public function StyleSheetDeclaration(property:String = null, value:String = null)
		{
			this.property = property;
			this.value = value;
		}


	}
}