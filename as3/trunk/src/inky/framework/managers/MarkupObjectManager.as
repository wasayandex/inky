package inky.framework.managers
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
	import inky.framework.binding.Binding;
	import inky.framework.binding.BindingManager;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.binding.events.PropertyChangeEventKind;
	import inky.framework.core.inky;
	import inky.framework.core.inky_internal;
	import inky.framework.core.IInkyDataParser;
	import inky.framework.core.Section;
	import inky.framework.data.Model;
	import inky.framework.data.SectionInfo;
	import inky.framework.net.ImageLoader;
	import inky.framework.net.RuntimeLibraryLoader;
	import inky.framework.net.SoundLoader;
	import inky.framework.net.SWFLoader;
	import inky.framework.net.XMLLoader;
	import inky.framework.utils.ActionGroup;
	import inky.framework.utils.ActionSequence;
	import inky.framework.utils.Debugger;
	import inky.framework.utils.ObjectProxy;


	/**
	 *
	 * Unmarshalls objects represented by the Inky XML. This class should be considered an
	 * implementation detail and is subject to change.
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
		// Force some classes to be compiled into the SWF.
		Model;
		ActionSequence;
		ActionGroup;

		private var _bindingManager:BindingManager;
		private var _initializedMarkupObjects:E4XHashMap;
		private var _initializedNonmarkupObjects:Dictionary;
		private static var _idMarkupObjects:Object = new ObjectProxy();
		private var _section:Section;
		private static var _sections2MarkupObjectFactories:Dictionary = new Dictionary(true);
		private var _data2MarkupObjects:E4XHashMap;
		private var _noIdMarkupObjects:Array;
		private var _markupObjects2Data:Dictionary;
		private static var _orphanAssets:Object = {};

		
		/**
		 * A list of ids of markup objects that this section has created.
		 */
		private var _markupObjectIds:Array;




		//
		// constructor
		//


		/**
		 *
		 * Creates a new MarkupObjectManager. MarkupObjectManagers are
		 * automatically created by the framework.
		 *
		 * @param section
		 *     The section whose markup objects this manager is responsible for
		 *	
		 */
		public function MarkupObjectManager(section:Section)
		{
			this._markupObjectIds = [];
			this._section = section;
			this._bindingManager = new BindingManager(MarkupObjectManager._idMarkupObjects);
			this._initializedNonmarkupObjects = new Dictionary(true);
			MarkupObjectManager._sections2MarkupObjectFactories[section] = this;
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
		 * Creates a new object using the provided Inky XML.
		 *
		 * @param xml
		 *     The marshalled object.
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
								case 'TweenerAction':
									className = 'inky.framework.transitions.TweenerAction';
									break;
								case 'SetValueAction':
									className = 'inky.framework.transitions.SetValueAction';
									break;
								case 'AnimatorAction':
									className = 'inky.framework.transitions.AnimatorAction';
									break;
								case 'ActionGroup':
									className = 'inky.framework.utils.ActionGroup';
									break;
								case 'ActionSequence':
									className = 'inky.framework.utils.ActionSequence';
									break;
								case 'Section':
									break;
								case 'Model':
									className = 'inky.framework.data.Model';
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
	xml.@inky_internal::sourceAlreadyResolved = true;
}

