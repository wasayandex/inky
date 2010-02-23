package inky.components.map.models
{
	import flash.events.EventDispatcher;
	import inky.binding.events.PropertyChangeEvent;
	import inky.collections.ArrayList;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Rich Perez
	 *	@since  2010.02.19
	 *
	 */
	dynamic public class CategoryModel extends EventDispatcher
	{
		private var _snippet:Object;
		private var _placemarks:ArrayList;

		/**
		 *
		 */
		public function CategoryModel()
		{
			this._placemarks = new ArrayList();
		}
		
		//
		// accssors
		//
		
		public function get placemarks():ArrayList
		{ 
			return this._placemarks; 
		}
		
		/**
		 *
		 */
		public function get selected():Boolean
		{ 
			return this._selected; 
		}
		public function set selected(value:Boolean):void
		{
			var oldValue:Boolean = this._selected;
			if (value != this._selected)
			{
				this._selected = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", oldValue, value));	
			}
		}
		
		/**
		*	Can be any type of object. Usually used to hold any miscellaneous information.	
		*/
		public function get snippet():Object
		{
			return this._snippet;
		}
		public function set snippet(value:Object):void
		{
			this._snippet = value;
		}
		
	}
}

