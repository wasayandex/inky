package inky.components.slider.events
{
	import flash.events.Event;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.03.17
	 *
	 */
	public class SliderEvent extends Event
	{
		
		/**
		 *  The <code>SliderEvent.CHANGE</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>change</code> event.
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
		 *  @eventType change
		 */
		public static const CHANGE:String = "change";
	
		/**
		 *  The <code>SliderEvent.THUMB_DRAG</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>thumbDrag</code> event.
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
		 *  @eventType thumbDrag
		 */
		public static const THUMB_DRAG:String = "thumbDrag";
	
		
		/**
		 *  The <code>SliderEvent.THUMB_PRESS</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>thumbPress</code> event.
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
		 *  @eventType thumbPress
		 */
		public static const THUMB_PRESS:String = "thumbPress";
		
		
		
		
		/**
		 *  The <code>SliderEvent.THUMB_RELEASE</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>thumbRelease</code> event.
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
		 *  @eventType thumbRelease
		 */
		public static const THUMB_RELEASE:String = "thumbRelease";
		
		public var value:Number;
		public var clickTarget:String;
		public var triggerEvent:String;
		public var keyCode:int;
	
		/**
		 *  Creates a new SliderEvent object with the specified parameters.
		 * 
		 *  @param type String
		 * 		The event type; this value identifies the action that triggered the event.
		 *  @param value Number
		 * 		The new value of the slider.
		 *  @param clickTarget String
		 * 		Indicates whether a slider thumb or the slider track was pressed. A value of SliderEventClickTarget.THUMB indicates that the slider thumb was pressed; a value of SliderEventClickTarget.TRACK indicates that the slider track was pressed.
		 *  @param triggerEvent String
		 * 		A String that indicates the source of the input. A value of InteractionInputType.MOUSE indicates that the mouse was the source of input; a value of InteractionInputType.KEYBOARD indicates that the keyboard was the source of input.
		 *  @param keyCode int
		 *  @default 0
		 * 		If the event was triggered by a key press, this value is the key code that identifies that key.
		 * 
		 */
		public function SliderEvent(type:String, value:Number, clickTarget:String, triggerEvent:String, keyCode:int = 0)
		{
			super(type, false, false);		
			this.value = value;
			this.clickTarget = clickTarget;
			this.triggerEvent = triggerEvent;
			this.keyCode = keyCode;
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new SliderEvent(this.type, this.value, this.clickTarget, this.triggerEvent, this.keyCode);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("SliderEvent", "type", "value", "clickTarget", "triggerEvent", "keyCode");
		}




	}
}

