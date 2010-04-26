package inky.kml 
{
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Proxy;
	import inky.kml.Feature;
	import inky.kml.kml;
	import inky.utils.IEquatable;
	import flash.utils.describeType;
	import inky.collections.E4XHashMap;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.23
	 *
	 */
	public class KMLObject extends Proxy implements IEquatable
	{
		private var _xml:XML;
		private static var pkg:String;
		private var elementMap:Object;
		private var _propertyList:Array;
		private var _classPropertyList:Array;
		private static var __kmlObjectCache:E4XHashMap;
		
		use namespace kml;
		
		/**
		 *
		 */
		public function KMLObject(xml:XML)
		{
			this._xml = xml;
			
			if (!__kmlObjectCache)
				__kmlObjectCache = new E4XHashMap(true);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * TODO: doc
		 */
		public function get parent():Object
		{
			return this.getKMLObjectFor(this.xml.parent());
		}
		
		/**
		 * TODO: doc
		 */
		public function get xml():XML
		{
			return this._xml;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function toString():String
		{
			return "[Object " + this.getClassName() + "]";
		}
		
		/**
		 * @inheritDoc
		 */
		public function valueOf():Object
		{
			return this;
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		protected function callProperty(methodName:*, ...args):*
		{
			return this[methodName].apply(this, args);
		}
		
		/**
		 * @
		 */
		protected function getFeatureFor(xml:*):Feature
		{
			return this.getKMLObjectFor(xml) as Feature;
		}
		
		/**
		 * 
		 */
		protected function getProperty(propName:*):*
		{
			var value:*; 
			if (!this.elementMap || !this.elementMap[propName])
				value = this.getValueFor(propName);

			if (value)
				return value;
			
			throw new ReferenceError("Error #1069: Property " + propName + " not found on " + this.getClassName() + " and there is no default value.");
		}
		
		/**
		 * 
		 */
		protected function getKMLObjectFor(xml:*):Object
		{
			var obj:Object = __kmlObjectCache.getItemByKey(xml);
			
			if (!obj)
			{
				var featureType:String = xml.localName();
				if (featureType.match(/^[A-Z]/))
				{
					var objClass:Class = getDefinitionByName(this.getPackage() + featureType) as Class;
					obj = new objClass(xml);
					__kmlObjectCache.putItemAt(obj, xml);
				}
			}
			
			return obj;
		}
		
		/**
		 * 
		 */
		protected function getValueFor(propName:*):*
		{

			// Try to locate a mapped element value that matches the property name.
			var value:* = this.getMappedElementValue(propName);

			// Try to locate an attribute that matches the property name.
			if (!value)
				value = this.getAttributeValue(propName);
			
			// Try to locate a child node that matches the property name.
			if (!value)
			 value = this.getChildValue(propName);

			return value;
		}
		
		/**
		 * 
		 */
		protected function mapElement(element:String, site:Object):void
		{
			if ( !this.elementMap)
				this.elementMap = {};
				
			this.elementMap[element] = site;
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function getAttributeValue(propName:*):*
		{
			var attr:XMLList = this.xml.attribute(propName);
			if (attr.length() && attr[0].toString().length)
				return attr[0].toString();
			return null;
		}
		
		/**
		 * 
		 */
		private function getChildValue(propName:*):*
		{
			var node:XMLList = this.xml.child(new QName(kml, propName));
			if (node.length() && node[0].toString().length)
			{
				// If a node is found, attempt to create a KML object for the node.
				// If an object cannot be created, return the node value as a string.
				var obj:Object = this.getKMLObjectFor(node[0]);
				if (obj)
					return obj;
				else
					return node[0].toString();
			}
			return null;
		}
		
		/**
		 * 
		 */
		private function getClassName():String
		{
			return getQualifiedClassName(this).replace(/.*::(.*)$/, "$1");
		}
		
		/**
		 * 
		 */
		private function getMappedElementValue(propName:*):*
		{
			var value:*;

			if (this.elementMap)
			{
				for (var element:String in this.elementMap)
				{
					var site:String = this.elementMap[element];
					if (site == propName)
					{
						value = this.getValueFor(element);
						break;
					}
				}
			}
			
			return value;
		}
		
		/**
		 * 
		 */
		private function getPackage():String
		{
			if (!pkg)
				pkg = getQualifiedClassName(this).replace(/(.*::).*$/, "$1");
			
			return pkg;
		}
		
		/**
		 * 
		 */
		private function getPropertyList():Array
		{
			if (!this._propertyList)
			{
				// Start with a list of the class properties.
				this._propertyList = this.getClassPropertyList().slice();
				
				// Add the properties found in xml attributes and children.
				var elements:XMLList = this.xml.attributes() + this.xml.children();
				for each (var element:XML in elements)
				{
					var propName:String = element.localName();
					// Don't add the property if it is already in the list (defined in the class).
					if (this._propertyList.indexOf(propName) == -1)
					{
						if (this.elementMap && this.elementMap[propName])
							propName = this.elementMap[propName];

						this._propertyList.push(propName);
					}
				}
			}

			return this._propertyList;
		}
		
		/**
		 * 
		 */
		private function getClassPropertyList():Array
		{
			if (!this._classPropertyList)
			{
				this._classPropertyList = [];
				var typeDef:XML = describeType(this);
				for each (var accessor:XML in typeDef.accessor)
					this._classPropertyList.push(accessor.@name.toString());
			};
			
			return this._classPropertyList;
		}
		
		//---------------------------------------
		// IEQUATABLE IMPLEMENTATION
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function equals(object:Object):Boolean
		{
			if (object is KMLObject)
				return this.xml == object.xml;
			else
				return this == object;
		}
		
		//---------------------------------------
		// PROXY IMPLEMENTATION
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function callProperty(methodName:*, ...args):*
		{
			return this.callProperty(methodName, args);
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function getProperty(propName:*):*
		{
			return this.getProperty(propName);
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return this.getPropertyList().indexOf(name) != -1;
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function nextName(index:int):String 
		{
			return this.getPropertyList()[index - 1];
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function nextNameIndex(index:int):int 
		{
			if (index < this.getPropertyList().length)
				return index + 1;
			else
				return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function nextValue(index:int):*
		{
			return this.getValueFor(this.getPropertyList()[index - 1]);
		}
		
	}
	
}