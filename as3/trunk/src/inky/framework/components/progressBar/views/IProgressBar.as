package com.exanimo.controls
{
	import com.exanimo.display.IDisplayObject;


	/**
	 *
	 *  Describes the methods that a ProgressBar must implement.
	 *
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author     Matthew Tretter (matthew@exanimo.com)
	 *	@version    2007.10.02
	 *
	 */
	public interface IProgressBar extends IDisplayObject
	{
		//
		// accessors
		//


		/**
		 *
		 * Gets or sets the maximum value for the progress bar
		 *
		 */
		function get maximum():Number;
		function set maximum(maximum:Number):void;


		/**
		 *
		 * Gets or sets the minimum value for the progress bar
		 *
		 */
		function get minimum():Number;
		function set minimum(minimum:Number):void;


		/**
		 *
		 * Gets or sets the method to be used to update the progress bar.
		 *
		 */
		function get mode():String;
		function set mode(mode:String):void;


		/**
		 *
		 * [read-only] Gets a number between 0 and 100 that indicates the
		 * percentage of the content has already loaded.
		 *
		 */
		function get percentComplete():Number;


		/**
		 *
		 * Gets or sets a reference to the content that is being loaded and for
		 * which the ProgressBar is measuring the progress of the load
		 * operation.
		 *
		 */
		function get source():Object;
		function set source(source:Object):void;


		/**
		 *
		 * Gets or sets a value that indicates the amount of progress that has
		 * been made in the load operation.
		 *
		 */
		function get value():Number;
		function set value(value:Number):void;




		//
		// public methods
		//


		/**
		 *
		 * Resets the progress bar for a new load operation.
		 *
		 */
		function reset():void;


		/**
		 *
		 * Sets the state of the bar to reflect the amount of progress made
		 * when using manual mode.
		 *
		 * @param value:Number
		 *     A value describing the progress that has been made.
		 * @param maximum:Number
		 *     The maximum progress value of the progress bar.
		 *
		 */
		function setProgress(value:Number, maximum:Number):void;




	}
}