package inky.components.stepper 
{
	import flash.display.InteractiveObject;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.30
	 *
	 */
	public interface IStepper
	{
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Indicates how the receiver responds to mouse events.
		 * 
		 * <p>If <code>true</code>, the stepper increments (or decrements) once per frame while the mouse is down.
		 * If <code>false</code>, the receiver does one increment (or decrement) on a mouse up.</p>
		 * 
		 * @default true
		 */
		function get autoRepeat():Boolean;
		function set autoRepeat(value:Boolean):void;

		/**
		 * Gets or sets a value that indicates whether the component can accept user interaction. 
		 * A value of <code>true</code> indicates that the component can accept user interaction; 
		 * a value of <code>false</code> indicates that it cannot.
		 * 
		 * <p>If you set the enabled property to <code>false</code>, the color of the container is 
		 * dimmed and user input is blocked (with the exception of the Label and ProgressBar components).</p>
		 * 
		 * @default true
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		
		/**
		 * Gets or sets the maximum value in the sequence of numeric values.
		 * 
		 * @default 10
		 */
		function get maximum():Number;
		function set maximum(value:Number):void;
		
		/**
		 * Gets or sets the minimum number in the sequence of numeric values.
		 * 
		 * @default 0
		 */
		function get minimum():Number;
		function set minimum(value:Number):void;
		
		/**
		 * Gets the next value in the sequence of values.
		 */
		function get nextValue():Number;

		/**
		 * Gets the previous value in the sequence of values.
		 */
		function get previousValue():Number;
		
		/**
		 * Gets or sets a nonzero number that describes the unit of change between values. 
		 * The <code>value</code> property is a multiple of this number less the minimum. 
		 * The NumericStepper component rounds the resulting value to the nearest step size.
		 * 
		 * @default 1
		 */
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		/**
		 * Gets or sets the current value of the NumericStepper component.
		 * 
		 * @default 1
		 */
		function get value():Number;
		function set value(value:Number):void;

	}
	
}