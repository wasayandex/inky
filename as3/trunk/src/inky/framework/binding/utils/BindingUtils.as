package inky.framework.binding.utils
{
	import flash.events.Event;
	import inky.framework.binding.utils.ChangeWatcher;


	/**
	 * 
	 */
	public class BindingUtils
	{


	    /**
	     * 
	     */
	    public static function bindProperty(site:Object, prop:String, host:Object, chain:Object):void
	    {
	        var watcher:ChangeWatcher = ChangeWatcher.watch(host, chain, null);

	        if (watcher != null)
	        {
	            var assign:Function = function(e:Event):void
	            {
	                site[prop] = watcher.getValue();
	            };
	            watcher.setHandler(assign);
	            assign(null);
	        }
	    }


	    /**
	     *
	     */
	    public static function bindSetter(setter:Function, host:Object, chain:Object):void
	    {
	        var watcher:ChangeWatcher = ChangeWatcher.watch(host, chain, null);
        
	        if (watcher != null)
	        {
	            var invoke:Function = function(e:Event):void
	            {
	                setter(watcher.getValue());
	            };
	            watcher.setHandler(invoke);
	            invoke(null);
	        }
	    }




	}
}
