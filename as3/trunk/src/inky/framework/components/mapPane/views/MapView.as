package inky.framework.components.mapPane.views
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import inky.framework.collections.IList;
	import inky.framework.components.tooltip.ITooltip;
	import inky.framework.components.mapPane.views.IMapView;
	import inky.framework.components.mapPane.views.IPointView;
	
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
		private var _model:IList
		private var _pointViewClass:Class;
		private var _referencePoint:Point;
		private var _source:Sprite;
		
		public function MapView()
		{
			this._autoAdjustChildren = true;					
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
		*	@inhertDoc
		*/
		public function set referencePoint(value:Point):void
		{		
			this._referencePoint = value;
		}
		public function get referencePoint():Point
		{
			return !this._referencePoint ? this.referencePoint = new Point() : this._referencePoint;
		}
	
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
		public function set source(value:Sprite):void
		{
			this._source = value;
		}
		public function get source():Sprite
		{
			return this._source;
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
			var length:int = this.source.numChildren;
			for (var i:int = 0; i < length; i++)
			{
				var child:Object = this.source.getChildAt(i) as Object;
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
			var length:Number = this.source.numChildren;
			var scale:Number;
			for (var i:Number = 0; i < length; i++)
			{
				var child:Object = this.source.getChildAt(i) as Object;
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
		*	@private
		*/
		private function _setContent():void
		{
			if (!this._pointViewClass) throw new Error("A PointViewClass is not set!");
			
			var length:int = this.model.length;
			for (var i:int = 0; i < length; i++)
			{
				var pointView = new this._pointViewClass();
				var model:Object = this.model.getItemAt(i);

				if (model.x) model.x = Number(model.x) + this.referencePoint.x;
				if (model.y) model.y = Number(model.y) + this.referencePoint.y;
						
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