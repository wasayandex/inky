package inky.injection 
{
	import inky.injection.IInjectionAdapter;
	import inky.injection.IInjector;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	
	/**
	 *
	 *  The Injector class is a basic implementation of the IInjector interface.
	 *  @see inky.injector.IInjector
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.11.19
	 *
	 */
	public class Injector implements IInjector
	{
		private var _dispatcher:IEventDispatcher;
		private var _events2Filters:Object;
		
		/**
		 *
		 * Creates a new Injector.
		 * 		
		 */
		public function Injector(dispatcher:IEventDispatcher)
		{
			this._events2Filters = {};
			this._dispatcher = dispatcher;
		}
		
		

		
		//
		// public methods
		//


		/**
		 * @inheritDoc	
		 */
		public function map(eventType:String, adapter:IInjectionAdapter, filter:Function):void
		{
			var eventFilters:Array = this._events2Filters[eventType] || (this._events2Filters[eventType] = []);
			eventFilters.push({filter: filter, adapter: adapter});
			this._dispatcher.addEventListener(eventType, this._filterEvent, false, 0, true);
		}
		
		
		
		
		//
		// private methods
		//
		
		
		/**
		 *	
		 */
		private function _filterEvent(event:Event):void
		{
			var eventFilters:Array = this._events2Filters[event.type];
			for each (var filterInfo:Object in eventFilters)
			{
				if (filterInfo.filter.apply(null, [event]))
					filterInfo.adapter.inject(event.target);
			}
		}


	
		
	}
	
}