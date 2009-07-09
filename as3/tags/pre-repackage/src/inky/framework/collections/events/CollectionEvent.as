package inky.framework.collections.events
{
	import flash.events.Event;



	public class CollectionEvent extends Event
	{
	    public static const COLLECTION_CHANGE:String = "collectionChange";
		public var kind:String;
	    public var items:Array;
	    public var location:int;
	    public var oldLocation:int;


		/**
		 *
		 */
	    public function CollectionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, kind:String = null, location:int = -1, oldLocation:int = -1, items:Array = null)
	    {
	        super(type, bubbles, cancelable);

	        this.kind = kind;
	        this.location = location;
	        this.oldLocation = oldLocation;
	        this.items = items ? items : [];
	    }


	    /**
	     *  @private
	     */
	    override public function toString():String
		{
	        return formatToString("CollectionEvent", "kind", "location", "oldLocation", "type", "bubbles", "cancelable", "eventPhase");
	    }


	    /**
	     *  @private
	     */
	    override public function clone():Event
	    {
	        return new CollectionEvent(type, bubbles, cancelable, kind, location, oldLocation, items);
	    }




	}
}
