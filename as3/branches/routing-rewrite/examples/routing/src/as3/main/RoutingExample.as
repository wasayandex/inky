package  
{
	import flash.display.Sprite;
	import inky.routing.Mapper;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2008.09.22
	 *
	 */
	public class RoutingExample extends Sprite
	{
		
		/**
		 *
		 */
		public function RoutingExample()
		{
			var m:Mapper = new Mapper();
			m.connect("#/some/pretty/:path", this.doStuff, {controller: "happy"});
		}


		/**
		 *	
		 */
		private function doStuff(params:Object):void
		{
			trace(params)
			for (var p:String in params)
				trace("\t" + p + ":\t" + params[p]);
		}

		
	}
	
}