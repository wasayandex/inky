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
		private var _queue:ActionQueue;
		private var _stack:Array;
		private static var _application:Application;
		private static var _instance:ViewStack;
		
		/**
		 *
		 */
		public function ViewStack()
		{
			this._stack = [_application];
			this._queue = new ActionQueue();
		}
		


		
		//
		// public methods
		//
		
		
		/**
		 *	
		 */
		public static function initialize(application:Application):void
		{
			_application = application;
		}
		
		
		/**
		 *	
		 */
		public static function getInstance():ViewStack
		{
			if (!_application)
				throw new Error("You must initialize ViewStack before getting one.")
			return _instance || (_instance = new ViewStack());
		}
		
		
		/**
		 *	
		 */
		public function add(view:Object):void
		{
			var child:ISection = view as ISection;
			if (!child)
			{
				var name:String = view.toString();
				if (name)
				{
					// Create an instance of the section.
					var sectionClass:Class = _application.model.getSectionClassByName(name);
					if (sectionClass)
					{
						var section:* = new sectionClass();
						section.name = name;

						child = section as ISection;
					}
					if (!child)
						throw new Error("An iSection with a class name of " + view + " cannot be found.");
				}
				else
				{
					throw new Error(view + " is not an ISection.");
				}
			}

			this._addToDisplayList(DisplayObject(child), this._stack[this._stack.length - 1]);
			this._stack.push(child);
		}
		
		
		/**
		 *	
		 */
		public function reduceToCommonAncestor(sPath:SPath):SPath
		{
			var currentSPath:SPath = SPath.parse("/" + this._stack.map(function(o:Object, i:int, a:Array) { return o.name; }).splice(1).join("/"));
			var remainder:SPath = currentSPath.relativize(sPath);
			
			for (var i:int = 0; i < remainder.length; i++)
			{
				if (remainder.getItemAt(i) == "..")
				{
					remainder.removeItemAt(i);
					this.removeLeaf();
					i--;
				}
				else
				{
					break;
				}
			}

			return remainder;
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
			this._queue.start();
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

			this._queue.start();
		}
		
		
		/**
		 *	
		 */
		private function _removeTransitioningObject(child:ITransitioningObject):IAsyncToken
		{
			return child.remove();
		}
		
		


	}
	
}