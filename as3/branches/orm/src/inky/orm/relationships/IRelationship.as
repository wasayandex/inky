package inky.orm.relationships 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.10.08
	 *
	 */
	public interface IRelationship
	{
		/**
		 * Gets the associated value for the specified model.
		 */
		function evaluate(model:Object):*;
		
		
		/**
		 * 
		 */
		function setup(className:String, property:String, options:Object):void;
		
	}
	
}
