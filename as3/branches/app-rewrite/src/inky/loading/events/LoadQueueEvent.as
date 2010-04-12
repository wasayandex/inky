package inky.loading.events
{
	import inky.loading.LoadQueue;
	import flash.events.Event;


	/**
	 *
	 * The LoadQueueEvent class defines events that are associated with the
	 * LoadQueue class.
	 *	
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2007.12.06
	 *
	 */
	public class LoadQueueEvent extends Event
	{
		public static const ASSET_ADDED:String = 'assetAdded';
		public static const ASSET_COMPLETE:String = 'assetComplete';
		public static const ASSET_OPEN:String = 'assetOpen';
		public static const ASSET_REMOVED:String = 'assetRemoved';

		private var _loader:Object;
		private var _loadQueue:LoadQueue;




		/**
		 *
		 * Creates a new LoadQueueEvent object that contains information about a
		 * load queue event. A LoadQueueEvent object is passed as a parameter to
		 * an event listener.
		 * 
		 * @param type
		 *     The type of the event. Event listeners can access this
		 *     information through the type property of the event object. A
		 *     LoadQueue can have the following types of events:
		 *     LoadQueueEvent.ASSET_ADDED, LoadQueueEvent.ASSET_COMPLETE,
		 *     LoadQueueEvent.ASSET_OPEN, LoadQueueEvent.ASSET_REMOVED.
		 * @param bubbles
		 *     Determines whether the LoadQueueEvent object participates in the
		 *     bubbling phase of the event flow. Event listeners can access this
		 *     information through the bubbles property of the event object.
		 * @param cancelable
		 *     Determines whether the LoadQueueEvent object can be canceled.
		 *     Event listeners can access this information through the
		 *     cancelable property of the event object.
		 * @param loader
		 *     The object responsible for the loading process. Event listeners
		 *     can access this information through the loader property of the
		 *     event object.
		 * @param loadQueue
		 *     The LoadQueue to which the loader belongs. Event listeners can
		 *     access this information through the loadQueue property of the
		 *     event object.		 		 
		 *	
		 */
		public function LoadQueueEvent(type:String, bubbles:Boolean, cancelable:Boolean, loader:Object, loadQueue:LoadQueue)
		{
			super(type, bubbles, cancelable);
			this._loader = loader;
			this._loadQueue = loadQueue;
		}




		//
		// accessors
		//


		/**
		 *
		 * Gets a reference to the object responsible for the loading process.
		 * Generally, this will be a Loader or URLLoader, but it can be any
		 * object that the user adds to the LoadQueue.
		 * 
		 * @see inky.loading.LoadQueue#addItem()		 		 		 		 
		 *	
		 */
		public function get loader():Object
		{
			return this._loader;
		}


		/**
		 *
		 * The LoadQueue to which the loader belongs. Because LoadQueues can be
		 * nested, this is not necessarily the same LoadQueue that is
		 * dispatching the event.		 
		 *	
		 */
		public function get loadQueue():LoadQueue
		{
			return this._loadQueue;
		}




		//
		// public methods
		//
		
		
		/**
		 *
		 * Creates a copy of the LoadQueueEvent object and sets the value of
		 * each parameter to match the original.
		 *
		 * @return
		 *     A new LoadQueueEvent object with property values that match those
		 *     of the original.
		 *	
		 */
		override public function clone():Event
		{
			return new LoadQueueEvent(this.type, this.bubbles, this.cancelable, this.loader, this.loadQueue);
		}
		
		
		/**
		 *
		 * Returns a string that contains all the properties of the
		 * LoadQueueEvent object. The string is in the following format:
		 * 
		 * <code>[LoadQueueEvent type=value bubbles=value cancelable=value loader=value loadQueue=value]</code>
		 *
		 * @return
		 *     A string representation of the LoadQueueEvent object.
		 *	
		 */
		override public function toString():String
		{
			return this.formatToString('LoadQueueEvent', 'type', 'bubbles', 'cancelable', 'loader', 'loadQueue');
		}




	}
}
