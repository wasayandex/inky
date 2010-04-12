package inky.components.slider 
{
	import inky.utils.IDisplayObject;
	
	/**
	 *
	 *  The Slider component lets users select a value by moving a slider thumb
	 *  between the end points of the slider track. The current value of the
	 *  Slider component is determined by the relative location of the thumb 
	 *  between the end points of the slider, corresponding to the minimum and 
	 *  maximum values of the Slider component.
	 * 
	 * 	@see inky.components.events.SliderEvent
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.03.17
	 *
	 */
	public interface ISlider extends IDisplayObject
	{
		
		/**
		 * 
		 * Sets the direction of the slider. Acceptable values are <code>SliderDirection.HORIZONTAL</code> 
		 * and <code>SliderDirection.VERTICAL</code>.
		 * 
		 * @default SliderDirection.HORIZONTAL
		 * 
		 * @see inky.components.slider.SliderDirection
		 * 
		 */
		function get direction():String;
		function set direction(value:String):void;
		
		
		/**
		 * 
		 * Gets or sets a value that indicates whether the component can accept user interaction. 
		 * 
		 * @default true
		 * 
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		
		
		/**
		 * 
		 * Gets or sets a Boolean value that indicates whether the <code>SliderEvent.CHANGE</code> event is dispatched 
		 * continuously as the user moves the slider thumb. If the <code>liveDragging</code> property is <code>false</code>,
		 * the <code>SliderEvent.CHANGE</code> event is dispatched when the user releases the slider thumb.
		 * 
		 * @default false
		 * 
		 */
		function get liveDragging():Boolean;
		function set liveDragging(value:Boolean):void;


		/**
		 *
		 * The maximum allowed value on the Slider component instance.
		 * 
		 * @default 1
		 * 
		 */
		function get maximum():Number;
		function set maximum(value:Number):void;
		

		/**
		 *
		 * The minimum value allowed on the Slider component instance.
		 * 
		 * @default 0
		 * 
		 */
		function get minimum():Number;
		function set minimum(value:Number):void;
		
		
		/**
		 * 
		 * Gets or sets the increment by which the value is increased or decreased as the user moves the slider thumb.
		 * 
		 * For example, this property is set to 2, the <code>minimum</code> value is 0, 
		 * and the <code>maximum</code> value is 10, the position of the thumb 
		 * will always be at 0, 2, 4, 6, 8, or 10. 
		 * If this property is set to 0, the slider moves continuously between the minimum and maximum values.
		 * 
		 * @default 0
		 * 
		 */
		function get snapInterval():Number;
		function set snapInterval(value:Number):void;
		
		
		function get trackDragging():Boolean;
		function set trackDragging(value:Boolean):void;
		
		
		/*function get tickInterval():Number;
		function set tickInterval(value:Number):void;*/
		
		
		/**
		 *
		 * Gets or sets the current value of the Slider component. 
		 * This value is determined by the position of the slider thumb between the <code>minimum</code> and <code>maximum</code> values.
		 * 
		 * @default 0
		 * 
		 */
		function get value():Number;
		function set value(value:Number):void;
		
		
		

		
	}
	
}