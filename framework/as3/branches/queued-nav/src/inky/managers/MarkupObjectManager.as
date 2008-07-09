package inky.managers
{
	import com.exanimo.collections.E4XHashMap;
	import com.exanimo.utils.URLUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	import inky.core.inky;
	import inky.core.inky_internal;
	import inky.core.IInkyDataParser;
	import inky.core.Section;
	import inky.data.SectionInfo;
	import inky.events.PropertyChangeEvent;
	import inky.events.PropertyChangeEventKind;
	import inky.net.ImageLoader;
	import inky.net.RuntimeLibraryLoader;
	import inky.net.SoundLoader;
	import inky.net.SWFLoader;
	import inky.net.XMLLoader;


	/**
	 *
	 * ..
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Matthew Tretter
	 * @since  2008.06.30
	 *
	 */
	public class MarkupObjectManager
	{
		private var _bindings:Dictionary;
		private static var _bindingTags:Object = {};
		private var _section:Section;
		private var _unresolvedBindings:Object;
		private static var _sections2MarkupObjectFactories:Dictionary = new Dictionary(true);
		private var _idMarkupObjects:Object;
		private var _data2MarkupObjects:E4XHashMap;
		private var _noIdMarkupObjects:Array;
		private var _markupObjects2Data:Dictionary;
		private var _initializedMarkupObjects:E4XHashMap;
		private var _initializedNonmarkupObjects:Dictionary;


		/**
		 *
		 *	
		 *	
		 */
		public function MarkupObjectManager(section:Section)
		{
			this._section = section;
			this._bindings = new Dictionary(true);
			this._unresolvedBindings = {};
			this._initializedNonmarkupObjects = new Dictionary(true);
			MarkupObjectManager._sections2MarkupObjectFactories[section] = this;
			this._idMarkupObjects = {};
			this._data2MarkupObjects = new E4XHashMap();
			this._noIdMarkupObjects = [];
			this._markupObjects2Data = new Dictionary();
			this._initializedMarkupObjects = new E4XHashMap(true);
		}




		//
		// public methods
		//


		/**
		 *
		 *	
		 *	
		 */
		public function createMarkupObject(xml:Object):Object
		{
// TODO: Add support for <null />, <inky:Boolean />, etc.
// TODO: If child exists but is not on first frame, a new instance will be created. That shouldn't happen!  Instead just initialize the child when it's added.
			xml = xml is XMLList && (xml.length() == 1) ? xml[0] : xml;
			var child:XML;
			var obj:Object = this._getMarkupObjectByData(this._section, xml);
			var tmp:XML;
			var xmlStr:String;
			var item:Object;

			if (!obj)
			{
				if (xml is XMLList)
				{
					// If the object is an XMLList, it is an implied Array value.
					obj = [];
					for each (child in xml)
					{
						item = this.createMarkupObject(child);
						this.setData(item);
						obj.push(item);
					}
					this.setData(obj, xml, false);
				}
				else if (xml is XML)
				{
					if (xml.nodeKind() == 'element')
					{
						// If the xml represents a stage instance, don't create
						// another!
// TODO: handle nested timeline markup objects..
						var name:String = xml.@name.toString() || xml.name.toString();
						if (this._section.hasOwnProperty(name))
						{
							return null;
						}

						// Get class name from "inky:class" attribute.					
						var className:String = xml.attributes().((namespace() == inky) && (localName() == 'class'));

						if (!className && (xml.namespace() == inky))
						{
							switch (xml.localName())
							{
								case 'Section':
									break;
								case 'Model':
									className = 'inky.data.Model';
									break;
								case 'Array':
									obj = [];
									for each (child in xml.*)
									{
// TODO: this is hacky. What if we want to allow capitalized properties??
										if (child.localName().toString().substr(0, 1).toLowerCase() != child.localName().toString().substr(0, 1))
										{
											item = this.createMarkupObject(child);
											this.setData(item);
											obj.push(item);
										}
									}
									break;
								case 'Asset':
								case 'ImageLoader':
								case 'RuntimeLibraryLoader':
								case 'SoundLoader':
								case 'SWFLoader':
								case 'XMLLoader':
									// Get the asset source.
									var base:String;
									var source:String = xml.@source;
									var loaderClass:Class;
// TODO: hack to get around the xml.@source being duplicated the second
// time an object goes through _createMarkupObject. (SEE NEXT TODO).
if (xml.@inky_internal::sourceAlreadyResolved != true)									
{
									tmp = xml as XML;
									while (tmp)
									{
										if ((base = tmp.attributes().((namespace() == inky) && (localName() == 'base'))))
										{
											source = URLUtil.getFullURL(base, source);
										}
										tmp = tmp.parent();
									}
}
									//
									// Determine which loader class to use.
									//

									// Use the class specified by the loaderClass attribute (deprecated).
									var loaderClassName:String = xml.@loaderClass;
									if (loaderClassName)
									{
										loaderClass = getDefinitionByName(loaderClassName) as Class;
										obj = new loaderClass();
									}

									// Use the class specified by the tag name.
									else
									{
										switch (xml.localName())
										{
											case 'ImageLoader':
												obj = new ImageLoader();
												break;
											case 'XMLLoader':
												obj = new XMLLoader();
												break;
											case 'RuntimeLibraryLoader':
												obj = new RuntimeLibraryLoader;
												break;
											case 'SoundLoader':
												obj = new SoundLoader();
												break;
											case 'SWFLoader':
												obj = new SWFLoader();
												break;
											default:

												// Infer the class from the extension of the file.
												var extension:String = source.split('.').pop().toString().split('?')[0].toLowerCase();
												switch (extension)
												{
													case 'swf':
														obj = new SWFLoader();
														break;
													case 'gif':
													case 'jpg':
													case 'jpeg':
													case 'png':
														obj = new ImageLoader();
														break;
													case 'xml':
													case 'php':
													default:
														throw new Error('Could not find an appropriate loader for extension ' + extension +'.');
														break;
												}
										}
									}
// TODO: hack to prevent the xml.@source from being duplicated the second
// time an object goes through _createMarkupObject. Since the @source gets
// stored as a fully resolved URL (using its parent nodes' paths), the @source 
// does not need to go through the process again.
if (xml.@inky_internal::sourceAlreadyResolved != true)									
{
									xml.@source = source;
}
									this.setData(obj, xml);

									break;
								case 'Binding':
// TODO: BINDING: this is already being done on source expression in _setBoundValue. Can we centralize it?
									// Create a list of bindings so that we
									// will be able to create the binding once
									// the destination object is created.
									var t:Array = xml.@destination.toString().split('.');
									var id:String = t.shift() as String;
									MarkupObjectManager._bindingTags[id] = MarkupObjectManager._bindingTags[id] || [];
									MarkupObjectManager._bindingTags[id].push({source: xml.@source.toString(), destination: t.join('.')});

									// If the destination already exists, bind it immediately.
									var destinationObj:Object = this._getMarkupObjectById(this._section, id);
									if (destinationObj)
									{
// TODO: BINDING: isn't this going to redo other bindings? We really only need to do this one!
										this._resolveBindings(this._section, destinationObj);
									}

									break;
								case 'Number':
									if (xml.hasSimpleContent())
									{
										obj = Number(xml.toString());
									}
									else
									{
										throw new Error('Number nodes may not contain child nodes.');
									}
									break;
								case 'Object':
									obj = {};
									break;
								case 'String':
									if (xml.hasSimpleContent())
									{
										obj = xml.toString();
									}
									else
									{
										throw new Error('String nodes may not contain child nodes.');
									}
									break;
								case 'XML':
// TODO: I'm sure there's a more efficient way to do this than reparsing the XML.. the catch is that we want it parsed exactly as typed (an island), not influenced by the inky XML.
									xmlStr = xml.toXMLString();
									xmlStr = xmlStr.substring(xmlStr.indexOf('<', xmlStr.indexOf('<') + 1), xmlStr.lastIndexOf('<', xmlStr.lastIndexOf('<')));
									var parsedValue:XMLList = new XMLList(xmlStr);
									obj = parsedValue.length() ? parsedValue.length() > 1 ? parsedValue : parsedValue[0] : null;
									this.setData(obj, xml, false);
									break;
								case 'XMLList':
// TODO: I'm sure there's a more efficient way to do this than reparsing the XML.. the catch is that we want it parsed exactly as typed (an island), not influenced by the inky XML.
									// Use the XMLList node if you have a single node
									// of XML but you want it to be parsed as a list.
									// If you have multiple nodes, the XML tag is fine
									// as it will automatically create a list.
									xmlStr = xml.toXMLString();
									xmlStr = xmlStr.substring(xmlStr.indexOf('<', xmlStr.indexOf('<') + 1), xmlStr.lastIndexOf('<', xmlStr.lastIndexOf('<')));
									obj = new XMLList(xmlStr);
									this.setData(obj, xml, false);
									break;
							}
						}
						else if (!className && (xml.name().uri.indexOf('*') != -1))
						{	
							// Get qualified class name using namespace. (Flex style shorthand)
							className = xml.name().uri.replace('*', xml.localName());
						}

						if (!obj && className)
						{
							var cls:Class;

							try
							{
								cls = getDefinitionByName(className) as Class;
							}
							catch (error:Error)
							{
trace('Warning: ' + error);
							}

// TODO: Shouldn't we catch if no classname is provided at all??
							if (cls)
							{
								obj = new cls();
							}
						}
					}
				}
				else
				{
					throw new ArgumentError('_createMarkupObject only accepts XML and XMLList objects');
				}

			}

			// Add DisplayObjects to the stage.
			if ((obj is DisplayObject) && !obj.parent)
			{
				// Set the section on the object. If this is a preload asset,
				// its section may not yet have been created.
				var containingNode:XML = xml.parent();
				while (containingNode && !((containingNode.namespace() == inky) && ((containingNode.localName() == 'Section') || (containingNode.localName() == 'Application'))))
				{
					containingNode = containingNode.parent();
				}
				if (containingNode)
				{
					var owner:Section = this._getMarkupObjectByData(this._section, containingNode) as Section;
					if (owner)
					{
						Section.setSection(obj, owner);	
					}
				}

				// Call setData before adding the DisplayObject to its
				// parent so that DisplayObjects are added in the correct
				// order. For example, given the structure
				// <A><B><C/></B></A>, C will be added to B, then B will be
				// added to A. If we did not call setData before adding the
				// DisplayObject to the display list, B would first be added
				// to A, then C would be added to B.
				this.setData(obj, xml);

				// Decide what parent the DisplayObject should be added to.
				var parent:DisplayObjectContainer = this._getMarkupObjectByData(this._section, xml.parent()) as DisplayObjectContainer;

				// Add the DisplayObject
				if (parent)
				{
					if (parent.hasOwnProperty('addComponent') && (typeof parent['addComponent'] == 'function'))
					{
						parent['addComponent'](obj as DisplayObject);
					}
					else
					{
						parent.addChild(obj as DisplayObject);
					}
				}
			}

			// Initialize the object.
			this.setData(obj, xml);

			return obj;
		}


		/**
		 * @private
		 *	
		 * 
		 * 
		 */
		public function destroy():void
		{
			// Although binding sources are stored with a weak reference, they
			// may not be immediately garbage collected. To insure that
			// instances "in limbo" do not trigger updates, remove their event
			// listeners.
			for (var source:Object in this._bindings)
			{
				if (source is IEventDispatcher)
				{
					source.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._propertyChangeHandler);
					source.removeEventListener(Event.CHANGE, this._propertyChangeHandler);
				}
				delete this._bindings[source];
			}

			this._initializedMarkupObjects.removeAll();
			this._data2MarkupObjects.removeAll();
			delete MarkupObjectManager._sections2MarkupObjectFactories[this._section];

			this._markupObjects2Data = undefined;
			this._initializedMarkupObjects = undefined;
			this._noIdMarkupObjects = undefined;
			this._data2MarkupObjects = undefined;
			this._initializedNonmarkupObjects = undefined;
			this._unresolvedBindings = undefined;
			this._section = undefined;
			this._idMarkupObjects = undefined;
			this._bindings = undefined;
		}


		/**
		 *
		 *	
		 *	
		 */
		public function parseData(obj:Object, data:XML):void
		{
			// Create the nested objects, but leave out the Section nodes.
			for each (var node:XML in data.*)
			{
				if (!data.inky::Section.contains(node))
				{
					this.createMarkupObject(node);
				}
			}

			// Set the properties.
			var i:uint;
			var list:XMLList = data.* + data.attributes();
			for (i = 0; i < list.length(); i++)
			{
				this._setXMLValue(this._section, obj, list[i].localName(), list[i]);
			}
		}


		/**
		 *
		 * @private
		 *
		 * @param obj
		 *     The object on which to set the data.
		 * @param data
		 *     The XML data to provide the specified object with.
		 * 
		 */
		public function setData(obj:Object, data:Object = null, parseData:Boolean = true):void
		{
			// Don't initialize the same obj twice.
			if (!obj || this._isInitializedComponent(obj)) return;

			// Get the objects data and mark it as initialized.
			data = data || this._getMarkupObjectData(this._section, obj);

			// If the object has no data, we're done!
			if (!data)
			{
				this._initializedNonmarkupObjects[obj] = true;
			}
			else
			{
				this._initializedMarkupObjects.putItemAt(true, obj);

				// Store id references to the object.
				var id:String = data.@inky::id.length() ? data.@inky::id : null;
				if (id)
				{
					this._idMarkupObjects[id] = this._idMarkupObjects[id] || obj;
				}
				else if (this._noIdMarkupObjects.indexOf(obj) == -1)
				{
					this._noIdMarkupObjects.push(obj);
				}

				this._data2MarkupObjects.putItemAt(obj, data);
				this._markupObjects2Data[obj] = this._markupObjects2Data[obj] || data;

				if (parseData)
				{
					if (obj is IInkyDataParser)
					{
						obj.parseData(data as XML);
					}
					else
					{
						this.parseData(obj, data as XML);
					}
				}

				// Resolved any unresolved bindings.
				this._resolveBindings(this._section, obj);
			}

// TODO: Should this be here? It's a little random.
// Initialize the navigation controller.
if (obj == this._section.master)
{
	this._section.navigationManager.initialize();
}
		}




		//
		// private methods
		//


		/**
		 *
		 * 
		 * 
		 */
		private static function _deserializeValue(value:String):Object 
		{
			var result:Object;

			if ((value.charAt(0) == '"') && (value.charAt(value.length - 1) == '"'))
			{
				result = value.substr(1, -2);
			}
			else if ((value.charAt(0) == "'") && (value.charAt(value.length - 1) == "'"))
			{
				result = value.substr(1, -2);
			}
			else if (!isNaN(Number(value)))
			{
				result = Number(value);
			}
			else
			{
				result = value;
			}

			return result;
		}


		/**
		 *
		 * 
		 * 
		 */
		private static function _getChildByPath(context:DisplayObject, path:String):DisplayObject
		{
			var child:DisplayObject;

			if (path)
			{
				var names:Array = path.split('.');
				var objectWasFound:Boolean = true;
				var tmp:DisplayObject = context;
				while (names.length)
				{
					try
					{
						tmp = tmp.hasOwnProperty(names[0]) && tmp[names[0]] ? tmp[names[0]] : (tmp as DisplayObjectContainer).getChildByName(names[0]);
					}
					catch (error:Error)
					{
						objectWasFound = false;
						break;
					}
					if (!tmp)
					{
						objectWasFound = false;
						break;
					}
					names.shift();
				}
				if (objectWasFound)
				{
					child = tmp;
				}
			}
			else
			{
				return context;
			}

			return child;
		}


		/**
		 *
		 *
		 * 
		 */
 		private function _getMarkupObjectByData(context:Object, data:Object):Object
		{
			var obj:Object;

			// Stage instances.
			if ((data is XML) && (data.@name.length() || data.name.length()))
			{
// TODO: This can be done better. (Without checking for Section or Application nodes or passing path as string)
				// If the display object is on the stage, find it.
				var tmp:XML = data as XML;
				var path:Array = [];
				while (tmp && (tmp.localName() != 'Section') && (tmp.localName() != 'Application'))
				{
					var name:String = String(tmp.@name) || String(tmp.name);
					path.unshift(name);
					tmp = tmp.parent();
				}
// TODO: What if it's not the display object? Just something else with the same name prop?
				if (path.length)
				{
					obj = MarkupObjectManager._getChildByPath(context as DisplayObject, path.join('.'));
				}
			}

			if (!obj)
			{
				// Dynamically created objects
				obj = MarkupObjectManager._sections2MarkupObjectFactories[context]._data2MarkupObjects.getItemByKey(data);
			}

			if (!obj && context.owner)
			{
				obj = this._getMarkupObjectByData(context.owner, data);
			}

			return obj;
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getMarkupObjectById(context:Object, id:String):Object
		{
			return this._getMarkupObjectByIdHelper(context.master, id);
		}


		/**
		 *
		 * Should not be called directly. Use _getMarkupObjectById().
		 * 
		 */
		private function _getMarkupObjectByIdHelper(context:Object, id:String):Object
		{
			return MarkupObjectManager._sections2MarkupObjectFactories[context]._idMarkupObjects[id] || (context.currentSubsection ? this._getMarkupObjectByIdHelper(context.currentSubsection, id) : null);
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getMarkupObjectData(context:Object, obj:Object):Object
		{
			// Get the data for this object.
			var objData:Object = MarkupObjectManager._sections2MarkupObjectFactories[context]._markupObjects2Data[obj];
MarkupObjectManager._sections2MarkupObjectFactories[context]._markupObjects2Data[obj] = undefined;

			if (!objData)
			{
				// Object was placed on the stage in the ide (i.e. not created dynamically)
				var owner:DisplayObject = Section.getSection(obj);
				var objectName:String = obj.name;
				var tmp:DisplayObject = obj.parent;
				var info:SectionInfo = context.getInfo();
				while (tmp && (tmp != owner))
				{
					objectName = tmp.name + '.' + objectName;
					tmp = tmp.parent;
				}
// TODO: Node shouldn't have to have entire path!! It could be inside of other nodes which have other parts of the path!!
				// Check nodes for name attribute. 
				objData = info.inky_internal::getData().*.(attribute('name') == objectName);

				// Check nodes for name child nodes.
				if (!objData.length())
				{
					objData = info.inky_internal::getData().*.(name == objectName);
				}
				objData = objData.length() ? objData[0] : null;
			}
			return objData;
		}


		/**
		 *
		 * 
		 * 
		 */
 		private function _getMarkupObjectId(context:Object, obj:Object):String
		{
			for (var id:String in MarkupObjectManager._sections2MarkupObjectFactories[context]._idMarkupObjects)
			{
				if (MarkupObjectManager._sections2MarkupObjectFactories[context]._idMarkupObjects[id] == obj)
				{
					return id;
				}
			}

			return context.owner ? this._getMarkupObjectId(context.owner, obj) : null;
		}


		/**
		 *
		 * Determines whether a markup object is initialized.
		 * 
		 */
		private function _isInitializedComponent(obj:Object):Boolean
		{
			return this._isInitializedComponentHelper(this._section.master, obj);
		}


		/**
		 *
		 * Do not call this method directly. Use _isInitializedComponent().
		 * 
		 */
		private function _isInitializedComponentHelper(context:Section, obj:Object):Boolean
		{
			return MarkupObjectManager._sections2MarkupObjectFactories[context]._initializedNonmarkupObjects[obj] || MarkupObjectManager._sections2MarkupObjectFactories[context]._initializedMarkupObjects.containsKey(obj) || (context.currentSubsection && this._isInitializedComponentHelper(context.currentSubsection, obj));
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _propertyChangeHandler(e:Event):void
		{
			var source:Object;
			var sourceProp:String;
			var update:Boolean;
			var newValue:Object;
			var updateAllBoundProperties:Boolean = false;
			var obj:Object;

			if (e is PropertyChangeEvent)
			{
				var evt:PropertyChangeEvent = e as PropertyChangeEvent;
				source = evt.source;
// TODO: Support qname (not just string) properties
				sourceProp = String(evt.property);
				update = evt.kind == PropertyChangeEventKind.UPDATE;
				newValue = evt.newValue;
			}
			else
			{
				source = e.currentTarget;
				update = true;

				// Special handling for CHANGE events.
				if (e.type == Event.CHANGE)
				{
					updateAllBoundProperties = true;
				}
				else
				{
					throw new Error('Unsupported binding!');
				}
			}

			// Update the bound values.
			if (update)
			{
				var properties2Update:Array;
				var prop:String;
				if (updateAllBoundProperties)
				{
					// Update all the bound properties on the source.
					for (sourceProp in this._bindings[source])
					{
						newValue = source[sourceProp];
						for (obj in this._bindings[source][sourceProp])
						{
							properties2Update = this._bindings[source][sourceProp][obj];
							for each (prop in properties2Update)
							{
// TODO: only set value if it's changed?
MarkupObjectManager._setValue(obj, prop, newValue);
							}
						}
					}
				}
				else
				{
					newValue = source[sourceProp];
					// Update only a specific bound property.
					for (obj in this._bindings[source][sourceProp])
					{
						properties2Update = this._bindings[source][sourceProp][obj];
						for each (prop in properties2Update)
						{
// TODO: only set value if it's changed?
MarkupObjectManager._setValue(obj, prop, newValue);
						}
					}
				}
			}
			else
			{
				throw new Error('Unsupported binding kind!');
			}
		}


		/**
		 *
		 * Resolves values that are bound to the given object.
		 * 
		 */
		private function _resolveBindings(context:Object, obj:Object, id:String = null):void
		{
			// Handle unresolved bindings.
			id = id || this._getMarkupObjectId(context, obj);

			if (id && this._unresolvedBindings[id])
			{
				for (var dest:Object in this._unresolvedBindings[id])
				{
					for each (var args:Array in this._unresolvedBindings[id][dest])
					{
						args = args.slice();
						args.unshift(dest);
						args.push(false);
args.unshift(context);
						this._setBoundValue.apply(null, args)
					}
				}
			}

			// Handle binding tags.
			if (id)
			{
// TODO: BINDING: Can we get rid of the binding tags list and use the same list for values bound with Binding tags and bracket notation??
				for each (var bindingTagData:Object in MarkupObjectManager._bindingTags[id])
				{
// TODO: BINDING: This is already being done for the source expression in _setBoundValue. Can we centralize it?
					// Get the property.
					var propertyChain:Array = bindingTagData.destination.split('.');
					var tmp:Object = obj;
					for (var i:uint = 0; i < propertyChain.length - 1; i++)
					{
						var prop:String = propertyChain[i];
						tmp = tmp[prop];
					}

					this._setBoundValue(context, tmp, propertyChain[propertyChain.length - 1], bindingTagData.source);
				}
			}

			if (context.owner)
			{
				this._resolveBindings(context.owner, obj, id);
			}
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _setBoundValue(context:Object, obj:Object, property:Object, expression:String, addToUnresolvedBindings:Boolean = true):Boolean
		{
// TODO: Support qname (not just string) properties
			var propName:String = String(property);

			//
			// Handle "special" expressions (true, false, null, etc.)
			//

			if (expression == 'true')
			{
				MarkupObjectManager._setValue(obj, property, true);
				return true;
			}
			else if (expression == 'false')
			{
				MarkupObjectManager._setValue(obj, property, false);
				return true;
			}
			else if (expression == 'null')
			{
				MarkupObjectManager._setValue(obj, property, null);
				return true;
			}
			else if (expression == 'undefined')
			{
				MarkupObjectManager._setValue(obj, property, undefined);
				return true;
			}

			//
			// Parse the expression
			//

			var argsStr:String;
			var target:Object;
			var segment:String;
			var segments:Array = expression.replace(/;$/, '').split('.');
			var source:Object;
			var sourceProp:String;
			var i:uint;
			var fnName:String;
			var id:String = segments[0];

			target = this._getMarkupObjectById(context, id);
			source = target;

			if ((target == null) || !this._isInitializedComponent(target))
			{
				// The object to which this binding points has not yet been initialized. At it to a list to be dealt with later.
				if (addToUnresolvedBindings)
				{
// TODO: BINDING: What do we even need _unresolvedBindings for any more? Why not just use _bindings if they're never removed from the list anyway? Are we in trouble if something doesn't get added to the list, and then you navigate to a different section and back?
					this._unresolvedBindings[id] = this._unresolvedBindings[id] || new Dictionary(true);
					this._unresolvedBindings[id][obj] = this._unresolvedBindings[id][obj] || [];
					this._unresolvedBindings[id][obj].push([propName, expression]);
				}
				return false;
			}
			else
			{
				for (i = 1; i < segments.length; i++)
				{
					segment = segments[i];
					var openParenIndex:int = segment.indexOf('(');

					if (openParenIndex > -1)
					{
						// Segment is method call.
						fnName = segment.substring(0, openParenIndex);
						argsStr = segment.substring(openParenIndex + 1, segment.indexOf(')'));
						var args:Array = [];

						if (!target[fnName])
						{
							throw new Error('Binding Error: Could not find "' + segments.slice(0, i + 1).join('.') + '"');
						}

						for each (var arg:String in argsStr.split(','))
						{
							args.push(MarkupObjectManager._deserializeValue(arg.replace(/^[\s]*/, '').replace(/[\s]*$/, '')));
						}

						target = target[fnName].apply(null, args);
					}
					else
					{
						if (!target.hasOwnProperty(segment))
						{
							throw new Error('Binding Error: Could not find "' + segments.slice(0, i + 1).join('.') + '"');
							break;
						}
						else if (i == segments.length - 1)
						{
							sourceProp = segment;
						}
						target = target[segment];
					}

					if (i != segments.length - 1)
					{
						source = target;
					}
				}

				MarkupObjectManager._setValue(obj, propName, target);

				if (sourceProp)
				{
					// Remember bound properties.
					this._bindings[source] = this._bindings[source] || {};
					this._bindings[source][sourceProp] = this._bindings[source][sourceProp] || new Dictionary(true);
					this._bindings[source][sourceProp][obj] = this._bindings[source][sourceProp][obj] || [];
					this._bindings[source][sourceProp][obj].push(propName);

					if (source is IEventDispatcher)
					{
						source.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._propertyChangeHandler, false, 0, true);
						source.addEventListener(Event.CHANGE, this._propertyChangeHandler, false, 0, true);
					}
				}
			}

			return true;
		}


		/**
		 *
		 * Tries to set an object's value.
		 * 
		 */
 		private static function _setValue(obj:Object, propName:*, value:Object):void
		{
// TODO: why is this necessary????? An error will be thrown if you do <inky:String>Hi</inky:String>, but it shouldn't be getting here.
			if (propName == null) return;
// TODO: this is hacky. What if we want to allow capitalized properties??

			var setValue:Boolean = false;
			var typeDescription:XML;
			if (propName.substr(0, 1).toLowerCase() == propName.substr(0, 1))
			{
				if (obj.hasOwnProperty(propName))
				{
					setValue = true;
				}
				else
				{
					typeDescription = describeType(obj);
					if (typeDescription.@isDynamic == 'true')
					{
						setValue = true;
					}
				}
			}

			// Automatically convert "false" (String) to false (Boolean) if the
			// accessor specifies a Boolean type. IMPORTANT: because the
			// accessor may be star-typed, it is better to use "{false}", which
			// will always be evaluated as a Boolean.
			if (value == 'false')
			{
				typeDescription = typeDescription || describeType(obj);
				if (typeDescription.accessor.(attribute('name') == propName).@type == 'Boolean')
				{
					value = false;
				}
			}

			if (setValue)
			{
				try
				{
					obj[propName] = value;
				}
				catch(error:Error)
				{
					// Don't try to set names on timeline placed DisplayObjects.
					if (!((error.errorID == 2078) && (obj is DisplayObject)  && (propName == 'name')))
					{
						throw(error);
					}
				}
			}
		}


		/**
		 *
		 * Interprets a value and tries to set it on an object.
		 * 	
		 */
 		private function _setXMLValue(context:Object, obj:Object, propName:String, value:Object):void
		{
			if (value.hasSimpleContent() && (value.length() == 1) /*&& value.nodeKind() == 'text'*/)
			{
				var str:String = value.toString();
				var trimmedStr:String = str.replace(/^[\s]*/, '').replace(/[\s]*$/, '');
				if ((trimmedStr.charAt(0) == '{') && (trimmedStr.charAt(trimmedStr.length - 1) == '}'))
				{
					// Value is bound to another value using {id} syntax
					this._setBoundValue(context, obj, propName, trimmedStr.substr(1, -2));
					return;
				}
				else
				{
					MarkupObjectManager._setValue(obj, propName, str);
					return;
				}
			}
			else
			{
// TODO: this is hacky. What if we want to allow capitalized properties??
				// Parse an XML representation of data (i.e. <Array></Array>,
				// <XML></XML>, <String></String>, etc). Initialize the object
				// immediately to make sure that property values aren't set to
				// empty Arrays, etc.
				if (propName.substr(0, 1) == propName.substr(0, 1).toLowerCase())
				{
					var markupObject:Object = this.createMarkupObject(value.*);
					this.setData(markupObject);
					MarkupObjectManager._setValue(obj, propName, markupObject);
				}
			}
		}	




	}
}
