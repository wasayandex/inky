package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.MaskedMapViewHelper;
	import inky.components.map.view.IMap;
	import flash.geom.Rectangle;
	import inky.utils.IDestroyable;
	import inky.components.map.view.events.MapEvent;
	import inky.dragAndDrop.Draggable;
	import inky.dragAndDrop.DraggableCursors;
	
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
		private var draggable:Draggable;
		private var _panningProxy:Object;
		
		/**
		 * @copy inky.components.map.view.helpers.MaskedMapViewHelper
		 */
		public function PanningHelper(map:IMap, panningProxy:Object = null)
		{
			super(map);
			this.panningProxy = panningProxy;
			this.draggable = new Draggable(this.contentContainer, false, this.getDragBounds());
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
			if (value != this._panningProxy)
			{
				this._panningProxy = value;
				this.draggable.positionProxy = value ? new DragProxy(value) : null;
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
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
		override public function onOverlayUpdated():void
		{
			this.draggable.bounds = this.getDragBounds();
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

	}
	
}


class DragProxy
{
	private var proxiedObject:Object;
	
	/**
	 *
	 */
	public function DragProxy(proxiedObject:Object)
	{
		this.proxiedObject = proxiedObject;
	}
	
	/**
	 * 
	 */
	public function set x(value:Number):void
	{
		this.proxiedObject.contentX = value;
	}
	/**
	 * @private
	 */
	public function get x():Number
	{
		return this.proxiedObject.contentX;
	}
	
	/**
	 * 
	 */
	public function set y(value:Number):void
	{
		this.proxiedObject.contentY = value;
	}
	/**
	 * @private
	 */
	public function get y():Number
	{
		return this.proxiedObject.contentY;
	}
}