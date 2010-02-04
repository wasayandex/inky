package inky.collections
{
	import inky.collections.ISet;
	import inky.collections.ICollection;
	import inky.collections.IIterator;
	import inky.collections.ArrayList;
	import inky.collections.ArrayIterator;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 * 	@author Zack Dolin
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  30.07.2008
	 */
	public class Set implements IEventDispatcher, ISet
	{
		private var _set:ArrayList;

		/**
		 *	@Constructor
		 */
		public function Set()
		{
			this._set = new ArrayList();
		}



		
		//
		// accessors
		//


		/**
		 *	@inheritDoc	
		 */
		public function get length():uint
		{
			return this._set.length;
		}




		//
		// public methods
		//


		/**
		 *	@inheritDoc	
		 */
		public function addItem(item:Object):void
		{
			this._set.addItem(item);
		}
		
		/**
		 *	@inheritDoc	
		 */
		public function addItems(collection:ICollection):void
		{
			this._set.addItems(collection);
		}
		
		/**
		 *	@inheritDoc	
		 */
		public function containsItem(item:Object):Boolean
		{
			return this._set.containsItem(item);
		}
		
		/**
		 * @inheritDoc
		 */
		public function iterator():IIterator
		{
			return new ArrayIterator(this._set.toArray());
		}
		
		
		/**
		 *	@inheritDoc
		 */
		public function containsItems(collection:ICollection):Boolean
		{
			return this._set.containsItems(collection);
		}
		
		/**
		 *	@inheritDoc	
		 */
		public function equals(o:Object):Boolean
		{
			return this._set.equals(o);
		}
		
		/**
		 *	@inheritDoc	
		 */
		public function get isEmpty():Boolean
		{
			return this._set.isEmpty;
		}
		
		/**
		 *	@inheritDoc	
		 */
		public function removeAll():void
		{
			this._set.removeAll();
		}
		
		/**
		 *	@inheritDoc	
		 */
		public function removeItem(item:Object):Object
		{
			return this._set.removeItem(item);
		}
		
		/**
		 *	@inheritDoc
		 */
		public function removeItems(collection:ICollection):void
		{
			this._set.removeItems(collection);			
		}
		
		/**
		 *	@inheritDoc	
		 */
		public function retainItems(collection:ICollection):void
		{
			this._set.retainItems(collection);
		}
		
		/**
		 *	@inheritDoc
		 */
		public function toArray():Array
		{
			return this._set.toArray();
		}



		//
		// event dispatcher methods
		//


		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this._set.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}


		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return this._set.dispatchEvent(event);
		}


		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return this._set.hasEventListener(type);
		}


		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return this._set.removeEventListener(type, listener, useCapture);
		}


		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this._set.willTrigger(type);
		}


	}	
}