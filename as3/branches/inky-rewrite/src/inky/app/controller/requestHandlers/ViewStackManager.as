package inky.app.controller.requestHandlers 
{
	import inky.app.controller.IApplicationController;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import inky.commands.FunctionCommand;
	import inky.commands.tokens.IAsyncToken;
	import inky.app.SPath;
	import inky.collections.IIterator;
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
			if (request is TransitionToCommonAncestor)
				this._transitionToCommonAncestor(this._toSPath(request.section));
			else if (request is TransitionTo)
				this._transitionTo(this._toSPath(request.section));

			return request;
		}
		
		
		

		//
		// private methods
		//
		
		
		/**
		 * 
		 */
		private function _add(sPath:SPath):IAsyncToken
		{
			var sectionClassName:String = this._applicationData.viewData[sPath.toString()];
			if (!sectionClassName)
				throw new Error("There is no view data for " + sPath.toString());
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
			this._applicationController.handleRequest(new CancelQueuedCommands());
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
		private function _toSPath(section:Object):SPath
		{
			var sPath:SPath;
			if (section is SPath)
				sPath = section as SPath;
			else if (section is String)
				sPath = SPath.parse(section as String);
			else
				throw new Error();
			return sPath;
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
				this._queueCommand(new FunctionCommand(this._add, [sPathsToAdd.pop()]));
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
							this._queueCommand(new FunctionCommand(this._remove, [object]));

						// Add a command to destroy the object.
						if (object is IDestroyable)
							this._queueCommand(new FunctionCommand(IDestroyable(object).destroy));
					}
				}
				else
				{
					break;
				}
			}
		}

	}
	
}