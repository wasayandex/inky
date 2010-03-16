package inky.components.map.views 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import inky.collections.IList;
	import inky.components.IButton;
	import inky.components.map.views.IMapView;
	import inky.components.map.views.IScrollableMapView;
	import inky.components.scrollPane.views.IScrollPane;
	import inky.display.utils.scale;
	
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
	public class ScrollableMapView extends Sprite implements IScrollableMapView
	{
		private var __mapView:IMapView;
		private var __scrollPane:IScrollPane;
		private var _enabledButton:IButton;
		private var _maximumZoom:Number;
		private var _minimumZoom:Number;
		private var _zoomInButton:DisplayObject;
		private var _zoomInterval:Number;
		private var _zoomOutButton:DisplayObject;
		private var _zoomState:String;
		
		public function ScrollableMapView()
		{
			this._init();
		}
		
		//
		// accessors
		//
		
		/**
		*	@inheritDoc
		*/	
		public function get latLonBox():Object
		{
			return this.__mapView.latLonBox;
		}
		public function set latLonBox(value:Object):void
		{
			this.__mapView.latLonBox = value;
		}
			
		/**
		 * @inheritDoc
		 */
		public function set maximumZoom(value:Number):void
		{
			this._maximumZoom = value;
		}
		public function get maximumZoom():Number
		{
			return this._maximumZoom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minimumZoom(value:Number):void
		{
			this._minimumZoom = value;
		}
		public function get minimumZoom():Number
		{
			return this._minimumZoom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set model(value:IList):void
		{
			this.__mapView.model = value;
		}
		public function get model():IList
		{
			return this.__mapView.model;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get pointViewClass():Class
		{
			return this.__mapView.pointViewClass;
		}
		public function set pointViewClass(value:Class):void
		{
			this.__mapView.pointViewClass = value;
		}
		
		/**
		*	@inheritDoc	
		*/
		public function get source():DisplayObject
		{
			return this.__mapView.source;
		}
		public function set source(value:DisplayObject):void
		{
			this.__mapView.source = value;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function set zoomInButton(value:DisplayObject):void
		{
			if (value)
			{
				this._zoomInButton = value;
				this._zoomInButton.addEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
				this._zoomInButton.addEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);	
			}
		}
		public function get zoomInButton():DisplayObject
		{
			return this._zoomInButton;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set zoomOutButton(value:DisplayObject):void
		{
			if (value)
			{
				this._zoomOutButton = value;
				this._zoomOutButton.addEventListener(MouseEvent.MOUSE_DOWN, this._mouseDownHandler);
				this._zoomOutButton.addEventListener(MouseEvent.MOUSE_UP, this._mouseUpHandler);
			}
		}
		public function get zoomOutButton():DisplayObject
		{
			return this._zoomOutButton;
		}
		
		//
		// public functions
		//
		
		/**
		*	Shows the point on the map based on the model object passed as the parameter.
		*	
		*	@param value
		*		The model object of the point to show.
		*/
		public function showPointByModel(value:Object):void
		{
			var point:DisplayObject = this.__mapView.getPointByModel(value);	
			if (point)
			{
				var contentContainer:DisplayObject = this.getScrollPaneContentContainer();	
				var containerMask:DisplayObject = contentContainer.mask;
				var percentX:Number = point.x / point.parent.width;
				var percentY:Number = point.y / point.parent.height;
				var x:int = (contentContainer.width * percentX) - (containerMask.width * .5);
				var y:int = (contentContainer.height * percentY) - (containerMask.height * .5);
		
				this.__scrollPane.horizontalScrollPosition = x;
				this.__scrollPane.verticalScrollPosition = y;
			}
	
			this.__mapView.showPointByModel(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPointByModel(value:Object):DisplayObject
		{
			return this.__mapView.getPointByModel(value);
		}
		
		//
		// protected functions
		//
		
		protected function getMapView():IMapView
		{
			return this.__mapView;
		}
		protected function getScrollPaneContentContainer():DisplayObject
		{
			return this.__scrollPane.source.parent as DisplayObject;
		}
		protected function getScrollPane():IScrollPane
		{
			return this.__scrollPane;
		}
		
		/**
		*	Scales the mapView container based on the values of the scaleX and scaleY parameters.
		*	
		*	@param scaleX
		*	@param scaleY	
		*/
		protected function scaleContent(scaleX:Number, scaleY:Number):void
		{
			var contentContainer:DisplayObject = this.getScrollPaneContentContainer();			
			
			//Scale the container for the MapView according to the center of the View Port (scrollpane)
			var percentX:Number = (-contentContainer.x + contentContainer.mask.width * .5) / contentContainer.width;
			var percentY:Number = (-contentContainer.y + contentContainer.mask.height * .5) / contentContainer.height;
			var point:Point = new Point(int(contentContainer.width * percentX), int(contentContainer.height * percentY));
			
			scale(contentContainer, [scaleX, scaleY], point);

			//Scale MapView along with it's children to keep everything in proportion
			var mapView:Object = this.__mapView as Object;
			mapView.adjustChildren([scaleX, scaleY]);

			this.__scrollPane.update();
			this.__scrollPane.horizontalScrollPosition = Math.abs(int(contentContainer.x));
			this.__scrollPane.verticalScrollPosition = Math.abs(int(contentContainer.y));
		}

		//
		// private functions
		//

		/**
		*	Initialize tons of stuff for fun.	
		*/
		private function _init():void
		{
			this.__mapView = this.getChildByName("_mapView") as IMapView;
			this.__scrollPane = this.getChildByName("_scrollPane") as IScrollPane;
			
			var length:int = this.numChildren;
			for (var i:int = 0; i < length; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				var mapView:IMapView = child as IMapView;
				var scrollPane:IScrollPane = child as IScrollPane;
				
				if (mapView)
					this.__mapView = mapView;
					
				if (scrollPane)
					this.__scrollPane = scrollPane;
					
				if (this.__scrollPane && this.__mapView)
					break;
			}
						
			this.__scrollPane.source = this.__mapView;
			this.__scrollPane.draggable = true;
			
			this.zoomInButton = this.getChildByName('_zoomInButton') as DisplayObject || null;			
			this.zoomOutButton = this.getChildByName('_zoomOutButton') as DisplayObject || null;
			
			this.maximumZoom = 2;
			this.minimumZoom = 1;
			this._zoomInterval = .02;
		}
		
		/**
		*	@private	
		*/
		private function _mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget is IButton)
			{
				if (this._enabledButton) this._enabledButton.enabled = false;
				this._enabledButton = event.currentTarget as IButton;
				this._enabledButton.enabled = true;
			}

			event.currentTarget == this._zoomInButton ? this._zoomState = "zoomIn" : this._zoomState = "zoomOut";
			this.addEventListener(Event.ENTER_FRAME, this._zoomHandler);			
		}
		
		private function _mouseUpHandler(event:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, this._zoomHandler);
		}

		private function _zoomHandler(event:Event):void
		{	
			var contentContainer:DisplayObject = this.getScrollPaneContentContainer();			
			var scaleX:Number = contentContainer.scaleX;
			var scaleY:Number = contentContainer.scaleY;
			
			if (this._zoomState == "zoomIn")
			{
				scaleX += this._zoomInterval;
				scaleY += this._zoomInterval;
				this.scaleContent(scaleX >= this.maximumZoom ? contentContainer.scaleX : scaleX, scaleY >= this.maximumZoom ? contentContainer.scaleY : scaleY);
			}
			else
			{
				scaleX -= this._zoomInterval;
				scaleY -= this._zoomInterval;
				this.scaleContent(scaleX <= this.minimumZoom ? contentContainer.scaleX : scaleX, scaleY <= this.minimumZoom ? contentContainer.scaleY : scaleY);
			}			
		}				
	}
}