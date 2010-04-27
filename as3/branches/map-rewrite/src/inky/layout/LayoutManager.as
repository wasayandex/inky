package inky.layout 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import inky.layout.ILayoutManagerClient;
	import flash.events.Event;
	import inky.layout.utils.PriorityQueue;
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
		private var _invalidComponents:PriorityQueue;
		private static var _singletonEnforcer:Object = {};
		private var _stage:Stage;
		private var _isInvalid:Boolean;
		
		
		/**
		 *
		 */
		public function LayoutManager(enforcer:Object)
		{
			if (enforcer != LayoutManager._singletonEnforcer)
				throw new ArgumentError("Get an instance of the LayoutManager by using LayoutManager.getInstance()");
			
			this._invalidComponents = new PriorityQueue();
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

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
		public function invalidateLayout(client:ILayoutManagerClient):void
		{
			var queue:PriorityQueue = this._invalidComponents;
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
				else
				{
					client.addEventListener(Event.ADDED_TO_STAGE, this._invalidComponentAddedToStageHandler, false, 0, true);
				}
			}
		}

		/**
		 * 
		 */
		public function invalidateParentLayout(target:DisplayObject):void
		{
			var parent:ILayoutManagerClient = target.parent as ILayoutManagerClient;
			if (parent)
				this.invalidateLayout(parent);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

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
			if (!this._isInvalid)
			{
				this._stage.addEventListener(Event.RENDER, this._validateAll, false, 0, true);
				// Also Listen to ENTER_FRAME to compensate for the comboBox component's tendency to hijack the RENDER event.
				this._stage.addEventListener(Event.ENTER_FRAME, this._validateAll, false, 0, true);
				this._stage.invalidate();
				this._isInvalid = true;
			}
		}

		/**
		 *	Called when an object that was invalidated off-stage is added to the stage.
		 */
		private function _invalidComponentAddedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.invalidateLayout(event.currentTarget as ILayoutManagerClient);
		}

		/**
		 *	
		 */
		private function _validateAll(event:Event):void
		{
			var client:DisplayObject;

			this._stage.removeEventListener(Event.RENDER, this._validateAll);
			this._stage.removeEventListener(Event.ENTER_FRAME, this._validateAll);

// TODO: Be vigilant about infinite recursion here.			
			while (!this._invalidComponents.isEmpty)
			{
				client = this._invalidComponents.removeLargest() as DisplayObject;
				this._validateLayout(client);
			}

			this._isInvalid = false;
		}
		
		/**
		 *	
		 */
		private function _validateLayout(client:DisplayObject):void
		{
			if (client is ILayoutManagerClient)
				ILayoutManagerClient(client).validateLayout();
		}

	}
}