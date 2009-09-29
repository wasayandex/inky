package inky.app
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import inky.binding.events.PropertyChangeEvent;
	import inky.app.events.SectionOptionsEvent;
	import inky.utils.IEquatable;
	import inky.utils.ObjectProxy;


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
	dynamic public class SectionOptions extends ObjectProxy implements IEquatable
	{
		private var _callbacks:Dictionary;

		/**
		 *
		 *	
		 *	
		 */
		public function SectionOptions(obj:Object = null)
		{
			super(obj);
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
// TODO: Automatically remove them when section is destroyed.
			this._callbacks[callback] = this._callbacks[callback] || {};
			this._callbacks[callback][property] = true;
		}


		/**
		 *	
		 */
		public function destroy():void
		{
			for each (var callback:Object in this._callbacks)
			{
				for (var prop:String in this._callbacks[callback])
				{
					this.removePropertyChangeCallback(prop, callback as Function);
				}
			}
		}


		/**
		 *
		 */
		public function equals(obj:Object):Boolean
		{
			var isEqual:Boolean = false;
			if (obj != null)
			{
				isEqual = true;
				var prop:String;
				for (prop in this)
				{
					if (this[prop] != obj[prop])
					{
						isEqual = false;
						break;
					}
				}
				if (isEqual)
				{
					for (prop in obj)
					{
						if (this[prop] != obj[prop])
						{
							isEqual = false;
							break;
						}
					}
				}
			}
			return isEqual;
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
//TODO: why does this dictionary need to be strong? It used to be weak, but
// handlers were garbage collected even though they were instance methods.
			this._callbacks = new Dictionary();
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
