package inky.framework.managers
{
	import com.exanimo.collections.E4XHashMap;
	import com.exanimo.utils.URLUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	import inky.framework.binding.Binding;
	import inky.framework.binding.BindingManager;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.binding.events.PropertyChangeEventKind;
	import inky.framework.controls.NavigationButton;
	import inky.framework.core.inky;
	import inky.framework.core.inky_internal;
	import inky.framework.core.event_listener;
	import inky.framework.core.IInkyDataParser;
	import inky.framework.core.Section;
	import inky.framework.data.Model;
	import inky.framework.core.SectionInfo;
	import inky.framework.net.ImageLoader;
	import inky.framework.net.RuntimeLibraryLoader;
	import inky.framework.net.SoundLoader;
	import inky.framework.net.SWFLoader;
	import inky.framework.net.XMLLoader;
	import inky.framework.actions.ActionGroup;
	import inky.framework.actions.ActionSequence;
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
		namespace local = '';

		// Force some classes to be compiled into the SWF.
		Model;
		ActionSequence;
		ActionGroup;
		NavigationButton;

		private var _bindingManager:BindingManager;
		private var _initializedMarkupObjects:Dictionary;
		private var _initializedNonmarkupObjects:Dictionary;
		private static var _idMarkupObjects:Object = new ObjectProxy();
		private var _markupObjects2Data:Dictionary;
		private static var _orphanAssets:Object = {};
		private var _sPath:String; // The stringified version of the sPath of the section to which this MarkupObjectManager belongs.
		private static var _sPaths2MOMs:Object = {};
		public static var masterMarkupObjectManager:MarkupObjectManager = getMarkupObjectManager('/');

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
		public function MarkupObjectManager(sPath:Object)
		{
			this._init(sPath);
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
		public function createMarkupObject(xml:Object, className:String = null):Object
		{
// TODO: Add support for <null />, <inky:Boolean />, etc.
// TODO: If child exists but is not on first frame, a new instance will be created. That shouldn't happen!  Instead just initialize the child when it's added.
			xml = xml is XMLList && (xml.length() == 1) ? xml[0] : xml;
			var child:XML;
			var obj:Object = this._getMarkupObjectByData(this._sPath, xml);
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
						var section:Section = Section.getSectionBySPath(this._sPath);
						var name:String = xml.@name.toString() || xml.name.toString();
						if (section && section.hasOwnProperty(name))
						{
							return null;
						}

						// Get class name from "inky:class" attribute.					
						className = className || xml.attributes().((namespace() == inky) && (localName() == 'class'));

						if (!className && (xml.namespace() == inky))
						{
							switch (xml.localName())
							{
								case 'StyleSheet':
									if (xml.hasSimpleContent())
									{
										var styleSheet:StyleSheet = new StyleSheet();
										styleSheet.parseCSS(xml.toString());
										obj = styleSheet;
									}
									else
									{
										throw new Error('StyleSheet nodes may not contain child nodes.');
									}
									break;
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
									className = 'inky.framework.actions.ActionGroup';
									break;
								case 'ActionSequence':
									className = 'inky.framework.actions.ActionSequence';
									break;
								case 'Section':
									break;
								case 'Model':
									className = 'inky.framework.data.Model';
									break;
								case 'NavigationButton':
									className = 'inky.framework.controls.NavigationButton';
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
								case 'AssetLoader':
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
												obj = new RuntimeLibraryLoader();
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
														obj = new XMLLoader();
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

if (!(this._getMarkupObjectByData(this._sPath, tmp) is Section))
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
				var parent:DisplayObjectContainer = this._getMarkupObjectByData(this._sPath, xml.parent()) as DisplayObjectContainer;

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
var orphans:Object = MarkupObjectManager._orphanAssets[this._sPath];
if (orphans)
{
	for each (var asset:Object in orphans.assets)
	{
		MarkupObjectManager._destroyMarkupObject(orphans.owner, asset);
	}
	delete MarkupObjectManager._orphanAssets[this._sPath];
}

			this._bindingManager.destroy();

			delete MarkupObjectManager._sPaths2MOMs[this._sPath];

			this._markupObjects2Data = undefined;
			this._initializedMarkupObjects = undefined;
			this._initializedNonmarkupObjects = undefined;
			this._sPath = null;

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
		 * 
		 * 
		 */
		public function getMarkupObjectId(obj:Object):String
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
		 *	
		 *	
		 */
		public static function getMarkupObjectManager(sPath:Object):MarkupObjectManager
		{
			var sPathStr:String = sPath.toString();
			var mom:MarkupObjectManager = _sPaths2MOMs[sPathStr];
			if (!mom)
			{
				_sPaths2MOMs[sPathStr] =
				mom = new MarkupObjectManager(sPathStr);
			}
			return mom;
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
			data = data || this._getMarkupObjectData(this._sPath, obj);

			// If the object has no data, we're done!
			if (!data)
			{
				this._initializedNonmarkupObjects[obj] = true;
			}
			else
			{
				this._initializedMarkupObjects[obj] = true;

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
//!
var section:Section = Section.getSectionBySPath(this._sPath);
if (section && (obj == section.master))
{
	section.inky_internal::getNavigationManager().initialize();
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
			var markupObject:Object;
			
			// event listener attributes i.e. on:click="blah"
			if (value.namespace() == event_listener)
			{
				if (obj is IEventDispatcher)
				{
					var eventType:String = value.localName();
					var fn:Function = this._bindingManager.parseExpression(value.toString(), obj);
					var listener:Function = function(e:*):void
					{
						fn()(e);
					}
					obj.addEventListener(eventType, listener);
				}
				else
				{
					throw new Error('Event listener markup found on non-IEventDispatcher ' + obj);
				}
			}
			
			// property setting attributes
			else if (value.namespace() == local)
			{
				if (value.hasSimpleContent())
				{
					if ((value.nodeKind() == 'element') && (value.children().length() == 0))
					{
						// Value is shorthand object (i.e. <someProp inky:class="Object" objProp="1" />)
						var typeDescription:XML = describeType(obj);
						var className:String = (typeDescription.accessor + typeDescription.variable).(attribute('name') == propName).@type;
// TODO: handle if type is an interface. (can't create an intance of it).
						markupObject = this.createMarkupObject(value, className || 'Object');
						this.setData(markupObject, value);
						MarkupObjectManager._setValue(obj, propName, markupObject);
					}
					else
					{
						var str:String = value.toString();
						var bindingMatch:Array = str.match(/^\s*{(.*)}\s*$/);
						if (bindingMatch != null)
						{
							// Value is bound to another value using {id} syntax
							var binding:Binding = this._bindingManager.parseBinding2(obj, propName, bindingMatch[1]);
							this._bindingManager.executeBinding(binding);
						}
						else
						{
							MarkupObjectManager._setValue(obj, propName, str);
						}
					}
				}
				else
				{
					// Parse an XML representation of data (i.e. <Array></Array>,
					// <XML></XML>, <String></String>, etc). Initialize the object
					// immediately to make sure that property values aren't set to
					// empty Arrays, etc.
					markupObject = this.createMarkupObject(value.*);
					this.setData(markupObject);
					MarkupObjectManager._setValue(obj, propName, markupObject);
				}
			}
			else
			{
// TODO: Should an error be thrown here?
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


private static function _destroyMarkupObject(context:Object, obj:Object):void
{
	var data:Object = context._markupObjects2Data[obj];
	delete context._markupObjects2Data[obj];
	delete context._initializedMarkupObjects[obj];
	Section.setSection(obj, null);
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
 		private function _getMarkupObjectByData(sPath:String, data:Object):Object
		{
			var obj:Object;
			var section:Section = Section.getSectionBySPath(sPath);

			// Stage instances.
			if (section && (data is XML) && (data.@name.length() || data.name.length()))
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
					obj = MarkupObjectManager._getChildByPath(section, path.join('.'));
				}
			}

			if (!obj)
			{
				// Dynamically created objects
				var dict:Dictionary = MarkupObjectManager._sPaths2MOMs[sPath]._markupObjects2Data;
				var o:Object;
				for (o in dict)
				{
					var xml:Object = dict[o];
					if (data === xml)
					{
						obj = o;
						break;
					}
				}
			}

			if (section && !obj && section.owner)
			{
				obj = this._getMarkupObjectByData(section.owner.sPath.toString(), data);
			}

			return obj;
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getMarkupObjectData(sPath:String, obj:Object):Object
		{
			// Get the data for this object.
			var context:Object = Section.getSectionBySPath(sPath);
			var objData:Object = MarkupObjectManager._sPaths2MOMs[sPath]._markupObjects2Data[obj];
MarkupObjectManager._sPaths2MOMs[sPath]._markupObjects2Data[obj] = undefined;

			if (!objData)
			{
				// Object was placed on the stage in the ide (i.e. not created dynamically)
				var owner:DisplayObject = Section.getSection(obj);
				var objectName:String = obj.name;
				var tmp:DisplayObject = obj.parent;
				var info:SectionInfo = context.info;
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
		 */
		private function _init(sPath:Object):void
		{
			this._markupObjectIds = [];
			this._sPath = sPath.toString();
			this._bindingManager = new BindingManager(_idMarkupObjects);
			this._initializedNonmarkupObjects = new Dictionary(true);
			_sPaths2MOMs[this._sPath] = this;
			this._markupObjects2Data = new Dictionary(true);
			this._initializedMarkupObjects = new Dictionary(true);
		}


		/**
		 *
		 * Determines whether a markup object is initialized.
		 * 
		 */
		private function _isInitializedComponent(obj:Object):Boolean
		{
			var isInitialized:Boolean = false;
			for each (var mom:MarkupObjectManager in MarkupObjectManager._sPaths2MOMs)
			{
				isInitialized = mom._initializedNonmarkupObjects[obj] || mom._initializedMarkupObjects[obj];
				if (isInitialized)
				{
					break;
				}
			}
			
			return isInitialized;
		}



// TODO: Get rid of orphan asset stuff. Since the objects are now mapped to SPaths (instead of Sections), you should be able to simply change the SPath the object is mapped to.
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
		 *
		 *	
		 */
		private function _setSection(obj:Object, xml:Object):void
		{
			// Determine the SPath of the object's section.
			var node:XML = xml.parent();
			var sectionNames:Array = [];
			while (node)
			{
				if (node.name() == new QName(inky, 'Section'))
				{
					sectionNames.unshift(node.@name.toString());
				}
				node = node.parent();
			}
			
			// Set the section of the object.
			var sPath:String = sectionNames.length ? '/' + sectionNames.join('/') : null;
			if (sPath)
			{
				Section.setSection(obj, sPath);
			}
		}


		/**
		 *
		 * Tries to set an object's value.
		 * 
		 */
 		private static function _setValue(obj:Object, propName:*, value:Object):void
		{
			var setValue:Boolean = obj.hasOwnProperty(propName);
			var typeDescription:XML;

			if (!setValue)
			{
				typeDescription = describeType(obj);
				setValue = typeDescription.@isDynamic == 'true';
			}

			if (setValue)
			{
				// Automatically convert "false" (String) to false (Boolean) if the
				// accessor specifies a Boolean type. IMPORTANT: because the
				// accessor may be star-typed, it is better to use "{false}", which
				// will always be evaluated as a Boolean.
				if (value == 'false')
				{
					typeDescription = typeDescription || describeType(obj);
					var propertyType:String = (typeDescription.accessor + typeDescription.variable).(attribute('name') == propName).@type;
					if (propertyType == 'Boolean')
					{
						value = false;
					}
				}

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
			else
			{
				throw new Error('Could not set property ' + propName + ' on ' + obj);
			}
		}




	}
}
