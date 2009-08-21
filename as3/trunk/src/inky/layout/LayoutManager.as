package inky.layout 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import inky.layout.ILayoutManagerClient;
	import flash.events.Event;
	import inky.layout.PriorityQueue;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.07.30
	 *
	 */
	public class LayoutManager
	{
		private static var _instance:LayoutManager;
		private var _invalidDisplayListComponents:PriorityQueue;
		private var _invalidPropertiesComponents:PriorityQueue;
		private var _invalidSizeComponents:PriorityQueue;
		private var _isInvalid:Boolean;
		private static var _singletonEnforcer:Object = {};
		private var _stage:Stage;
		private var _sizeCache:Dictionary;
		
		
		/**
		 *
		 */
		public function LayoutManager(enforcer:Object)
		{
			if (enforcer != LayoutManager._singletonEnforcer)
				throw new ArgumentError("Get an instance of the LayoutManager by using LayoutManager.getInstance()");
			
			this._sizeCache = new Dictionary(true);
			this._isInvalid = false;
			this._invalidDisplayListComponents = new PriorityQueue();
			this._invalidPropertiesComponents = new PriorityQueue();
			this._invalidSizeComponents = new PriorityQueue();
		}




		//
		// public methods
		//


		/**
		 *	
		 */
		public static function getInstance():LayoutManager
		{
			if (!LayoutManager._instance)
				LayoutManager._instance = new LayoutManager(LayoutManager._singletonEnforcer);

			return LayoutManager._instance;
		}


		/**
		 *	
		 */
		public function invalidateDisplayList(client:DisplayObject):void
		{
			this._addToInvalidQueue(this._invalidDisplayListComponents, client, this._invalidDisplayListComponentAddedToStageHandler);
		}


		/**
		 *	
		 */
		public function invalidateProperties(client:DisplayObject):void
		{
			this._addToInvalidQueue(this._invalidPropertiesComponents, client, this._invalidPropertiesComponentAddedToStageHandler);
		}


		/**
		 *	
		 */
		public function invalidateSize(client:DisplayObject):void
		{
			this._addToInvalidQueue(this._invalidSizeComponents, client, this._invalidSizeComponentAddedToStageHandler);
		}


		/**
		 *	
		 */
		public function get isInvalid():Boolean
		{
			return this._isInvalid;
		}




		//
		// private methods
		//


		/**
		 *	
		 */
		private function _addToInvalidQueue(queue:PriorityQueue, client:DisplayObject, addedToStageHandler:Function):void
		{
			if (!queue.contains(client))
			{
				// If the client is on stage, add it to the list of clients that should be validated.
				if (client.stage)
				{
					if (!this._stage)
						this._stage = client.stage;
// FIXME: If you invalidate a client and move it to a different nest level before it is validated, this may not behave as you expect.
					var nestLevel:int = this._getNestLevel(client as DisplayObject);
					queue.addObject(client, nestLevel);
					this._invalidate();
				}
				else if (addedToStageHandler != null)
				{
					client.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
				}
			}
		}


		/**
		 *	
		 */
		private function _getNestLevel(client:DisplayObject):int
		{
			var nestLevel:int;
			if (!client.stage)
			{
				nestLevel = -1;
			}
			else
			{
				nestLevel = 0;
				var tmp:DisplayObject = client;
				while ((tmp = tmp.parent))
					nestLevel++;
			}
			return nestLevel;
		}


		/**
		 *	Schedules validation for the layout.
		 */
		private function _invalidate():void
		{
			if (!this.isInvalid)
			{
				this._stage.addEventListener(Event.RENDER, this._validate, false, 0, true);
				this._stage.invalidate();
				this._isInvalid = true;
			}
		}


		/**
		 *	Called when an object that was invalidated off-stage is added to the stage.
		 */
		private function _invalidDisplayListComponentAddedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._addToInvalidQueue(this._invalidDisplayListComponents, event.currentTarget as DisplayObject, null);
		}


		/**
		 *	Called when an object that was invalidated off-stage is added to the stage.
		 */
		private function _invalidPropertiesComponentAddedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._addToInvalidQueue(this._invalidPropertiesComponents, event.currentTarget as DisplayObject, null);
		}


		/**
		 *	Called when an object that was invalidated off-stage is added to the stage.
		 */
		private function _invalidSizeComponentAddedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._addToInvalidQueue(this._invalidSizeComponents, event.currentTarget as DisplayObject, null);
		}


		/**
		 *	
		 */
		private function _validate(event:Event):void
		{
			var client:DisplayObject;
			
			// Commit phase: call validateProperties on each client in top-down order.
			while (!this._invalidPropertiesComponents.isEmpty())
			{
				client = this._invalidPropertiesComponents.removeSmallest() as DisplayObject;
				this._validateProperties(client);
			}

			// Measurement phase: call validateSize on each client in bottom-up order.
			while (!this._invalidSizeComponents.isEmpty())
			{
				client = this._invalidSizeComponents.removeLargest() as DisplayObject;
				this._validateSize(client);
			}

			// Layout phase: call validateDisplayList on each client in top-down order.
			while (!this._invalidDisplayListComponents.isEmpty())
			{
				client = this._invalidDisplayListComponents.removeSmallest() as DisplayObject;
				this._validateDisplayList(client);
			}

			// If any of our above validation caused further invalidation, validate again.
// TODO: Be vigilant about infinite recursion here.
// TODO: Maybe we shouldn't do this? According to the Flex layout manager docs: "During the processing of UIComponents in a phase, requests for UIComponents to get re-processed by some phase may occur. These requests are queued and are only processed during the next run of the phase."
			if (!this._invalidPropertiesComponents.isEmpty() || !this._invalidSizeComponents.isEmpty() || !this._invalidDisplayListComponents.isEmpty())
				this._validate(null);

			this._isInvalid = false;
		}
		
		
		/**
		 *	
		 */
		private function _validateDisplayList(client:DisplayObject):void
		{
			if (client is ILayoutManagerClient)
				ILayoutManagerClient(client).validateDisplayList();
		}


		/**
		 *	
		 */
		private function _validateProperties(client:DisplayObject):void
		{
			if (client is ILayoutManagerClient)
				ILayoutManagerClient(client).validateProperties();
		}
		

		/**
		 *	
		 */
		private function _validateSize(client:DisplayObject):void
		{
			// Only validate if the size has changed since the last validation.
			// (This means that if you invalidate multiple times, but the last
			// time the bounds are the same as before the first invalidation,
			// the object will not be validated.)
			var oldBounds:Rectangle = this._sizeCache[client];
			if (!oldBounds || client.width != oldBounds.width || client.height != oldBounds.height)
			{
				// Remember the new bounds.
				this._sizeCache[client] = new Rectangle(0, 0, client.width, client.height);
				
				if (client is ILayoutManagerClient)
					ILayoutManagerClient(client).validateSize();

				// "Bubble" invalidation up the display list.
				var tmp:DisplayObject = client.parent;
				while (tmp)
				{
					this.invalidateSize(tmp);
					this.invalidateDisplayList(tmp);
					tmp = tmp.parent;
				}
			}
		}




	}
}