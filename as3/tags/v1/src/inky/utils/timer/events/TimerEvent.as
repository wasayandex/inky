﻿package inky.utils.timer.events
{
	import flash.events.Event;
	import flash.events.TimerEvent;


	/**
	 *
	 *  A TimerEvent that defines more constants than flash.events.TimerEvent.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.05.01
	 *
	 */
	public class TimerEvent extends flash.events.TimerEvent
	{
		public static const START:String = "start";
		public static const STOP:String = "stop";
		public static const RESET:String = "reset";
		public static const TIMER:String = "timer";
		public static const TIMER_COMPLETE:String = "timerComplete";


		public function TimerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new inky.utils.timer.events.TimerEvent(this.type, this.bubbles, this.cancelable);
		}

	}
}