package inky.orm.relationships 
{
	import inky.orm.relationships.IRelationship;
	
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
	public class RelationshipRegistry
	{
		private var storage:Object = {};
		
		/**
		 * 
		 */
		public function put(className:String, propertyName:String, relationship:IRelationship):void
		{
			if (!this.storage)
				this.storage = {};
			if (!this.storage[className])
				this.storage[className] = {};
			
			this.storage[className][propertyName] = relationship;
		}
		
		/**
		 * 
		 */
		public function get(className:String, propertyName:String):IRelationship
		{
			return (this.storage[className] && this.storage[className][propertyName]) as IRelationship;
		}

	}
	
}