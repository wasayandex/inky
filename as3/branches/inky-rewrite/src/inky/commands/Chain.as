package inky.commands 
{
	import inky.commands.ICommand;
	import inky.collections.Set;
	import inky.collections.IIterator;
	import inky.commands.IChainable;
	import inky.collections.ICollection;
	import inky.commands.IAsyncCommand;
	import inky.commands.IChain;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.06
	 *
	 */
	public class Chain extends Set implements IChain
	{
		private var _next:Object;
		
		/**
		 *
		 */
		public function Chain(next:Object = null)
		{
			this.next = next;
		}
		
		
		

		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function set next(value:Object):void
		{
			if (!value || (value is IChainable || value is ICommand || value is IAsyncCommand))
				this._next = value;
			else
				throw new ArgumentError("Invalid command. Command must be either IChainable, ICommand, or IAsyncCommand");
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function addItem(item:Object):void
		{
			if (!(item is IChainable))
				throw new ArgumentError("Item must be IChainable.");

			super.addItem(item);
			this._updateItemChain();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function addItems(collection:ICollection):void
		{
			for (var i:IIterator = collection.iterator(); i.hasNext(); )
			{
				if (!(i.next() is IChainable))
					throw new ArgumentError("All items must be IChainable.");
			}

			super.addItems(collection);
			this._updateItemChain();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function execute(params:Object):Boolean
		{
			var i:IIterator = this.iterator();
			if (i.hasNext())
				i.next().start(params);

			return true;
		}
		
		
		
		/**
		 * @inheritDoc
		 */
		public function start(params:Object):void
		{
			var doNext:Boolean = this.execute(params);
			if (doNext && this._next)
			{
				if (this._next is IChainable)
					this._next.start(params);
				else
					this._next.execute(params);
			}
		}
		
		
		
		
		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _updateItemChain():void
		{
			var lastItem:Object;
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var item:Object = i.next();
				if (lastItem)
					lastItem.next = item;
				lastItem = item;
			}
		}
		

		

	}
	
}