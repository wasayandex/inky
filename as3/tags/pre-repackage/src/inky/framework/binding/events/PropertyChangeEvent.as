package inky.framework.binding.events
{
	import flash.events.Event;
	import inky.framework.binding.events.PropertyChangeEventKind;


	/**
	 *
	 * Defines a PropertyChangeEvent. In order for a property to function as a
	 * binding source, it must dispatch PropertyChangeEvents. The framework
	 * will update the destination property whenever the source fires a
	 * PropertyChangeEvent.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2008.04.18
	 *
	 */
	public class PropertyChangeEvent extends Event
	{
	    public var kind:String;
	    public var newValue:Object;
		public var oldValue:Object;
		public var property:Object;
		public var source:Object;


		/**
		 *
		 * Defines the value of the <code>type</code> property for an <code>propertyChange</code> 
		 * event object.
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 * 	   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>	
		 *    <tr><td><code>currentTarget</code></td><td>The object that is actively processing the event object with an event listener.</td></tr>
	     *     <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 *  </table>
         *
         * @eventType propertyChange
         * 
		 */
		public static const PROPERTY_CHANGE:String = 'propertyChange';




		/**
		 *
		 * Creates a new PropertyChangeEvent object that contains information
		 * about a property change event. A PropertyChangeEvent object is
		 * passed as a parameter to an event listener.
		 * 
		 * @param type
		 *     The type of the event. Event listeners can access this
		 *     information through the type property of the event object. A
		 *     PropertyChangeEvent can have the following types of events:
		 *     PropertyChangeEvent.PROPERTY_CHANGE.
		 * @param bubbles
		 *     Determines whether the PropertyChangeEvent object participates in the
		 *     bubbling phase of the event flow. Event listeners can access this
		 *     information through the bubbles property of the event object.
		 * @param cancelable
		 *     Determines whether the PropertyChangeEvent object can be canceled.
		 *     Event listeners can access this information through the
		 *     cancelable property of the event object.
		 *
		 */
	    public function PropertyChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, kind:String = null, property:Object = null, oldValue:Object = null, newValue:Object = null, source:Object = null)
	    {
	        super(type, bubbles, cancelable);
	        this.kind = kind;
	        this.property = property;
	        this.oldValue = oldValue;
	        this.newValue = newValue;
	        this.source = source;
	    }




		//
		// public methods
		//


		/**
		 *
		 * Creates a copy of the PropertyChangeEvent object and sets the value of each
		 * parameter to match the original.
		 *
		 * @return
		 *     A new PropertyChangeEvent object with property values that match those of
		 *     the original.
		 * 
		 */
	    override public function clone():Event
	    {
	        return new PropertyChangeEvent(type, bubbles, cancelable, kind, property, oldValue, newValue, source);
	    }


		/**
		 *
		 * Creates an UPDATE event. This method provides a shortcut for
		 * creating new PROPERTY_CHANGE events.
		 *	
		 * @param source
		 *     The object to which the property belongs.
		 * @param property
		 *     The name of the property.
		 * @param oldValue
		 *     The value of the property before the new value is set.
		 * @param newValue
		 *     The value of the property after the new value is set.
		 * 
		 */
		public static function createUpdateEvent(source:Object, property:Object, oldValue:Object, newValue:Object):PropertyChangeEvent
		{
			return new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, PropertyChangeEventKind.UPDATE, property, oldValue, newValue, source);
		}


		/**
		 *
		 * Returns a string that contains all the properties of the PropertyChangeEvent
		 * object. The string is in the following format:
		 * 
		 * <code>[PropertyChangeEvent type=value bubbles=value cancelable=value]</code>
		 *
		 * @return
		 *     A string representation of the PropertyChangeEvent object.
		 * 
		 */
		public override function toString():String
		{
			return this.formatToString('PropertyChangeEvent', 'type', 'bubbles', 'cancelable', 'kind', 'property', 'oldValue', 'newValue', 'source');
		}




	}
}
