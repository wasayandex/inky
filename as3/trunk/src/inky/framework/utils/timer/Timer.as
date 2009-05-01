package inky.framework.utils.timer
{
	import flash.events.Event;
	import flash.utils.Timer;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.utils.timer.TimerEvent;


	/**
	 *
	 *  A timer that dispatches more events than flash.utils.Timer
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.05.01
	 *
	 */
	public class Timer extends flash.utils.Timer
	{
		private var _running:Boolean;


		public function Timer(delay:Number, repeatCount:int = 0)
		{
			this._running = false;
			this.addEventListener(TimerEvent.TIMER_COMPLETE, this._timerCompleteHandler, false, int.MAX_VALUE, true);
			super(delay, repeatCount);
		}


		private function _timerCompleteHandler(e:Event):void
		{
			this._setRunning(false);
		}


		override public function get running():Boolean
		{
			return this._running;
		}

		private function _setRunning(value:Boolean):void
		{
			var oldValue:Boolean = this.running;
			if (value != oldValue)
			{
				this._running = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "running", oldValue, value));
			}
		}



		override public function start():void
		{
			var alreadyRunning:Boolean = this.running;
			super.start();
			if (!alreadyRunning)
			{
				this._setRunning(true);
				this.dispatchEvent(new TimerEvent(TimerEvent.START));
			}
		}


		override public function stop():void
		{
			var isRunning:Boolean = this.running;
			super.stop();
			if (isRunning)
			{
				this._setRunning(false);
				this.dispatchEvent(new TimerEvent(TimerEvent.STOP));
			}
		}


		override public function reset():void
		{
//			this._setRunning(???????);
			super.reset();
			this.dispatchEvent(new TimerEvent(TimerEvent.RESET));
		}

	}
}