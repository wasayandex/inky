package inky.loading
{
	import inky.loading.IAsset;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.24
	 *
	 */
	public class SoundAsset implements IAsset
	{
		
		private var _source:String;


		/** @inheritDoc */
		public function get source():String { return this._source; }
		/** @private */
		public function set source(value:String):void { this._source = value; }


		/**
		 * @inheritDoc
		 */
		public function load():void
		{
			
		}
		
	}
	
}