package inky.orm.relationships 
{
	import inky.orm.relationships.IRelationship;
	import inky.orm.IDataMapper;
	import inky.orm.DATA_MAPPER_CONFIG;
	import inky.utils.getClass;

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
	public class OneToOne implements IRelationship
	{
		private var _className:String;
		private var _property:String;
		private var _options:Object;


		/**
		 * @inheritDoc
		 */
		public function evaluate(model:Object):*
		{
			var relatedClass:String = this._getRelatedClass();
			var key:String = this._getKey();
			var dataMapper:IDataMapper = DATA_MAPPER_CONFIG.getDataMapper(relatedClass);
			var relatedClassConstructor:Class = getClass(relatedClass);
			var relatedObject:Object = new relatedClassConstructor();
			var relatedKey:String = this._getRelatedKey();
			var query:Object = {};
			query[relatedKey] = model[key];
			dataMapper.load(relatedObject, query);
			return relatedObject;
		}


		/**
		 * @inheritDoc
		 */
		public function setup(className:String, property:String, options:Object):void
		{
			this._className = className;
			this._property = property;
			this._options = options;
		}


		private function _getKey():String
		{
			var key:String = this._options.key || this._property + "Id";
			return key;
		}
		
		private function _getRelatedKey():String
		{
// FIXME: This needs to look up the actual key.
return "id";
		}

		private function _getRelatedClass():String
		{
			var relatedClass:String = this._options.relatedClass;
			if (!relatedClass)
			{
				var parts:Array = this._className.split(".");
				parts.pop();
				parts.push(this._formatAsClass(this._property));
				relatedClass = parts.join(".");
			}
			return relatedClass;
		}


		/**
		 * 
		 */
		private function _formatAsClass(str:String):String
		{
			return str.substr(0, 1).toUpperCase() + str.substr(1);
		}




	}
	
}