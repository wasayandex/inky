package inky.layout 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import inky.layout.LayoutComponent;
	import flash.events.Event;
	import inky.layout.PriorityQueue;


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
	public class LayoutEngine
	{
		private static var _instance:LayoutEngine;
		private var _invalidDisplayListComponents:PriorityQueue;
		private var _invalidPropertiesComponents:PriorityQueue;
		private var _invalidSizeComponents:PriorityQueue;
		private var _isInvalid:Boolean;
		private static var _singletonEnforcer:Object = {};
		private var _stage:Stage;
		
		
		/**
		 *
		 */
		public function LayoutEngine(enforcer:Object)
		{
			if (enforcer != LayoutEngine._singletonEnforcer)
				throw new ArgumentError("Get an instance of the LayoutEngine by using LayoutEngine.getInstance()");
				
			this._isInvalid = false;
			this._invalidDisplayListComponents = new PriorityQueue();
			this._invalidPropertiesComponents = new PriorityQueue();
			this._invalidSizeComponents = new PriorityQueue();
		}


// TODO: stage should not be an argument. it should be discovered automatically like with LayoutUtil.
		public static function getInstance(stage:Stage = null):LayoutEngine
		{
			if (!LayoutEngine._instance)
				LayoutEngine._instance = new LayoutEngine(LayoutEngine._singletonEnforcer);
if (stage)
LayoutEngine._instance._stage = stage;
			return LayoutEngine._instance;
		}




		public function get isInvalid():Boolean
		{
			return this._isInvalid;
		}




		private function _addToInvalidQueue(queue:PriorityQueue, component:LayoutComponent, addedToStageHandler:Function):void
		{
			if (!queue.contains(component))
			{
// FIXME: If you invalidate a component and move it to a different nest level before it is validated, this may not behave as you expect.
				var nestLevel:int = this._getNestLevel(component);

				// If the component is on stage, add it to the list of components that should be validated.
				if (nestLevel != -1)
				{
					queue.addObject(component, nestLevel);
					this._invalidate();
				}
				else if (addedToStageHandler)
				{
					component.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
				}
			}
		}


		/**
		 *	Called when an object that was invalidated off-stage is added to the stage.
		 */
		private function _invalidPropertiesComponentAddedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._addToInvalidQueue(this._invalidPropertiesComponents, event.currentTarget as LayoutComponent, null);
		}


		/**
		 *	Called when an object that was invalidated off-stage is added to the stage.
		 */
		private function _invalidSizeComponentAddedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._addToInvalidQueue(this._invalidSizeComponents, event.currentTarget as LayoutComponent, null);
		}


		/**
		 *	Called when an object that was invalidated off-stage is added to the stage.
		 */
		private function _invalidDisplayListComponentAddedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._addToInvalidQueue(this._invalidDisplayListComponents, event.currentTarget as LayoutComponent, null);
		}






		/**
		 *	
		 */
		public function invalidateDisplayList(component:LayoutComponent):void
		{
			this._addToInvalidQueue(this._invalidDisplayListComponents, component, this._invalidDisplayListComponentAddedToStageHandler);
		}


		/**
		 *	
		 */
		public function invalidateProperties(component:LayoutComponent):void
		{
			this._addToInvalidQueue(this._invalidPropertiesComponents, component, this._invalidPropertiesComponentAddedToStageHandler);
		}


		/**
		 *	
		 */
		public function invalidateSize(component:LayoutComponent):void
		{
			this._addToInvalidQueue(this._invalidSizeComponents, component, this._invalidSizeComponentAddedToStageHandler);
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




		private function _validate(event:Event):void
		{
			// Commit phase: call validateProperties on each component in top-down order.
			while (!this._invalidPropertiesComponents.isEmpty())
				this._invalidPropertiesComponents.removeSmallest().validateProperties();

			// Measurement phase: call validateSize on each component in bottom-up order.
			while (!this._invalidSizeComponents.isEmpty())
			{
				var component:LayoutComponent = this._invalidSizeComponents.removeLargest() as LayoutComponent;
				component.validateSize();
// TODO: This should still "bubble" through non-LayoutComponents somehow 
// TODO: Is there any way to stop the "bubbling" if the component doesn't actually change size?

				if (component.parent is LayoutComponent)
				{
					this.invalidateSize(component.parent as LayoutComponent);
					this.invalidateDisplayList(component.parent as LayoutComponent);
				}
			}

			// Layout phase: call validateDisplayList on each component in top-down order.
			while (!this._invalidDisplayListComponents.isEmpty())
				this._invalidDisplayListComponents.removeSmallest().validateDisplayList();

			// If any of our above validation caused further invalidation, validate again.
// TODO: Be vigilant about infinite recursion here.
// TODO: Maybe we shouldn't do this? According to the Flex layout manager docs: "During the processing of UIComponents in a phase, requests for UIComponents to get re-processed by some phase may occur. These requests are queued and are only processed during the next run of the phase."
			if (!this._invalidPropertiesComponents.isEmpty() || !this._invalidSizeComponents.isEmpty() || !this._invalidDisplayListComponents.isEmpty())
				this._validate(null);

			this._isInvalid = false;
		}




		private function _getNestLevel(component:DisplayObject):int
		{
			var nestLevel:int;
			if (!component.stage)
			{
				nestLevel = -1;
			}
			else
			{
				nestLevel = 0;
				var tmp:DisplayObject = component;
				while ((tmp = tmp.parent))
					nestLevel++;
			}
			return nestLevel;
		}




	}
}