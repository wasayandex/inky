package inky.framework.collections.events
{

	/**
	 *  The CollectionEventKind class contains constants for the valid values 
	 *  of the inky.framework.collections.events.CollectionEvent class <code>kind</code> property.
	 *  These constants indicate the kind of change that was made to the collection.
	 *
	 *  @see inky.framework.collections.CollectionEvent
	 */
	public final class CollectionEventKind
	{
	    public static const ADD:String = "add";
	    public static const MOVE:String = "move";
	    public static const REMOVE:String = "remove";
	    public static const REPLACE:String = "replace";
	    public static const UPDATE:String = "update";
	}

}
