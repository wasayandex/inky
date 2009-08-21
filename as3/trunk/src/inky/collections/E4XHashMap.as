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
				if (this._xmlDict)
				{
					result = this._xmlDict[key] !== undefined;
				
					if (!result)
					{
						// If we didn't find the key, we have to loop through and
						// look, because Flash lies in some situations. See
						// http://exanimo.com/actionscript/xml-makes-a-bad-dictionary-key/
						for (k in this._xmlDict)
						{
							if (k === key)
							{
								result = true;
								break;
							}
						}
					}
				}
			}
			else if (key is XMLList)
			{
				result = this._xmlListDict && (this._xmlListDict[key] !== undefined);
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
                	if (v === value)
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
			var result:* = undefined;
			var k:*;
			if (key is XML)
			{
				if (this._xmlDict)
				{
					result = this._xmlDict[key];
					if (result === undefined)
					{
						for (k in this._xmlDict)
						{
							if (k === key)
							{
								result = this._xmlDict[k];
								break;
							}
						}
					}
				}
			}
			else if (key is XMLList)
			{
				result = this._xmlListDict ? this._xmlListDict[key] : undefined;
			}
			else
			{
				result = this._dict ? this._dict[key] : undefined;
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
					if (dict[key] !== undefined)
					{
                		isEmpty = false;
						break;
					}
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
					this._xmlDict[key] = value;
				}
				else
				{
					// If there is a value under this key, we can safely replace it.
					if (this._xmlDict[key] !== undefined)
					{
						this._xmlDict[key] = value;
					}
					else
					{
						// ...but even if there isn't, we still need to make sure we're not being tricked by Flash's false XML comparison.
						var k:*;
						var found:Boolean = false;
						for (k in this._xmlDict)
						{
							if (k === key)
							{
								this._xmlDict[k] = value;
								found = true;
								break;
							}
						}

						// Once we're positive the key isn't already in the map, add it.
						if (!found)
							this._xmlDict[key] = value;
					}
				}
			}
			else if (key is XMLList)
			{
				if (!this._xmlListDict)
					this._xmlListDict = new Dictionary(this._useWeakReferences);
				
				this._xmlListDict[key] = value;
			}
			else
			{
				if (!this._dict)
					this._dict = new Dictionary(this._useWeakReferences);

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
			this._xmlListDict = new Dictionary(this._useWeakReferences);
			this._xmlDict = new Dictionary(this._useWeakReferences);
			this._dict = new Dictionary(this._useWeakReferences);
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
					if (this._xmlDict[key] !== undefined)
					{
						delete this._xmlDict[key];
					}
					else
					{
						for (var k:* in this._xmlDict)
						{
							if (k === key)
							{
								delete this._xmlDict[k];
								break;
							}
						}
					}
				}
			}
			else if (key is XMLList)
			{
				// Can't use delete operator. (It gives "TypeError: Error #1119: Delete operator is not supported with operand of type XMLList.")
				if (this._xmlListDict)
					this._xmlListDict[key] = undefined;
			}
			else
			{
				if (this._dict)
					delete this._dict[key];
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
			for each (dict in [this._dict, this._xmlDict, this._xmlListDict])
			{
            	for (key in dict)
            	{
					if (dict[key] !== undefined)
                		keys.push(key);
            	}
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
					if (dict[key] !== undefined)
                		values.push(dict[key]);
            	}
			}
            return values;
        }




    }
}
