package inky.components.map.view.helpers 
{
	
	public class DragProxy
	{
		private var proxiedObject:Object;
		private var draggable:Object;

		/**
		 *
		 */
		public function DragProxy(proxiedObject:Object, draggable:Object)
		{
			this.proxiedObject = proxiedObject;
			this.draggable = draggable;
		}

		/**
		 * 
		 */
		public function set x(value:Number):void
		{
			this.proxiedObject.horizontalPan = PanHelper.toHorizontalPan(value);
		}
		/**
		 * @private
		 */
		public function get x():Number
		{
			return PanHelper.toXPosition(this.proxiedObject.horizontalPan);
		}

		/**
		 * 
		 */
		public function set y(value:Number):void
		{
			this.proxiedObject.verticalPan = PanHelper.toVerticalPan(value);
		}
		/**
		 * @private
		 */
		public function get y():Number
		{
			return PanHelper.toYPosition(this.proxiedObject.verticalPan);
		}
	}
}