// Determine if this section is the true owner of the asset.
tmp = xml.parent();
while (tmp && (tmp.localName() != 'Section') && (tmp.localName() != 'Application'))
{
	tmp = tmp.parent();
}
if (this._getMarkupObjectByData(this._section, tmp) != this._section)
{
	var sPath:String = "";
	while (tmp.parent())
	{
		while (tmp.localName() != 'Section')
		{
			tmp = tmp.parent();
		}
		sPath ='/' + tmp.@name + sPath;
		tmp = tmp.parent();
	}
//!
	MarkupObjectManager._setOrphanAsset(this, obj, sPath);
}
									this.setData(obj, xml);

									break;
								case 'Binding':
									// Create the binding.
									var binding:Binding = this._bindingManager.parseBinding(xml.@source, xml.@destination);
									this._bindingManager.executeBinding(binding);
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
Debugger.traceWarning(error);
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
				this._setSection(obj, xml as XML);

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
		 * 
		 * Destroys this MarkupObjectManager. This method is called
		 * automatically by the framework when the MarkupObjectManager is no
		 * longer needed.
		 * 
		 */
		public function destroy():void
		{
//!
var orphans:Object = MarkupObjectManager._orphanAssets[this._section.sPath.toString()];
if (orphans)
{
	for each (var asset:Object in orphans.assets)
	{
		MarkupObjectManager._destroyMarkupObject(orphans.owner, asset);
	}
	delete MarkupObjectManager._orphanAssets[this._section.sPath.toString()];
}

			this._bindingManager.destroy();

			this._initializedMarkupObjects.removeAll();
			this._data2MarkupObjects.removeAll();
			delete MarkupObjectManager._sections2MarkupObjectFactories[this._section];

			this._markupObjects2Data = undefined;
			this._initializedMarkupObjects = undefined;
			this._noIdMarkupObjects = undefined;
			this._data2MarkupObjects = undefined;
			this._initializedNonmarkupObjects = undefined;
			this._section = undefined;

			// Remove this section's markup objects from the markup object id map.
			for each (var id:String in this._markupObjectIds)
			{
				delete MarkupObjectManager._idMarkupObjects[id];
			}
			this._markupObjectIds = undefined;
		}


		/**
		 *
		 * 
		 * 
		 */
		public function getMarkupObjectById(id:String):Object
		{
			return MarkupObjectManager._idMarkupObjects[id];
		}


		/**
		 *
		 * Parses Inky XML for classes that don't implement IInkyDataParser. If
		 * an object is an IInkyDataParser, its <code>parseData()</code> method
		 * will be called instead. This method is exposed so that your custom
		 * data parsing can fall back to the default if need be.
		 *	
		 * @see inky.framework.core.IInkyDataParser
		 *	
		 * @param obj
		 *     The object to which the data pertains.
		 * @param data
		 *     The Inky XML
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
				this.setProperty(obj, list[i]);
			}
		}


		/**
		 *
		 * Performs some basic data setting on markup objects. Unlike the
		 * parseData method, setData performs tasks that must be performed on
		 * every markup object (for example, storing references to objects that
		 * have an inky:id).
		 *
		 * @see #parseData()
		 *
		 * @param obj
		 *     The object on which to set the data.
		 * @param data
		 *     The XML data to provide the specified object with.
		 * @param parseData
		 *     Specifies whether the parseData method should be called.
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

				// Set the section.
				if (!(obj is XMLList) && !(obj is XML))
				{
					this._setSection(obj, data);
				}

				// Store id references to the object.
				var id:String = data.@inky::id.length() ? data.@inky::id : null;
				if (id)
				{
					this._markupObjectIds.push(id);
					MarkupObjectManager._idMarkupObjects[id] = MarkupObjectManager._idMarkupObjects[id] || obj;
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
			}

			// Resolved any unresolved bindings.
			this._bindingManager.executeUnresolvedBindings();

// TODO: Should this be here? It's a little random.
// Initialize the navigation controller.
if (obj == this._section.master)
{
	this._section.inky_internal::getNavigationManager().initialize();
}
		}


		/**
		 *
		 * Sets an object's property using XML.
		 *	
		 * @param obj
		 *     The object whose property to set.
		 * @param value
		 *     XML specifying the property and its value. For example the
		 *     following value argument will result in the object's text
		 *     property being set to the string "Hello World".
		 * <listing>
		 *     <text>Hello World</text>
		 * </listing>
		 * 	
		 */
		public function setProperty(obj:Object, value:XML):void
		{
			var propName:String = value.localName();
			if (value.hasSimpleContent() && (value.length() == 1) /*&& value.nodeKind() == 'text'*/)
			{
				var str:String = value.toString();
				var trimmedStr:String = str.replace(/^[\s]*/, '').replace(/[\s]*$/, '');
				if ((trimmedStr.charAt(0) == '{') && (trimmedStr.charAt(trimmedStr.length - 1) == '}'))
				{
					// Value is bound to another value using {id} syntax
					var binding:Binding = this._bindingManager.parseBinding2(obj, propName, trimmedStr.substr(1, -2));
					this._bindingManager.executeBinding(binding);
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


//!
private static function _destroyMarkupObject(context:Object, obj:Object):void
{
	var data:Object = context._markupObjects2Data[obj];
	context._data2MarkupObjects.removeItemByKey(data);
	delete context._markupObjects2Data[obj];
	context._initializedMarkupObjects.removeItemByKey(obj);
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
				var info:SectionInfo = context.inky_internal::getInfo();
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
			for (var id:String in MarkupObjectManager._idMarkupObjects)
			{
				if (MarkupObjectManager._idMarkupObjects[id] == obj)
				{
					return id;
				}
			}
			
			return null;
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


//!
private static function _setOrphanAsset(context:Object, obj:Object, sPath:String):void
{
	var orphans = MarkupObjectManager._orphanAssets[sPath];
	if (!orphans)
	{
		orphans = MarkupObjectManager._orphanAssets[sPath] = {};
		orphans.owner = context;
		orphans.assets = [];
	} 
	MarkupObjectManager._orphanAssets[sPath].assets.push(obj);
}


		/**
		 *
		 * Sets the section on an object based on its inky data.
		 *	
		 */
		private function _setSection(obj:Object, xml:Object):void
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




	}
}
