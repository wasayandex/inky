package inky.components.mapPane.views 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import inky.collections.IList;
	import inky.components.IButton;
	import inky.components.mapPane.views.IMapView;
	import inky.components.mapPane.views.IScrollableMapView;
	import inky.components.scrollPane.views.IScrollPane;
	
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
			this.mapView = this.getChildByName("_mapView") as IMapView || this._checkForObject(IMapView) as IMapView;
			this.scrollPane = this.getChildByName("_scrollPane") as IScrollPane || this._checkForObject(IScrollPane) as IScrollPane;
			this.zoomInButton = this.getChildByName('_zoomInButton') as DisplayObject || null;			
			this.zoomOutButton = this.getChildByName('_zoomOutButton') as DisplayObject || null;
			
			this.maximumZoom = 2;
			this.minimumZoom = 1;
			this._zoomInterval = .02;			
		}
		
		//
		// accessors
		//
		
		/**
		 * @inheritDoc
		 */
		public function set mapView(value:IMapView):void
		{
			this.__mapView = value;
		}
		public function get mapView():IMapView
		{
			return this.__mapView;
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
		 * @inheritDoc
		 */
		public function set scrollPane(value:IScrollPane):void
		{
			this.__scrollPane = value;
			this.__scrollPane.source = this.mapView;
			this.__scrollPane.draggable = true;
		}
		public function get scrollPane():IScrollPane
		{
			return this.__scrollPane;
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
	var point:DisplayObject = this.mapView.getPointByModel(value);	
	if (point)
	{
		var p:Point = this.globalToLocal(new Point(point.x, point.y));
		this.scrollPane.horizontalScrollPosition = p.x - 20;
		this.scrollPane.verticalScrollPosition = p.y - 20;
	}
	
	this.mapView.showPointByModel(value);
}
		
		//
		// protected functions
		//
		
		/**
		*	Scales the mapView based on the values of the two parameters. This is useful
		*	to add tweening.
		*	
		*	@param scaleX
		*	@param scaleY	
		*/
		protected function scaleContent(scaleX:Number, scaleY:Number):void
		{
			this.mapView.scaleX = scaleX;
			this.mapView.scaleY = scaleY;
			this.scrollPane.update();
		}
				
		//
		// private functions
		//
		
		/**
		*	Checks for an that is already on the stage based on it's DateType.
		*	It returns either the object of that dataType or null.
		*	
		*	@param dataType	
		*	@return
		*/
		private function _checkForObject(value:Class):Object
		{
			var object:Object;
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:Object = this.getChildAt(i) as value;
				if (child)
				{
					object = child;
					break;
				}
			}
			return object;
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
			var scaleX:Number = this.mapView.scaleX;
			var scaleY:Number = this.mapView.scaleY;
			
			if (this._zoomState == "zoomIn")
			{
				scaleX += this._zoomInterval;
				scaleY += this._zoomInterval;
				this.scaleContent(scaleX >= this.maximumZoom ? this.mapView.scaleX : scaleX, scaleY >= this.maximumZoom ? this.mapView.scaleY : scaleY);
			}
			else
			{
				scaleX -= this._zoomInterval;
				scaleY -= this._zoomInterval;
				this.scaleContent(scaleX <= this.minimumZoom ? this.mapView.scaleX : scaleX, scaleY <= this.minimumZoom ? this.mapView.scaleY : scaleY);
			}			
		}				
	}
}