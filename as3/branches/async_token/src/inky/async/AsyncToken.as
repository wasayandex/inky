package inky.async 
{
	import flash.events.EventDispatcher;
	import inky.async.async_internal;
	import inky.binding.events.PropertyChangeEvent;
	import flash.utils.Dictionary;
	
	use namespace async_internal;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *  @author Matthew Tretter
	 *	@since  2009.06.25
	 *
	 */
	dynamic public class AsyncToken extends EventDispatcher
	{
		private var _complete:Boolean;
		private var _responders:Dictionary;
		
		/**
		 *
		 */
		public function AsyncToken()
		{
			this._complete = false;
		}
		
		
		

		//
		// accessors
		//


		/**
		 *	
		 */
		public function get complete():Boolean
		{
			return this._complete;
		}
		
		
		
		
		//
		// public methods
		//

		
		/**
		 *	
		 */
		public function addResponder(responder:Function, filter:Object = null):void
		{
			if (responder == null)
				throw new ArgumentError('responder is null.');

			if (!this.complete)
			{
				// TODO: Do we need to be able to store responders weakly? If so, how?
				// If the Dictionary is weak, a bug causes the function reference to be
				// garbage collected immediately!
				// (see: http://www.gskinner.com/blog/archives/2006/07/as3_dictionary.html)
				if (!this._responders)
					this._responders = new Dictionary();
				this._responders[responder] = filter;
			}
			else if (!filter || filter.test(this))
			{
				responder.call(this);
			}
		}
		
		
		/**
		 *	
		 */
		async_internal function callResponders():void
		{
			if (!this.complete)
			{
				if (this._responders)
				{
					for (var responder:Object in this._responders)
					{
						var filter:Object = this._responders[responder];
						if (!filter || filter.test(this))
							responder(this);
					}
					this._responders = null;
				}

				this._complete = true;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, 'complete', false, true));
			}
		}



		
	}
	
}
