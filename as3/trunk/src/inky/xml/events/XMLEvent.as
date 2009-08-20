package inky.xml.events
{
	import flash.events.Event;
	import inky.xml.xml_internal;
	import inky.xml.IXMLProxy;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.19
	 *
	 */
	public class XMLEvent extends Event
	{
		/**
		 *  The <code>XMLEvent.ADDED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>added</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event. For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType added
		 */
		public static const ADDED:String = "added";

		/**
		 *  The <code>XMLEvent.CHILD_REMOVED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>childRemoved</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event. For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType childRemoved
		 */
		public static const CHILD_REMOVED:String = "childRemoved";
		

		/**
		 *  The <code>XMLEvent.REMOVED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>removed</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event. For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType removed
		 */
		public static const REMOVED:String = "removed";

		private var _currentTarget:Object;
		private var _target:Object;
		private var _relatedNode:IXMLProxy;



		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 *  @param bubbles
		 *      Specifies whether the event can bubble up the display list hierarchy.
		 *  @param cancelable
		 *      Specifies whether the behavior associated with the event can be prevented.
		 *
		 */
		public function XMLEvent(type:String, relatedNode:IXMLProxy, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this._relatedNode = relatedNode;
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		override public function get currentTarget():Object
		{
			return this._currentTarget; 
		}


		/**
		 *	The node affected by the operation. In most cases, this is the same
		 *  as <code>target</code>, but not always. For example, for the
		 *  CHILD_REMOVED event, the target will be the parent, while the 
		 *  <code>relatedNode</code> property will contain a reference to the
		 *  removed child.
		 */
		public function get relatedNode():IXMLProxy
		{
			return this._relatedNode;
		}
		

		/**
		 * @inheritDoc
		 */
		override public function get target():Object
		{
			return this._target; 
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			var event:XMLEvent = new XMLEvent(this.type, this.relatedNode, this.bubbles, this.cancelable);
			event.xml_internal::setCurrentTarget(this.currentTarget);
			event.xml_internal::setTarget(this.target);
			return event;
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("XMLEvent", "type", "bubbles", "cancelable");
		}



		//
		// internal methods
		//
		

		/**
		 *	
		 */
		xml_internal function setCurrentTarget(value:Object):void
		{
			this._currentTarget = value;
		}

		
		/**
		 *	
		 */
		xml_internal function setTarget(value:Object):void
		{
			this._target = value;
		}




	}
}