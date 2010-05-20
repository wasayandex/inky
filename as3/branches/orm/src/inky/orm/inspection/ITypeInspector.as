package inky.orm.inspection 
{
	import inky.orm.inspection.RelationshipData;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.05.19
	 *
	 */
	public interface ITypeInspector
	{
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * 
		 */
		function get propertyList():Array;
		
		/**
		 * 
		 */
		function getRelationshipData(property:String):RelationshipData;
		
		/**
		 * 
		 */
		function hasProperty(name:*):Boolean;

		
	}
	
}