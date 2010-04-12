package inky.app.controller.requestHandlers 
{
	import inky.app.controller.IApplicationController;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import inky.commands.FunctionCommand;
	import inky.commands.tokens.IAsyncToken;
	import flash.display.DisplayObject;
	import inky.components.transitioningObject.ITransitioningObject;
	import inky.utils.IDestroyable;
	import inky.commands.tokens.AsyncToken;
	import inky.app.data.IApplicationData;
	import inky.components.transitioningObject.events.TransitionEvent;
	import inky.app.controller.requests.CancelQueuedCommands;
	import inky.app.controller.requests.QueueCommand;
	import inky.app.controller.requestHandlers.IRequestHandler;
	import inky.app.controller.requests.TransitionToCommonAncestor;
	import inky.app.controller.requests.TransitionTo;
	import inky.app.data.ISectionData;
	
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
	public class ViewStackManager implements IRequestHandler
	{
		private var _applicationController:IApplicationController;
		private var _applicationData:IApplicationData;
		
		private var _classStack:Array;
		private var _stack:Array;

		
		/**
		 *
		 */
		public function ViewStackManager(applicationController:IApplicationController, view:Object, applicationData:IApplicationData)
		{
			if (!applicationController)
				throw new ArgumentError("The first argument must be non-null.");
			else if (!view)
				throw new ArgumentError("The second argument must be non-null.");
			else if (!applicationData)
				throw new ArgumentError("The third argument must be non-null.");
				
			this._applicationController = applicationController;
			this._applicationData = applicationData;
			
			this._classStack = [];
			this._stack = [view];
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function handleRequest(request:Object):Object
		{
			var sectionData:ISectionData;
			if (request is TransitionToCommonAncestor)
				this._transitionOutToCommonAncestor(this._getSectionData(request).viewClassStack);
			else if (request is TransitionTo)
				this._transitionTo(this._getSectionData(request).viewClassStack);

			return request;
		}




		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _add(viewClassName:String):IAsyncToken
		{
			var sectionClass:Class = getDefinitionByName(viewClassName) as Class;
			if (!sectionClass)
			{
				throw new ArgumentError("Cannot find class " + viewClassName + ".");
			}
			else
			{
				var section:* = new sectionClass();
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
			this._applicationController.handleRequest(new CancelQueuedCommands());
		}
		
		
		/**
		 * 
		 */
		private function _getSectionData(request:Object):ISectionData
		{
			var sectionData:ISectionData = this._applicationData.sections[request.section];
			if (!sectionData)
				throw new Error('Couldn\'t find section "' + request.section + '"');
			return sectionData;
		}


		/**
		 * 
		 */
		private function _queueCommand(command:Object):void
		{
			this._applicationController.handleRequest(new QueueCommand(command));
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
		private function _transitionInTo(classStack:Array):void
		{
// TODO: Throw an error if classStack doesn't start with currentClassStack.
			var currentClassStack:Array = this._classStack;
			var classesToAdd:Array = classStack.slice(currentClassStack.length);
			while (classesToAdd.length)
				this._queueCommand(new FunctionCommand(this._add, [classesToAdd.shift()]));
		}


		/**
		 * 
		 */
		private function _transitionTo(classStack:Array):void
		{
			this._transitionOutToCommonAncestor(classStack);
			this._transitionInTo(classStack);
		}

		
		/**
		 * 
		 */
		private function _transitionOutToCommonAncestor(classStack:Array):void
		{
// TODO: Throw an error if there is no common ancestor.
			var currentClassStack:Array = this._classStack;
			var numViewsToRemove:int = currentClassStack.length - classStack.length;
			for (var i:int = 0; i < numViewsToRemove; i++)
			{
				var object:DisplayObjectContainer = this._stack.pop() as DisplayObjectContainer;
				if (object.parent)
				{
					// Add command to remove the object.
					this._queueCommand(new FunctionCommand(this._remove, [object]));

					// Add a command to destroy the object.
					if (object is IDestroyable)
						this._queueCommand(new FunctionCommand(IDestroyable(object).destroy));
				}
				else
				{
					break;
				}
			}
		}




	}
	
}