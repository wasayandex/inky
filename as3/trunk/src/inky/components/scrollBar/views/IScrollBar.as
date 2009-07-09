package inky.components.scrollBar.views
{
	import inky.utils.IDisplayObject;


	/**
	 *
	 * The ScrollBar component provides the end user with a way to control the
	 * portion of data that is displayed when there is too much data to fit in
	 * the display area. The scroll bar consists of four parts: two arrow
	 * buttons, a track, and a thumb. The position of the thumb and display of
	 * the buttons depends on the current state of the scroll bar. The scroll
	 * bar uses four parameters to calculate its display state: a minimum range
	 * value; a maximum range value; a current position that must be within the
	 * range values; and a viewport size that must be equal to or less than the
	 * range and represents the number of items in the range that can be
	 * displayed at the same time.
	 *
	 * @see http://exanimo.com/actionscript/scrollpane/	 	
	 *	 	 
	 * @author    Matthew Tretter (matthew@exanimo.com)
	 *
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *	
	 */
	public interface IScrollBar extends IDisplayObject
	{

		//
		// accessors
		//


		/**
		 *
		 * Gets or sets a value that indicates whether the scroll bar scrolls
		 * horizontally or vertically. Valid values are
		 * ScrollBarDirection.HORIZONTAL and ScrollBarDirection.VERTICAL.
		 * 
		 * @default ScrollBarDirection.VERTICAL.
		 *
		 */		 		 		 		
		function get direction():String;
		/**
		 * @private
		 */		 		
		function set direction(direction:String):void;


		/**
		 *
		 * Gets or sets a Boolean value that indicates whether the scroll bar is
		 * enabled. A value of true indicates that the scroll bar is enabled; a
		 * value of false indicates that it is not.
		 * 
		 * @default true		 		 
		 *
		 */		 		 		 		
		function get enabled():Boolean;
		/**
		 * @private
		 */		 		
		function set enabled(enabled:Boolean):void;


		/**
		 *
		 * Gets or sets a value that represents the increment by which to scroll
		 * the page when the scroll bar track is pressed. The
		 * <code>pageScrollSize</code> is measured in increments between the
		 * <code>minScrollPosition</code> and the <code>maxScrollPosition</code>
		 * values. If this value is set to 0, the value of the
		 * <code>pageSize</code> property is used.
		 * 
		 * @default 0		 		 
		 *
		 */
		function get lineScrollSize():Number;
		/**
		 * @private
		 */	
		function set lineScrollSize(lineScrollSize:Number):void;


		/**
		 *
		 * Gets or sets a number that represents the maximum scroll position.
		 * The <code>scrollPosition</code> value represents a relative position
		 * between the <code>minScrollPosition</code> and the
		 * <code>maxScrollPosition</code> values. This property is set by the
		 * component that contains the scroll bar, and is the maximum value.
		 *
		 * @default 0
		 *		 		 
		 */
		function get maxScrollPosition():Number;
		/**
		 * @private
		 */	
		function set maxScrollPosition(maxScrollPosition:Number):void;


		/**
		 *
		 * Gets or sets a number that represents the minimum scroll position.
		 * The <code>scrollPosition</code> value represents a relative position
		 * between the <code>minScrollPosition</code> and the
		 * <code>maxScrollPosition</code> values. This property is set by the
		 * component that contains the scroll bar, and is usually zero.
		 * 
		 * @default 0		 		 
		 *
		 */
		function get minScrollPosition():Number;
		/**
		 * @private
		 */	
		function set minScrollPosition(minScrollPosition:Number):void;


		/**
		 *
		 * Gets or sets a value that represents the increment by which the page
		 * is scrolled when the scroll bar track is pressed. The
		 * <code>pageScrollSize</code> value is measured in increments between
		 * the <code>minScrollPosition</code> and the
		 * <code>maxScrollPosition</code> values. If this value is set to 0, the
		 * value of the <code>pageSize</code> property is used.
		 * 
		 * @default 0
		 *
		 */		 		 		 		
		function get pageScrollSize():Number;
		/**
		 * @private
		 */
		function set pageScrollSize(pageScrollSize:Number):void;


		/**
		 *
		 * Gets or sets the number of lines that a page contains. The
		 * <code>lineScrollSize</code> is measured in increments between the
		 * <code>minScrollPosition</code> and the
		 * <code>maxScrollPosition</code>. If this property is 0, the scroll bar
		 * will not scroll.
		 * 
		 * @default 10
		 *
		 */		 		 		 		
		function get pageSize():Number;
		/**
		 * @private
		 */
		function set pageSize(pageSize:Number):void;


		/**
		 *
		 * Gets or sets the number of milliseconds between when the user presses
		 * the arrow button and the content begins to scroll at a consistant
		 * rate.
		 * 
		 * @default 500
		 *
		 */
		function get repeatDelay():Number;
		/**
		 * @private
		 */
		function set repeatDelay(repeatDelay:Number):void;


		/**
		 *
		 * Gets or sets the number of milliseconds between scrolling after an
		 * arrow button has been depressed for repeatDelay milliseconds.
		 * 
		 * @default 35		 		 
		 *
		 */
		function get repeatInterval():Number;
		/**
		 * @private
		 */
		function set repeatInterval(repeatInterval:Number):void;


		/**
		 *
		 * A boolean value that represents whether the thumb should be resized
		 * based on the difference between <code>minScrollPosition</code> and
		 * <code>maxScrollPosition</code>.
		 * 
		 * @default true		 		 
		 *
		 */
		function get scaleThumb():Boolean;
		/**
		 * @private
		 */
		function set scaleThumb(scaleThumb:Boolean):void;
		
		
		/**
		 *
		 * Gets or sets the current scroll position and updates the position of
		 * the thumb. The <code>scrollPosition</code> value represents a
		 * relative position between the <code>minScrollPosition</code> and
		 * <code>maxScrollPosition</code> values.
		 *
		 */
		function get scrollPosition():Number;
		/**
		 * @private
		 */
		function set scrollPosition(scrollPosition:Number):void;




	}
}
