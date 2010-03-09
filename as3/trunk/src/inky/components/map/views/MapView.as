package inky.components.map.views
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import inky.collections.IList;
	import inky.components.tooltip.ITooltip;
	import inky.components.map.views.IMapView;

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
		private var _south:Point;
		private var _east:Point;
		private var _container:Sprite;
		private var _latLonBox:Object;
		private var _model:IList
		private var _mouseEventType:String;
		private var _pointViewClass:Class;
		private var _north:Point;
		private var _west:Point;
		private var _source:DisplayObject;

		public function MapView()
		{
			this._autoAdjustChildren = true;
			this._container = new Sprite();
			this.addChild(this._container);

			this._mouseEventType = MouseEvent.MOUSE_OVER;
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
		*	@inheritDoc
		*/
		public function get latLonBox():Object
		{
			return this._latLonBox;
		}
		public function set latLonBox(value:Object):void
		{
			this._latLonBox = value;
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
		*	Determines what type of MouseEvent should the tooltip appear. By Default this
		*	is set to MouseEvent.MOUSE_OVER.
		*/
		public function set mouseEventType(value:String):void
		{
			this._mouseEventType = value;
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
				this._container.addChildAt(this._source, 0);
			}
		}
		public function get source():DisplayObject
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

		protected function hideTooltip():void
		{
			this.__tooltip.hide();
		}

		protected function showTooltip(target:InteractiveObject):void
		{
			this.__tooltip.target = target;
			this.__tooltip.show();
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
				case MouseEvent.CLICK:
					this.showTooltip(event.target as InteractiveObject);
					break;
				case MouseEvent.MOUSE_OUT:
					this.hideTooltip();
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

			var pointView;
			var model:Object;
			var longitudeDifference:Number = Math.abs(this.latLonBox.west) - Math.abs(this.latLonBox.east);
			var lattitudeDifference:Number = Math.abs(this.latLonBox.north) - Math.abs(this.latLonBox.south);

			var length:int = this.model.length;
			for (var i:int = 0; i < length; i++)
			{
				pointView = new this._pointViewClass();
				model = this.model.getItemAt(i);

				if (model.coordinates.long != 0)
					pointView.x = ((Math.abs(this.latLonBox.west) - Math.abs(model.coordinates.long)) / longitudeDifference) * this._source.width;
					
				if (model.coordinates.lat != 0)
					pointView.y = ((Math.abs(this.latLonBox.north) - Math.abs(model.coordinates.lat)) / lattitudeDifference) * this._source.height;

				if (model.hasOwnProperty("offSet"))
				{
					pointView.x += model.offSet.x;
					pointView.y += model.offSet.y;
				}

				if (pointView.hasOwnProperty("model"))
					pointView.model = model;

				this._container.addChild(pointView);
			}

			if (this.__tooltip)
			{
				this._container.addChild(this.__tooltip as Sprite);
				this.addEventListener(this._mouseEventType, this._pointMouseHandler);

				if (this._mouseEventType == MouseEvent.MOUSE_OVER)
					this.addEventListener(MouseEvent.MOUSE_OUT, this._pointMouseHandler);
			}
		}
	}
}
