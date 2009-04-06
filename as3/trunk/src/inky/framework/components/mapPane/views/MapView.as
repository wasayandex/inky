package inky.framework.components.mapPane.views
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import inky.framework.components.ITooltip;
	import inky.framework.components.mapPane.views.IMapView;
	import inky.framework.components.mapPane.models.MapModel;
	
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
		private var _source:Object;
		private var _content:MovieClip;
		private var __mask:DisplayObject;
		private var _model:MapModel;
		private var _pointViewClass:Class;
		private var __tooltip:ITooltip;
		private var _referencePoint:Point;
		private var _topRightCorner:Point;
		private var _bottomRightCorner:Point;
		private var _bottomLeftCorner:Point;
		
		public function MapView()
		{					
			this.source = this.getChildByName('_mapContainer') as DisplayObject || null;
			this.__tooltip = this.getChildByName('_tooltip') as ITooltip || null;
		}
		
		//
		// accessors
		//
				
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

		
		/**
		*	
		*/
		public function get model():MapModel
		{
			return this._model;
		}
		
		/**
		 * @private
		 */
		public function set model(model:MapModel):void
		{
			this._model = model;
			this.setContent();
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
		public function get topLeftCornner():Point
		{
			return this._referencePoint || new Point();
		}

		//
		// protected functions
		//
				
		/**
		*	
		*/
		protected function setContent():void
		{
			for (var i:int = 0; i < this.model.getPointModels().length; i++)
			{
				var itemView:Object = new this._pointViewClass();
				var model:Object = this.model.getPointModels().getItemAt(i);
				model.x += this.topLeftCornner.x;
				model.y += this.topLeftCornner.y;
				
				itemView.model = model;
				
				if (this.__tooltip)
				{
					InteractiveObject(itemView).addEventListener(MouseEvent.ROLL_OVER, this._pointMouseHandler);
					InteractiveObject(itemView).addEventListener(MouseEvent.ROLL_OUT, this._pointMouseHandler);
				}
				this.source.addChild(itemView as InteractiveObject);
			}
		}				
		
		//
		// private functions
		//
		
		private function _pointMouseHandler(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.ROLL_OVER:
					this.__tooltip.target = event.currentTarget as InteractiveObject;
					this.__tooltip.show();
					break;
				case MouseEvent.ROLL_OUT:
					this.__tooltip.hide();
					break;
			}
		}
	}
}