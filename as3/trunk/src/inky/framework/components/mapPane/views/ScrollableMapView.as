package inky.framework.components.mapPane.views 
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import inky.framework.components.IButton;
	import inky.framework.components.mapPane.models.MapModel;
	import inky.framework.components.mapPane.views.IMapView;
	import inky.framework.components.scrollPane.views.IScrollPane;
	
	public class ScrollableMapView extends Sprite
	{
		private var __mapView:IMapView;
		private var __scrollPane:IScrollPane;
		private var _zoomInButton:DisplayObject;
		private var _zoomOutButton:DisplayObject;
		private var _enabledButton:IButton;
		private var _maximumZoom:Number;
		private var _minimumZoom:Number;
		private var _baseTween:Object;
		
		public function ScrollableMapView()
		{
			this.mapView = this.getChildByName("_mapView") as IMapView || this._checkForObject(IMapView) as IMapView;
			this.scrollPane = this.getChildByName("_scrollPane") as IScrollPane || this._checkForObject(IScrollPane) as IScrollPane;
			this.zoomInButton = this.getChildByName('_zoomInButton') as DisplayObject || null;			
			this.zoomOutButton = this.getChildByName('_zoomOutButton') as DisplayObject || null;
			this.baseTween = {transition: 'easeOutSine'};
			this.maximumZoom = 3;
			this.minimumZoom = 1;			
		}
		
		//
		// accessors
		//
		
		public function set scrollPane(scrollPane:IScrollPane):void
		{
			this.__scrollPane = scrollPane;
			
			this.__scrollPane.source = this.__mapView;
			this.__scrollPane.draggable = true;
		}
		public function get scrollPane():IScrollPane
		{
			return this.__scrollPane;
		}
		
		public function set mapView(mapView:IMapView):void
		{
			this.__mapView = mapView;
		}
		public function get mapView():IMapView
		{
			return this.__mapView;
		}
		
		public function set zoomInButton(button:DisplayObject):void
		{
			if (button)
			{
				this._zoomInButton = button;
				this._zoomInButton.addEventListener(MouseEvent.MOUSE_DOWN, this._zoomInOutHandler);
				this._zoomInButton.addEventListener(MouseEvent.MOUSE_UP, this._stopZoomHandler);	
			}
		}
		public function get zoomInButton():DisplayObject
		{
			return this._zoomInButton;
		}
		
		public function set zoomOutButton(button:DisplayObject):void
		{
			if (button)
			{
				this._zoomOutButton = button;
				this._zoomOutButton.addEventListener(MouseEvent.MOUSE_DOWN, this._zoomInOutHandler);
				this._zoomOutButton.addEventListener(MouseEvent.MOUSE_UP, this._stopZoomHandler);
			}
		}
		public function get zoomOutButton():DisplayObject
		{
			return this._zoomOutButton;
		}
		
		public function set maximumZoom(maximumZoom:Number):void
		{
			this._maximumZoom = maximumZoom;
		}
		public function get maximumZoom():Number
		{
			return this._maximumZoom;
		}
		
		public function set minimumZoom(minimumZoom:Number):void
		{
			this._minimumZoom = minimumZoom;
		}
		public function get minimumZoom():Number
		{
			return this._minimumZoom;
		}
		
		public function set baseTween(baseTween:Object):void
		{
			this._baseTween = baseTween;
		}
		public function get baseTween():Object
		{
			return this._baseTween;
		}
		
		public function set model(model:MapModel):void
		{
			this.__mapView.model = model;
		}
		public function get model():MapModel
		{
			return this.__mapView.model;
		}
		
		/**
		 *
		 */
		public function get pointViewClass():Class
		{
			return this.__mapView.pointViewClass;
		}

		/**
		 * @private
		 */
		public function set pointViewClass(pointViewClass:Class):void
		{
			this.__mapView.pointViewClass = pointViewClass;
		}
				
		//
		// private functions
		//
		
		private function _zoomInOutHandler(event:MouseEvent):void
		{	
			if (IButton(event.currentTarget))
			{
				if (this._enabledButton) this._enabledButton.enabled = false;
				this._enabledButton = IButton(event.currentTarget);
				this._enabledButton.enabled = true;
			}
			
			var time:Number;
			var mapView:DisplayObject = DisplayObject(this.mapView);
			switch (event.currentTarget as DisplayObject)
			{
				case this._zoomInButton:
					time = (this.maximumZoom - mapView.scaleX) / this.maximumZoom;
					Tweener.addTween(mapView, {scaleX: this.maximumZoom, scaleY: this.maximumZoom, time: time, base: this._baseTween});
					break;
				case this._zoomOutButton:
					time = (mapView.scaleX - this.minimumZoom) / this.minimumZoom;
					Tweener.addTween(mapView, {scaleX: this.minimumZoom, scaleX: this.minimumZoom, time: time, base: this._baseTween});
					break;
			}
		}
		
		private function _stopZoomHandler():void
		{
			Tweener.pauseTweens(this.mapView, "scaleX", "scaleY");
		}
		
		private function _checkForObject(dataType:Class):Object
		{
			var object:Object;
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:Object = this.getChildAt(i) as dataType;
				if (child)
				{
					object = child;
					break;
				}
			}
			if (!object) throw new Error("object of type " + dataType + " could not be found!");
			
			return object;
		}
	}
}