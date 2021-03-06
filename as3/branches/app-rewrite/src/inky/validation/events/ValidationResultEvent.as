﻿package inky.validation.events
{
	import flash.events.Event;
	import inky.validation.ValidationResult;


	/**
	 *
	 * ..
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Matthew Tretter
	 * @since  2008.11.17
	 *
	 */
	public class ValidationResultEvent extends Event
	{
		public var result:ValidationResult;


		/**
		 *
		 * 
		 */
		public static const VALID:String = 'valid';
		public static const INVALID:String = 'invalid';




		/**
		 *
		 * 
		 *
		 */
	    public function ValidationResultEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, result:ValidationResult = null)
	    {
			super(type, bubbles, cancelable);
			this.result = result;
	    }




		//
		// public methods
		//


		/**
		 *
		 * 
		 * 
		 */
	    override public function clone():Event
	    {
	        return new ValidationResultEvent(type, bubbles, cancelable, result);
	    }


		/**
		 *
		 * 
		 * 
		 */
		public override function toString():String
		{
			return this.formatToString('ValidationResultEvent', 'type', 'bubbles', 'cancelable', 'result');
		}




	}
}
