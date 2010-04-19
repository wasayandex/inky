package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.MaskedMapViewHelper;
	import inky.components.map.view.IMap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import inky.utils.IDestroyable;
	import inky.components.map.view.events.MapEvent;
	
	/**
	 *
	 *  An IMap view helper that provides basic 'panning' (or 'dragging') functionality.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.12
	 *
	 */
	public class PanningHelper extends MaskedMapViewHelper implements IDestroyable
	{
		private var _panningProxy:Object;
		private var startDragPosition:Point;
		
		/**
		 * @copy inky.components.map.view.helpers.MaskedMapViewHelper
		 */
		public function PanningHelper(map:IMap, panningProxy:Object = null)
		{
			super(map);

			this.panningProxy = panningProxy;
			this.contentContainer.addEventListener(MouseEvent.MOUSE_DOWN, this.content_mouseDownHandler);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * An object that stands in for the contentContainer in panning manipulation methods.
		 * For example, setting this value to a GTween proxy will let you have easing pretty easily.
		 * 
		 * @default null
		 */
		public function get panningProxy():Object
		{ 
			return this._panningProxy; 
		}
		/**
		 * @private
		 */
		public function set panningProxy(value:Object):void
		{
			this._panningProxy = value;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			this.contentContainer.removeEventListener(MouseEvent.MOUSE_DOWN, this.content_mouseDownHandler);
			this.contentContainer.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
			this.contentContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		}
		
		/**
		 * Moves the map content.
		 * 
		 * @param x
		 *     The x coordinate to which the content should be moved
		 * @param y
		 *     The y coordinate to which the content should be moved		 		 		 		 		 		 		 
		 */
		public function moveContent(x:Number, y:Number):void
		{
			var obj:Object = this.panningProxy || this.map;

			if (obj.contentX != x)
				obj.contentX = x;
			
			if (obj.contentY != y)
				obj.contentY = y;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			super.reset();
			
			if (this.panningProxy)
			{
				this.panningProxy.contentX = this.contentX;
				this.panningProxy.contentY = this.contentY;
			}	
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function validate():void
		{
			var positionIsInvalid:Boolean = this.validationState.propertyIsInvalid("contentX") || this.validationState.propertyIsInvalid("contentY");
			super.validate();
			
			if (positionIsInvalid)
			{
				var dragBounds:Rectangle = this.getDragBounds();
				this.contentContainer.x = Math.max(Math.min(dragBounds.right, this.contentX), dragBounds.left);
				this.contentContainer.y = Math.max(Math.min(dragBounds.bottom, this.contentY), dragBounds.top);
				this.content.dispatchEvent(new MapEvent(MapEvent.MOVE));
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function content_mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget == this.contentContainer)
				this.startMapDrag();
		}
		
		/**
		 * 
		 */
		private function stage_mouseMoveHandler(event:MouseEvent):void
		{
			this.updateMapDrag();
		}

		/**
		 * 
		 */
		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			this.stopMapDrag();
		}
		
		/**
		 * Starts monitoring mouse movement.
		 */
		private function startMapDrag():void
		{
			this.startDragPosition = new Point(this.content.mouseX - this.contentContainer.x, this.content.mouseY - this.contentContainer.y);
			this.contentContainer.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
			this.contentContainer.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		}
		
		/**
		 * Stops monitoring mouse movement.
		 */
		private function stopMapDrag():void
		{
			this.contentContainer.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
			this.contentContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		}

		/**
		 * Updates the content based on mouse position.
		 */
		private function updateMapDrag():void
		{
			var x:Number = this.content.mouseX - this.startDragPosition.x;
			var y:Number = this.content.mouseY - this.startDragPosition.y;

			var dragBounds:Rectangle = this.getDragBounds();
			x = Math.max(Math.min(x, dragBounds.x + dragBounds.width), dragBounds.x);
			y = Math.max(Math.min(y, dragBounds.y + dragBounds.height), dragBounds.y);
			
			this.moveContent(x, y);
		}

	}
	
}