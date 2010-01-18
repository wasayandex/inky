package inky.app.commands 
{
	import inky.commands.ChainableCommand;
	import inky.app.controller.IApplicationController;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import inky.commands.collections.CommandQueue;
	import inky.commands.FunctionCommand;
	import inky.commands.tokens.IAsyncToken;
	import inky.app.SPath;
	import inky.collections.IIterator;
	import flash.display.DisplayObject;
	import inky.components.transitioningObject.ITransitioningObject;
	import inky.utils.IDestroyable;
	import inky.commands.tokens.AsyncToken;
	import inky.app.model.IApplicationModel;
	import inky.components.transitioningObject.events.TransitionEvent;
	
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
	public class UpdateViewStack extends ChainableCommand
	{
		private var _applicationController:IApplicationController;
		private var _applicationModel:IApplicationModel;
		private var _queue:CommandQueue;
		private var _stack:Array;

		
		/**
		 *
		 */
		public function UpdateViewStack(applicationController:IApplicationController, view:Object, applicationModel:IApplicationModel)
		{
			this._applicationController = applicationController;
			this._applicationModel = applicationModel;
			this._queue = new CommandQueue();
			this._stack = [view];
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function execute(params:Object = null):Boolean
		{
			if (params.hasOwnProperty("action"))
			{
				var action:String = params.action;
				var sPath:SPath = SPath.parse(params.hasOwnProperty("sPath") ? params.sPath : "/");
				switch (action)
				{
					case "transitionToCommonAncestor":
					{
						this._transitionToCommonAncestor(sPath);
						break;
					}
					case "transitionTo":
					{
						this._transitionTo(sPath);
						break;
					}
					case "cancelQueuedCommands":
					{
						this._cancelQueuedCommands();
						break;
					}
				}
			}

			return true;
		}
		
		
		

		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _add(sPath:SPath):IAsyncToken
		{
			var sectionClassName:String = this._applicationModel.getSectionClassName(sPath);
			var sectionClass:Class = getDefinitionByName(sectionClassName) as Class;
			if (!sectionClass)
			{
				throw new ArgumentError("Cannot find class for " + sPath + ".");
			}
			else
			{
				var section:* = new sectionClass();
				section.name = sPath.toArray().pop().toString();
				
				var parent:DisplayObjectContainer = this._stack[this._stack.length - 1] as DisplayObjectContainer;
				var token:IAsyncToken = new AsyncToken();
				
				if (section is ITransitioningObject)
				{
					section.addEventListener
					(
						TransitionEvent.TRANSITION_FINISH, 
						function (event:TransitionEvent)
						{
							event.currentTarget.removeEventListener(event.type, arguments.callee);
							token.callResponders();
						}
					);
				}
				else
				{
					token.callResponders();
				}

				parent.addChild(DisplayObject(section));
				this._stack.push(section);
				
				return token;
			}
		}
		
		
		/**
		 * 
		 */
		private function _cancelQueuedCommands():void
		{
			this._queue.removeAll();
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
		private function _remove(object:DisplayObject):IAsyncToken
		{
			var token:IAsyncToken;
			
			// Remove the object from the stack.
			this._stack.splice(this._stack.indexOf(object), 1);
			
			// If the object is a transitioning object, return the object's token.
			if (object is ITransitioningObject)
			{
				token = ITransitioningObject(object).remove();
			}
			// Otherwise, create a token to represent the removal.
			else
			{
				if (object.parent)
					object.parent.removeChild(object);

				token = new AsyncToken();
				token.callResponders();
			}
			
			return token;
		}
		
		
		/**
		 * 
		 */
		private function _transitionTo(sPath:SPath):void
		{
			var currentSPath:SPath = this._getCurrentSPath();
			var relativizedSPath:SPath = currentSPath.relativize(sPath);
			var newSPath:SPath = relativizedSPath.resolve(currentSPath);
			var sPathsToAdd:Array = [];
			
			while (newSPath.length > currentSPath.length)
			{
				sPathsToAdd.push(newSPath.clone())
				newSPath.removeItemAt(newSPath.length - 1);
			}
			
			while (sPathsToAdd.length)
				this._queue.addItem(new FunctionCommand(this._add, [sPathsToAdd.pop()]));

			this._queue.start();
		}

		
		/**
		 * 
		 */
		private function _transitionToCommonAncestor(sPath:SPath):void
		{
			var relativizedPath:SPath = this._getCurrentSPath().relativize(sPath);
			var stack:Array = this._stack.slice();
			var segment:String;
			
			for (var i:IIterator = relativizedPath.iterator(); i.hasNext(); )
			{
				segment = String(i.next());
				if (segment == ".." && stack.length > 1)
				{
					var object:DisplayObjectContainer = stack.pop() as DisplayObjectContainer;
					if (object.parent)
					{
						// Add command to remove the object.
						this._queue.addItem(new FunctionCommand(this._remove, [object]));

						// Add a command to destroy the object.
						if (object is IDestroyable)
							this._queue.addItem(new FunctionCommand(IDestroyable(object).destroy));
					}
				}
				else
				{
					break;
				}
			}
			this._queue.start();
		}
		



	}
	
}