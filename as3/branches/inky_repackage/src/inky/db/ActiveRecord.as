package inky.db
{
	import flash.utils.getQualifiedClassName;
	import inky.db.*;
	import inky.utils.ObjectProxy;


	dynamic public class ActiveRecord extends ObjectProxy
	{
		private var _dataMapper:IDataMapper;
		private var _dirtyProperties:Object;
		private var _id:*;
		private var _recordType:String;
		private var _setProperties:Object;


		// Workaround. If you try to import flash_proxy and override a method,
		// you get the following error: 
		// 1004: Namespace was not found or is not a compile-time constant.
		namespace flash_proxy = "http://www.adobe.com/2006/actionscript/flash/proxy";


		/**
		 *
		 *	
		 */
		public function ActiveRecord(recordType:String = null, dataMapper:IDataMapper = null)
		{
			this._recordType = recordType || String(getQualifiedClassName(this).split("::").pop());
			this._clearPropertyMaps();
			this._dataMapper = dataMapper;
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get id():*
		{
			return this._id;
		}
		/**
		 * @private
		 */
		public function set id(value:*):void
		{
			this._id = value;
		}




		//
		// flash_proxy methods
		//


	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			if (this.hasOwnProperty(name))
				this._dirtyProperties[name] = true;
			return super.flash_proxy::deleteProperty(name);
		}


	    override flash_proxy function setProperty(name:*, value:*):void
	    {
			this.setProperty(name, value, true);
	    }




		//
		// public methods
		//
		

		/**
		 * @inheritDoc	
		 */
		public function clear():void
		{
			for (var prop:String in this._setProperties)
			{
				delete this[prop];
			}
			this._clearPropertyMaps();
		}
		

		/**
		 * @inheritDoc	
		 */
		public function getDataMapper():IDataMapper
		{
			return this._dataMapper;
		}


		/**
		 * @inheritDoc
		 */
		public function getDirtyProperties():Array
		{
			var dirtyProperties:Array = [];
			for (var p:String in this._dirtyProperties)
			{
				dirtyProperties.push(p);
			}
			return dirtyProperties;
		}


		/**
		 * @inheritDoc	
		 */
		public function getRecordType():String
		{
			return this._recordType;
		}


		/**
		 * @inheritDoc
		 */
		public function isDirty(property:String):Boolean
		{
			return !!this._dirtyProperties[property];
		}


		/**
		 * @inheritDoc	
		 */
		public function load(conditions:Object):Object//AsyncToken
		{
			var dataMapper:IDataMapper = this.getDataMapper();
			if (!dataMapper)
				throw new Error("ActiveRecord.dataMapper must be set before calling ActiveRecord.load()");
			if (!conditions)
				throw new ArgumentError();
				
			this.clear();
			return dataMapper.load(this, conditions);
		}


		/**
		 * @inheritDoc	
		 */
		public function remove(cascade:Boolean = true):Object//AsyncToken
		{
			var dataMapper:IDataMapper = this.getDataMapper();
			if (!dataMapper)
				throw new Error("ActiveRecord.dataMapper must be set before calling ActiveRecord.delete()");
			return dataMapper.remove(this, cascade);
		}


		/**
		 * @inheritDoc	
		 */
		public function save(cascade:Boolean = true):Object//AsyncToken
		{
			var dataMapper:IDataMapper = this.getDataMapper();
			if (!dataMapper)
				throw new Error("ActiveRecord.dataMapper must be set before calling ActiveRecord.save()");
			return dataMapper.save(this, cascade);
		}


		/**
		 * @inheritDoc	
		 */
		public function setProperty(name:*, value:*, markAsDirty:Boolean = true):void
		{
			this._setProperties[name] = true;

			if (markAsDirty && (this[name] != value))
				this._dirtyProperties[name] = true;

			super.flash_proxy::setProperty(name, value);
		}



		//
		// private methods
		//


		/**
		 *
		 */
		private function _clearPropertyMaps():void
		{
			this._dirtyProperties = {};
			this._setProperties = {};
		}



		
	}
}