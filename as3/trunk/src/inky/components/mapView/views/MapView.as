package inky.components.mapView.views
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import inky.collections.IList;
	import inky.components.tooltip.ITooltip;
	import inky.components.mapView.views.IMapView;
	
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
	 */
	public class MapView extends Sprite implements IMapView
	{
		private var __tooltip:ITooltip;
		private var _autoAdjustChildren:Boolean;
		private var _bottomLeftPoint:Point;
		private var _bottomRightPoint:Point;
		private var _container:Sprite;
		private var _model:IList
		private var _pointViewClass:Class;
		private var _topLeftPoint:Point;
		private var _topRightPoint:Point;
		private var _source:DisplayObject;
		
		public function MapView()
		{
			this._autoAdjustChildren = true;					
			this._container = new Sprite();
			this.addChild(this._container);
			
			this.source = this.getChildByName('_mapContainer') as Sprite || null;
			this.__tooltip = this.getChildByName('_tooltip') as ITooltip || null;			
		}
		
		//
		// accessors
		//
		
		public function set autoAdjustChildren(value:Boolean):void
		{
			this._autoAdjustChildren = value;
		}
		
		/**
		*	@inhertDoc
		*/
		public function get model():IList
		{
			return this._model;
		}
		public function set model(value:IList):void
		{
			this._model = value;
			this._setContent();
		}
						
		/**
		*	@inhertDoc
		*/
		public function get pointViewClass():Class
		{
			return this._pointViewClass;
		}
		public function set pointViewClass(value:Class):void
		{
			this._pointViewClass = value;
		}

		/**
		*	
		*/
		public function set bottomLeftPoint(value:Point):void
		{
			this._bottomLeftPoint = value;
		}
		public function get bottomLeftPoint():Point
		{
			return this._bottomLeftPoint = this._bottomLeftPoint || new Point(0, this._source.height);
		}
		
		/**
		*	
		*/
		public function set bottomRightPoint(value:Point):void
		{
			this._bottomRightPoint = value;
		}
		public function get bottomRightPoint():Point
		{
			return this._bottomRightPoint = this._bottomRightPoint || new Point(this._source.width, this._source.height);
		}

/**
*	@inheritDoc	
*/
override public function set scaleX(value:Number):void
{
	if (this._autoAdjustChildren)
	{
		var scaleDifference:Number = (this.scaleX - value);
		this._adjustScale("scaleX", scaleDifference);
	}
	super.scaleX = value;
}
override public function set scaleY(value:Number):void
{
	if (this._autoAdjustChildren)
	{
		var scaleDifference:Number = (this.scaleY - value);
		this._adjustScale("scaleY", scaleDifference);
	}
	super.scaleY = value;
}
		
		/**
		*	@inheritDoc
		*/
		public function set source(value:DisplayObject):void
		{
			if (value)
			{
				this._source = value;
				this._container.addChild(this._source);
			}
		}
		public function get source():DisplayObject
		{
			return this._source;
		}		
		
		/**
		*	
		*/
		public function set topLeftPoint(value:Point):void
		{
			this._topLeftPoint = value;
		}
		public function get topLeftPoint():Point
		{
			return this._topLeftPoint = this._topLeftPoint || new Point(0, 0);
		}
		
		/**
		*	
		*/
		public function set topRightPoint(value:Point):void
		{
			this._topRightPoint = value;
		}
		public function get topRightPoint():Point
		{
			return this._topRightPoint = this._topRightPoint || new Point(this._source.width, 0);
		}
		
		//
		// public functions
		//
			
		/**
		*	@inheritDoc
		*/
		public function getPointByModel(value:Object):DisplayObject
		{
			var point:Object;
			var length:int = this._container.numChildren;
			for (var i:int = 0; i < length; i++)
			{
				var child:Object = this._container.getChildAt(i) as Object;
				if (child && child.hasOwnProperty("model") && child.model == value) point = child;
			}
			
			return point as DisplayObject;
		}
		
		/**
		*	@inheritDoc
		*/
		public function showPointByModel(value:Object):void
		{
		}
		
		//
		// protected functions
		//
		
		protected function getTooltip():ITooltip
		{
			return this.__tooltip;
		}
		
		//
		// private functions
		//
		
		/**
		*	Adjusts the scale of map points and tooltip
		*	
		* 	@param value
		*		The value of the property, scaleX or scaleY, to adjust.	
		*/
		private function _adjustScale(property:String, scaleDifference:Number):void
		{
			var length:Number = this._container.numChildren;
			var scale:Number;
			for (var i:Number = 0; i < length; i++)
			{
				var child:Object = this._container.getChildAt(i) as Object;
				if (child && child is this._pointViewClass)
				{
					scale = child[property] + scaleDifference;
					if (scale < .5) scale = .5;
					else if (scale > 1) scale = 1;
					
					child[property] = scale;
				}
			}
			if (this.__tooltip)
			{
				scale = this.__tooltip[property] + scaleDifference;
				if (scale < .5) scale = .5;
				else if (scale > 1) scale = 1;
				
				this.__tooltip[property] = scale;
			}
		}
		
		/**
		*	@private
		*/
		private function _pointMouseHandler(event:MouseEvent):void
		{
			if (!(event.target is this._pointViewClass)) return;
			
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
		*	@private
		*/
		private function _setContent():void
		{
			if (!this._pointViewClass) throw new Error("A PointViewClass is not set!");
			if (!this._source) throw new Error("A source for MapView is not set!");
			
			var longitudeDifference:Number = Math.abs(this.topLeftPoint.x - this.topRightPoint.x);
			var lattitudeDifference:Number = Math.abs(this.bottomLeftPoint.y - this.topLeftPoint.y);
			
			var length:int = this.model.length;
			for (var i:int = 0; i < length; i++)
			{
				var pointView = new this._pointViewClass();
				var model:Object = this.model.getItemAt(i);

				if (model.hasOwnProperty("x"))
				{
					if (this.topLeftPoint.x == 0)
					{
				 		pointView.x = Number(model.x);
					}
					else
					{
						pointView.x = Math.abs((Number(model.x) - this.topLeftPoint.x) / longitudeDifference) * this._source.width;
					}
				}
				
				if (model.hasOwnProperty("y")) 
				{
					if (this.topLeftPoint.y == 0)
					{
						pointView.y = Number(model.y);
					}
					else
					{
						pointView.y = Math.abs((Number(model.y) - this.topLeftPoint.y) / lattitudeDifference) * this._source.height;
					}
				}

				if (pointView.hasOwnProperty("model"))
					pointView.model = model;
				
				this._container.addChild(pointView);
			}
			
			if (this.__tooltip)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, this._pointMouseHandler);
				this.addEventListener(MouseEvent.MOUSE_OUT, this._pointMouseHandler);
			}
		}		
	}
}