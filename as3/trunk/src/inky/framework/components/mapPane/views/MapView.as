package inky.framework.components.mapPane.views
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import inky.framework.collections.IList;
	import inky.framework.components.tooltip.ITooltip;
	import inky.framework.components.mapPane.views.IMapView;
	import inky.framework.components.mapPane.views.IPointView;
	import inky.framework.components.mapPane.models.PointModel;
	
	/**
	 *
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	
	 *	TODO: Add support for corners and/ or long/lat support
	 *	
	 */
	public class MapView extends Sprite implements IMapView
	{
		private var __mask:DisplayObject;
		private var __tooltip:ITooltip;
		private var _bottomRightCorner:Point;
		private var _bottomLeftCorner:Point;
		private var _content:MovieClip;
		private var _model:IList
		private var _pointViewClass:Class;
		private var _referencePoint:Point;
		private var _source:Object;
		private var _topRightCorner:Point;
		
		public function MapView()
		{					
			this.source = this.getChildByName('_mapContainer') as DisplayObject || null;
			this.__tooltip = this.getChildByName('_tooltip') as ITooltip || null;
		}
		
		//
		// accessors
		//
		
		/**
		*	
		*/
		public function get model():IList
		{
			return this._model;
		}
		
		/**
		 * @private
		 */
		public function set model(model:IList):void
		{
			this._model = model;
			this._setContent();
		}
						
		/**
		 *
		 */
		public function get pointViewClass():Class
		{
			return this._pointViewClass;
		}

		/**
		 * @private
		 */
		public function set pointViewClass(pointViewClass:Class):void
		{
			this._pointViewClass = pointViewClass;
		}


		public function set referencePoint(point:Point):void
		{
			this._referencePoint = point;
		}
		public function get referencePoint():Point
		{
			return !this._referencePoint ? this._referencePoint = new Point() : this._referencePoint;
		}
		
		/**
		*	@inheritDoc
		*/
		public function set source(source:Object):void
		{
			if (!source) return;
			
			if (!(source is DisplayObject))
			{
				throw new Error("MapPane currently only supports MovieClips as it's source.");
			}
			else
			{
				this._source = source as DisplayObject;
				this._source.mask = this.__mask;
			}
		}

		/**
		*	@inheritDoc
		*/
		public function get source():Object
		{
			return this._source;
		}		
		
		
		//
		// public functions
		//
		
		public function getPointByModel(model:PointModel):IPointView
		{
			var pointView:IPointView;
			var length:int = this.source.numChildren;
			for (var i:int = 0; i < length; i++)
			{
				var child:IPointView = this.source.getChildAt(i) as IPointView;
				if (child && child.model == model) pointView = child;
			}
			
			return pointView;
		}
		
		//
		// private functions
		//
		
		/**
		*	
		*/
		private function _pointMouseHandler(event:MouseEvent):void
		{
			if (!(event.target is IPointView)) return;
			
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER:
					this.__tooltip.target = event.target as InteractiveObject;
					this.__tooltip.show();
					break;
				case MouseEvent.MOUSE_OUT:
					this.__tooltip.hide();
					break;
			}
		}
				
		/**
		*	
		*/
		private function _setContent():void
		{
			if (!this._pointViewClass) throw new Error("A PointViewClass is not set!");
			
			var length:int = this.model.length;
			for (var i:int = 0; i < length; i++)
			{
				var pointView = new this._pointViewClass();
				var model:Object = this.model.getItemAt(i);

				if (model.x) model.x += this.referencePoint.x;
				if (model.y) model.y += this.referencePoint.y;
				
				pointView.model = model;				
				this.source.addChild(pointView);
			}
			
			if (this.__tooltip)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, this._pointMouseHandler);
				this.addEventListener(MouseEvent.MOUSE_OUT, this._pointMouseHandler);
			}
		}		
	}
}