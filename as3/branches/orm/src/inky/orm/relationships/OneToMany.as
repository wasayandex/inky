package inky.orm.relationships 
{
	import inky.orm.relationships.IRelationship;
	import inky.orm.reflection.fieldData.RelationshipData;
	
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
	public class OneToMany implements IRelationship
	{
		
		/**
		 * @inheritDoc
		 */
		public function evaluate(model:Object):*
		{
			return 2;
		}


		/**
		 * @inheritDoc
		 */
		public function setup(relationshipData:RelationshipData):void
		{
		}


	}
	
}