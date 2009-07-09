package inky.collections
{
	import inky.collections.ICollection;
	import inky.collections.IMap;
    import flash.utils.Dictionary;
	import inky.collections.ArrayList;


	/**
	 *
	 * A HashMap implementation that isn't broken by XML keys.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.06.20
	 *
	 */
    public class E4XHashMap implements IMap
    {
        private var _dict:Dictionary;
		private var _useWeakReferences:Boolean;
		private var _xmlDict:Dictionary;
		private var _xmlListDict:Dictionary;


		/**
		 *
		 *	
		 */
        public function E4XHashMap(useWeakReferences:Boolean = false)
        {
			this._useWeakReferences = useWeakReferences;
        }




		//
		// accessors
		//


        /**
         * 
         */
        public function get length():uint
        {
            var length:uint = 0;

			var dictionaries:Array = [this._dict, this._xmlDict, this._xmlListDict];
			for each (var dict:Dictionary in dictionaries)
			{
            	for (var key:* in dict)
            	{
                	length++;
            	}
			}

            return length;
        }




		//
		// public methods
		//


        /**
         * @inheritDoc
         */
        public function containsKey(key:Object):Boolean
        {
			var result:Boolean = false;
			var dict:Dictionary;
			var k:Object;
			
			if (key is XML)
			{
				for (k in this._xmlDict)
				{
					if (k == key)
					{
						result = true;
						break;
					}
				}
			}
			else if (key is XMLList)
			{
				for (k in this._xmlListDict)
				{
					if (k.value == key)
					{
						result = true;
						break;
					}
				}
			}
			else
			{
				result = this._dict && (this._dict[key] !== undefined);
			}
			
			return result;
        }


       /**
        * @inheritDoc
        */
        public function containsItem(value:Object):Boolean
        {
			var dict:Dictionary;
			var dictionaries:Array = [this._xmlListDict, this._xmlDict, this._dict];
			var found:Boolean = false;

			while (!found && dictionaries.length)
			{
				dict = dictionaries.pop();
				for each (var v:* in dict)
            	{
                	if (v == value)
                	{
						found = true;
                    	break;
                	}
            	}
			}

			return found;
        }


		/**
		 * @inheritDoc
		 */
		public function equals(o:Object):Boolean
		{
throw new Error('Not yet implemented!');
		}


        /**
         * @inheritDoc
         */
        public function getItemByKey(key:Object):Object
        {
			var result:*;
			if (key is XML)
			{
				result = this._xmlDict ? this._xmlDict[key] || this._xmlDict[this._getXMLKey(key)] : null;
			}
			else if (key is XMLList)
			{
				result = this._xmlListDict ? this._xmlListDict[this._getXMLKey(key)] : null;
			}
			else
			{
				result = this._dict ? this._dict[key] : null;
			}
				
            return result;
        }


        /**
         * @inheritDoc
         */
        public function getKeys():ICollection
		{
			return new ArrayList(this._getKeys());
		}


        /**
         * @inheritDoc
         */
        public function getValues():ICollection
		{
			return new ArrayList(this._getValues());
		}


        /**
         * @inheritDoc
         */
        public function isEmpty():Boolean
        {
			var isEmpty:Boolean = true;
			var dictionaries:Array = [this._dict, this._xmlDict, this._xmlListDict];
			var dict:Dictionary;
			
			while (isEmpty && dictionaries.length)
			{
				dict = dictionaries.pop();
            	for (var key:* in dict)
            	{
                	isEmpty = false;
					break;
            	}
			}

            return isEmpty;
        }


 		/**
 		 * @inheritDoc
 		 */
        public function putItemAt(value:Object, key:Object):Object
        {
			if (key is XML)
			{
				if (!this._xmlDict)
				{
					this._xmlDict = new Dictionary(this._useWeakReferences);
				}
				else
				{
					key = this._getXMLKey(key);
				}

				this._xmlDict[key] = value;
			}
			else if (key is XMLList)
			{
				if (!this._xmlListDict)
				{
					this._xmlListDict = new Dictionary(this._useWeakReferences);
				}
				
				key = this._getXMLKey(key);
				this._xmlListDict[key] = value;
			}
			else
			{
				if (!this._dict)
				{
					this._dict = new Dictionary(this._useWeakReferences);
				}

				this._dict[key] = value;
			}
// TODO: Return the replaced object.
			return null;
        }


        /**
         * 
         */        
        public function putItems(t:IMap):void
        {
throw new Error('Not yet implemented');
        }


        /**
         * @inheritDoc
         */
        public function removeAll():void
        {
            for each (var key:* in this._getKeys())
            {
				this.removeItemByKey(key);
            }
        }


        /**
         * 
         */
        public function removeItemByKey(key:Object):Object
        {
			if (key is XML)
			{
				if (this._xmlDict)
				{
					delete this._xmlDict[this._getXMLKey(key)];
				}
			}
			else if (key is XMLList)
			{
				if (this._xmlListDict)
				{
					delete this._xmlListDict[this._getXMLKey(key)];
				}
			}
			else
			{
				if (this._dict)
				{
					delete this._dict[key];
				}
			}
// TODO: Return removed item
			return null;
        }




		//
		// private methods
		//


        /**
         * 
         */
        private function _getKeys():Array
        {
			var key:*;
            var keys:Array = [];
			var dict:Dictionary;
			for each (dict in [this._dict, this._xmlDict])
			{
            	for (key in dict)
            	{
                	keys.push(key);
            	}
			}
			for (key in this._xmlListDict)
			{
				keys.push(key.value);
			}
            return keys;
        }


        /**
         * 
         */
        private function _getValues():Array
        {
            var values:Array = [];

			var dictionaries:Array = [this._dict, this._xmlDict, this._xmlListDict];
			for each (var dict:Dictionary in dictionaries)
			{
            	for (var key:* in dict)
            	{
                	values.push(dict[key]);
            	}
			}

            return values;
        }


		/**
		 *
		 *	XMLLists must be handled specially (wrapped in an object) because trying to delete something with an XMLList key from a dictionary causes an error.
		 *	
		 */
		private function _getXMLKey(obj:Object):Object
		{
			var key:Object;
			var k:Object;

			if ((obj is XML) && this._xmlDict)
			{
				for (k in this._xmlDict)
				{
					if (obj == k)
					{
						key = k;
						break;
					}
				}
			}
			else if ((obj is XMLList) && this._xmlListDict)
			{
				for (k in this._xmlListDict)
				{
					if (obj == k.value)
					{
						key = k;
						break;
					}
				}
				key = key || {value: obj};
			}

			return key || obj;
		}




    }
}
