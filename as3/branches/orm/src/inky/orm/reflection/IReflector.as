package inky.orm.reflection 
{
	import inky.orm.reflection.fieldData.RelationshipData;
	
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
	public interface IReflector
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