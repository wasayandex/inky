package inky.framework.core
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.events.SectionOptionsEvent;
	import inky.framework.utils.ObjectProxy;


	/**
	 *
	 * 
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.08.25
	 *
	 */
	dynamic public class SectionOptions extends ObjectProxy
	{
		private var _callbacks:Dictionary;


		/**
		 *
		 *	
		 *	
		 */
		public function SectionOptions()
		{
			this._init();
		}




		//
		// public methods
		//


		/**
		 *
		 *	
		 */
		public function addPropertyChangeCallback(property:String, callback:Function):void
		{
			this._callbacks[callback] = this._callbacks[callback] || {};
			this._callbacks[callback][property] = true;
		}


		/**
		 *
		 *	
		 */
		public function removePropertyChangeCallback(property:String, callback:Function):void
		{
			if (this._callbacks[callback])
			{
				delete this._callbacks[callback][property];

				// If no properties remain with this callback, remove the list.
				var properties:int = 0;
				for (var prop:String in this._callbacks[callback])
				{
					properties++;
				}
				if (!properties)
				{
					delete this._callbacks[callback];
				}
			}
		}


		/**
		 *
		 *	
		 */
		public function update(options:Object):void
		{
			var prop:String;
			var isChanged:Boolean = false;
			for (prop in this)
			{
				if (!options.hasOwnProperty(prop))
				{
					delete this[prop];
					isChanged = true;
				}
			}
			for (prop in options)
			{
				isChanged = isChanged || (this[prop] != options[prop]);
				this[prop] = options[prop];
			}

			if (isChanged)
			{
				this.dispatchEvent(new SectionOptionsEvent(SectionOptionsEvent.CHANGE));
			}

			this.dispatchEvent(new SectionOptionsEvent(SectionOptionsEvent.UPDATE));
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _init():void
		{
			this._callbacks = new Dictionary(true);
			this.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._propertyChangeEventHandler);
		}


		/**
		 *
		 *	
		 */
		private function _propertyChangeEventHandler(e:PropertyChangeEvent):void
		{
			for (var callback:Object in this._callbacks)
			{
				for (var prop:String in this._callbacks[callback])
				{
					if (prop == e.property)
					{
						callback();
					}
				}
			}
		}




	}
}
