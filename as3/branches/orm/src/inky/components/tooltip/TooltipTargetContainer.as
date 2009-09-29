package inky.components.tooltip
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import inky.components.tooltip.TooltipTargetContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class TooltipTargetContainer
	{
		private var _container:DisplayObjectContainer;
		private var _tooltip:ITooltip;
		private var _triggerEvent:String;
		private var _targetFilter:Function;


		/**
		 *
		 *	
		 */
		public function TooltipTargetContainer(container:DisplayObjectContainer, tooltip:ITooltip = null)
		{
			this._container = container;
			this._tooltip = tooltip || container.getChildByName("tooltip") as ITooltip || container.getChildByName("_tooltip") as ITooltip;
			this.triggerEvent = MouseEvent.MOUSE_OVER;
		}


		/**
		 *
		 *
		 *
		 */
		public function get targetFilter():Function
		{
			return this._targetFilter;
		}
		/**
		 * @private
		 */
		public function set targetFilter(value:Function):void
		{
			this._targetFilter = value;
		}


		/**
		 *
		 *
		 *
		 */
		public function get tooltip():ITooltip
		{
			return this._tooltip;
		}


		/**
		 *
		 *
		 *
		 */
		public function get triggerEvent():String
		{
			return this._triggerEvent;
		}
		/**
		 * @private
		 */
		public function set triggerEvent(value:String):void
		{
			if (value != this._triggerEvent)
			{
				if (this._triggerEvent)
					this._container.removeEventListener(this._triggerEvent, this._triggerHandler);
				if (value)
					this._container.addEventListener(value, this._triggerHandler);
				this._triggerEvent = value;
			}
		}



		private function _triggerHandler(e:Event):void
		{
			var target:InteractiveObject = e.target as InteractiveObject;
			if (this.tooltip && (!(this.targetFilter) || this.targetFilter(target)))
			{
				this.tooltip.target = target;
				this.tooltip.show();
			}
		}

		
		
	}
}