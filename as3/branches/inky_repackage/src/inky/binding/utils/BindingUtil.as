package inky.binding.utils
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import inky.binding.events.PropertyChangeEvent;
	import inky.binding.utils.ChangeWatcher;
	import flash.display.DisplayObject;


	/**
	 *  The BindingUtil class defines utility methods
	 *  for performing data binding from ActionScript.
	 *  You can use the methods defined in this class to configure data bindings.
	 *	Based on Flex's BindingUtil class
	 */
	public class BindingUtil
	{
		private static var _propertyBindingEvents:Object = {};

		// Set the default binding events for flash classes.
		BindingUtil.setPropertyBindingEvents("fl.controls.CheckBox", "selected", [Event.CHANGE]);
		BindingUtil.setPropertyBindingEvents("fl.controls.ComboBox", "text", [Event.CHANGE]);
		BindingUtil.setPropertyBindingEvents("fl.controls.ComboBox", "value", [Event.CHANGE]);
		BindingUtil.setPropertyBindingEvents(TextField, "text", [Event.CHANGE]);
		BindingUtil.setPropertyBindingEvents(DisplayObject, "stage", [Event.ADDED_TO_STAGE]); // Since removedFromStage is fired before the property changes, there's no way to tell when the stage property is null.




	    /**
	     *  Binds a public property, <code>prop</code> on the <code>site</code>
	     *  Object, to a bindable property or property chain. 
	     *  If a ChangeWatcher instance is successfully created, <code>prop</code>
	     *  is initialized to the current value of <code>chain</code>.
	     * 
	     *  @param site The Object defining the property to be bound
	     *  to <code>chain</code>.
	     * 
	     *  @param prop The name of the public property defined in the
	     *  <code>site</code> Object to be bound. 
	     *  The property will receive the current value of <code>chain</code>, 
	     *  when the value of <code>chain</code> changes. 
	     *
	     *  @param host The object that hosts the property or property chain
	     *  to be watched. 
	     *
	     *  @param chain A value specifying the property or chain to be watched.
	     *  Legal values are:
	     *  <ul>
	     *    <li>String containing the name of a public bindable property
	     *    of the host object.</li>
	     * 
	     *    <li>An Object in the form: 
	     *    <code>{ name: <i>property name</i>, getter: function(host) { return host[<i>property name</i>] } }</code>. 
	     *    This Object must contain the name of, and a getter function for, 
	     *    a public bindable property of the host object.</li>
	     * 
	     *    <li>A non-empty Array containing a combination of the first two
	     *    options that represents a chain of bindable properties accessible
	     *    from the host. 
	     *    For example, to bind the property <code>host.a.b.c</code>, 
	     *    call the method as:
	     *    <code>bindProperty(host, ["a","b","c"], ...)</code>.</li>
	     *  </ul>
	     *
	     *  <p>Note: The property or properties named in the <code>chain</code> argument
	     *  must be public, because the <code>describeType()</code> method suppresses all information
	     *  about non-public properties, including the bindability metadata
	     *  that ChangeWatcher scans to find the change events that are exposed
	     *  for a given property.
	     *  However, the getter function supplied when using the <code>{ name, getter }</code>
	     *  argument form described above can be used to associate an arbitrary
	     *  computed value with the named (public) property.</p>
	     *
	     */
	    public static function bindProperty(site:Object, prop:String, host:Object, chain:Object):IChangeWatcher
	    {
	        var watcher:ChangeWatcher = ChangeWatcher.watch(host, chain, null);

	        if (watcher != null)
	        {
	            var assign:Function = function(e:Event):void
	            {
					// TODO: Does a try..catch here slow things down?
					try
					{
						site[prop] = watcher.getValue();
					}
					catch (error:Error)
					{
						// TypeError: Error #2007: Parameter text must be non-null.
						if (error.errorID == 2007)
						{
							site[prop] = "";
						}
						else
						{
							throw(error);
						}
					}
	            };
	            watcher.setHandler(assign);
	            assign(null);
	        }
	
			return watcher;
	    }


	    /**
	     *  Binds a setter function, <code>setter</code>, to a bindable property 
	     *  or property chain.
	     *  If a ChangeWatcher instance is successfully created, 
	     *  the setter function is invoked with current value of <code>chain</code>.
	     *
	     *  @param setter Setter method to invoke with an argument of the current
	     *  value of <code>chain</code> when that value changes.
	     *
	     *  @param host The host of the property. 
	     *  See the <code>bindProperty()</code> method for more information.
	     *
	     *  @param name The name of the property, or property chain. 
	     *  See the <code>bindProperty()</code> method for more information.
	     *
	     */
	    public static function bindSetter(setter:Function, host:Object, chain:Object):IChangeWatcher
	    {
	        var watcher:ChangeWatcher = ChangeWatcher.watch(host, chain, null);
        
	        if (watcher != null)
	        {
	            var invoke:Function = function(e:Event):void
	            {
	                setter(watcher.getValue());
	            };
	            watcher.setHandler(invoke);
	            invoke(null);
	        }
	
			return watcher;
	    }


		/**
		 *
		 * Allows you to evalutate a binding chain immediately without adding listeners or creating ChangeWatchers.
		 *	
		 */
		public static function evaluateBindingChain(host:Object, chain:Object):Object
		{
			if (host == null)
			{
				throw new ArgumentError("Invalid host.");
			}
			else if (!chain)
			{
				throw new ArgumentError("Invalid property chain.");
			}
			else if (!(chain is Array))
			{
				chain = [chain];
			}
	
			var value:Object = host;
			for each (var obj:Object in chain)
			{
				if (value == null)
				{
					break;
				}
				else if (obj is String)
				{
					value = value[obj];
				}
				else if (obj.hasOwnProperty("getter") && (obj["getter"] is Function))
				{
// FIXME: All this class -> string -> class stuff has gotta be slow.
					var getter:Function = obj["getter"] as Function;
					value = getter(value);
				}
				else
				{
					throw new ArgumentError("Can't evaluate binding chain.");
				}
			}
	
			return value;
		}


		/**
		 *
		 * Gets a list of binding events that will be listened for given a host
		 * of the specified class for the specified property.
		 * 
		 * @param cls
		 *     The class to get the binding events for.
		 * @param property
		 *     The property to get the binding events for.		 		 		 		 		 		 		 
		 *		 		 
		 */	
		public static function getPropertyBindingEvents(cls:Object, property:String):Array
		{
			var p2e:Object = BindingUtil._getProperty2EventsMap(cls);
			var events:Array;
			if (p2e.hasOwnProperty(property))
			{
				events = p2e[property];
			}
			else
			{
				var className:String = cls is String ? cls as String : getQualifiedClassName(cls).replace(/::/, ".");
				if (className == "Object")
				{
					events = [PropertyChangeEvent.PROPERTY_CHANGE];
					BindingUtil.setPropertyBindingEvents(cls, property, events);	
				}
				else
				{
					cls = cls is Class ? cls : getDefinitionByName(className);
					var superClass:String = String(describeType(cls).factory.extendsClass[0].@type).replace(/::/, ".");
					return BindingUtil.getPropertyBindingEvents(superClass, property);
				}
			}
			return events;
		}


		/**
		 *
		 * Sets the binding events that will be listened for by for a host of
		 * the specified class for the specified property.
		 * 
		 * @param cls
		 *     The class to set the binding events for.
		 * @param property
		 *     The property to set the binding events for.
		 * @param events
		 *     An array of event types to listen for.		 		 
		 *		 		 
		 */	
		public static function setPropertyBindingEvents(cls:Object, property:String, events:Array):void
		{
			var p2e:Object = _getProperty2EventsMap(cls);
			p2e[property] = events;
		}




		//
		// private methods
		//


		/**
		 *
		 */		 		
		private static function _getProperty2EventsMap(cls:Object):Object
		{
			var className:String;
			if (cls is Class)
			{
				className = getQualifiedClassName(cls).replace(/::/, ".");
			}
			else if (cls is String)
			{
				className = cls as String;
			}
			else
			{
				throw new ArgumentError();
			}
		
			var p2e:Object = _propertyBindingEvents[className];
			if (p2e == null)
			{
				p2e =
				_propertyBindingEvents[className] = {};
			}
			
			return p2e;
		}




	}
}