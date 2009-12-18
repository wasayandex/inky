package inky.app
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import inky.app.SPath;
	import inky.app.Application;
	import inky.async.actions.ActionQueue;
	import inky.async.actions.IAction;
	import inky.async.actions.FunctionAction;
	import inky.components.transitioningObject.ITransitioningObject;
	import inky.async.IAsyncToken;
	import inky.async.AsyncToken;
	import inky.components.transitioningObject.events.TransitionEvent;
	import inky.async.async_internal;
	import inky.app.ISection;
	import inky.utils.IDestroyable;
	import inky.collections.IIterator;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.26
	 *
	 */
	public class ViewStack
	{
		protected var _queue:ActionQueue;
		private var _stack:Array;
		private static var _application:Application;
		private static var _instance:ViewStack;
		
		/**
		 *
		 */
		public function ViewStack()
		{
			this._queue = new ActionQueue();
		}
		


		
		//
		// public methods
		//


		/**
		 *	
		 */
		public function add(view:Object, callback:Function = null):DisplayObject
		{
			var child:ISection = view as ISection;
			if (!child)
			{
				var name:String = view.toString();
				if (name)
				{
					var sectionClass:Class = _application.model.getSectionClassByName(name);
					if (sectionClass)
					{
						var section:* = new sectionClass();
						section.name = name;

						child = section as ISection;
					}
					if (!child)
						throw new ArgumentError(view + " is not an ISection.");
				}
				else
				{
					throw new ArgumentError(view + " is not an ISection.");
				}
			}

			var childToAdd:DisplayObject = DisplayObject(child);
			this._addToDisplayList(childToAdd);
			this._stack.push(child);

// TODO: trigger callback before or after the add?
			if (callback != null)
				callback(child);

			this._queue.start();

			return childToAdd;
		}
		
		
		/**
		 * 
		 */
		public function cancelQueuedActions():void
		{
			this._queue.removeAll();
		}
		
		
		/**
		 *	
		 */
		public static function getInstance():ViewStack
		{
			return _instance || (_instance = new ViewStack());
		}
		
		
		/**
		 *	
		 */
		public function initialize(application:Application):void
		{
			_application = application;
			this._stack = [_application];
		}
		
		
		/**
		 *	
		 */
		public function removeAll():void
		{
			while (this._stack.length > 1)
			{
				var leaf:DisplayObjectContainer = this._stack.pop() as DisplayObjectContainer;
				if (leaf.parent)
					this._removeFromDisplayList(leaf);
			}

			this._queue.start();
		}
		
		
		/**
		 *	
		 */
		public function removeLeaf():void
		{
			if (this._stack.length > 1)
			{
				var leaf:DisplayObjectContainer = this._stack.pop() as DisplayObjectContainer;
				if (leaf.parent)
					this._removeFromDisplayList(leaf);
			}

			this._queue.start();
		}


		/**
		 * 
		 */
		public function transitionTo(sPath:SPath, callback:Function = null):void
		{
			if (!sPath.absolute)
				throw new ArgumentError();
				
			this._queue.addItem(new FunctionAction(this._transitionTo, [sPath, callback]));
			this._queue.start();
		}

		
		/**
		 *	
		 */
		public function transitionToCommonAncestor(sPath:SPath):void
		{
			this._queue.addItem(new FunctionAction(this._transitionToCommonAncestor, [sPath]));
			this._queue.start();
		}
		
		
		

		//
		// private methods
		//
		
		
		/**
		 *	
		 */
		private function _addToDisplayList(child:DisplayObject, parent:DisplayObjectContainer = null):void
		{
			parent = parent || this._stack[this._stack.length - 1];
			var action:IAction;
			if (child is ITransitioningObject)
				action = new FunctionAction(this._addTransitioningObject, [ITransitioningObject(child), parent]);
			else
				action = new FunctionAction(parent.addChild, [child]);
			this._queue.addItem(action);
		}
		
		
		/**
		 *	
		 */
		private function _addTransitioningObject(child:ITransitioningObject, parent:DisplayObjectContainer):IAsyncToken
		{
			var token:IAsyncToken = new AsyncToken();
			child.addEventListener(TransitionEvent.TRANSITION_FINISH, 
				function(event:TransitionEvent) 
				{
					event.currentTarget.removeEventListener(event.type, arguments.callee);
					token.async_internal::callResponders(); 
				}
			);

			parent.addChild(DisplayObject(child));
			return token;
		}


		/**
		 * 
		 */
		private function _getCurrentSPath():SPath
		{
			return SPath.parse("/" + this._stack.map(function(o:Object, i:int, a:Array) { return o.name; }).splice(1).join("/"));	
		}


		/**
		 *	
		 */
		private function _removeFromDisplayList(leaf:DisplayObject):void
		{
			var action:IAction;
			if (leaf is ITransitioningObject)
				action = new FunctionAction(this._removeTransitioningObject, [ITransitioningObject(leaf)]);
			else
				action = new FunctionAction(leaf.parent.removeChild, [leaf]);
			this._queue.addItem(action);

// TODO: Destroy before or after the remove?
			if (leaf is IDestroyable)
				this._queue.addItem(new FunctionAction(IDestroyable(leaf).destroy));
		}
		
		
		/**
		 *	
		 */
		private function _removeTransitioningObject(child:ITransitioningObject):IAsyncToken
		{
			return child.remove();
		}
		
		
		/**
		 * 
		 */
		private function _transitionTo(sPath:SPath, callback:Function = null):void
		{
			var currentSPath:SPath = this._getCurrentSPath();
			var relativizedPath:SPath = currentSPath.relativize(sPath);
			for (var i:IIterator = relativizedPath.iterator(); i.hasNext(); )
			{
				var segment:String = String(i.next());
				if (segment != "..")
				{
					if (i.hasNext())
						this._queue.addItem(new FunctionAction(this.add, [segment]));
					else
						this._queue.addItem(new FunctionAction(this.add, [segment, callback]));
				}
			}
		}
		
		
		/**
		 * 
		 */
		private function _transitionToCommonAncestor(sPath:SPath):void
		{
			var currentSPath:SPath = this._getCurrentSPath();
			var relativizedPath:SPath = currentSPath.relativize(sPath);
			
			for (var i:IIterator = relativizedPath.iterator(); i.hasNext(); )
			{
				var segment:String = String(i.next());
				if (segment == "..")
					this._queue.addItem(new FunctionAction(this.removeLeaf));
				else
					break;
			}
		}
		
		


	}
	
}