package inky.framework.components.scrollPane.views
{
	import inky.framework.binding.utils.BindingUtil;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.components.scrollPane.views.IScrollPane;
	import inky.framework.components.scrollBar.views.IScrollBar;
	import inky.framework.components.scrollBar.ScrollBarDirection;
	import inky.framework.components.scrollBar.ScrollPolicy;
	import inky.framework.components.scrollBar.events.ScrollEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

// TODO: Add support for mouse wheel on mac
	/**
	 *
	 *  Provides a basic ScrollPane implementation that handles events, masking,
	 *  and the positioning of scrollable conent.
	 *  
	 *  @inheritDoc
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author    Matthew Tretter (matthew@exanimo.com)
	 *	@author     Ryan Sprake
	 *	@since     2007.11.12
	 *	
	 */
	public class BaseScrollPane extends Sprite implements IScrollPane
	{
		private var __content:DisplayObject;
		private var __contentContainer:Sprite;
		private var _horizontalLineScrollSize:Number;
		private var _horizontalPageScrollSize:Number;
		private var _horizontalScrollPosition:Number;
		private var _maxHorizontalScrollPosition:Number;
		private var _maxVerticalScrollPosition:Number;
		private var _verticalLineScrollSize:Number;
		private var _verticalPageScrollSize:Number;
		private var _verticalScrollPosition:Number;
		private var __horizontalScrollBar:IScrollBar;
		private var _horizontalScrollPolicy:String;
		private var _loader:Loader;
		private var __mask:DisplayObject;
		private var _source:Object;
		private var __verticalScrollBar:IScrollBar;
		private var _verticalScrollPolicy:String;
		private var _draggable:Boolean;
private var _dragPoint:Sprite;
private var _oldMouseXPosition:Number;
private var _oldMouseYPosition:Number;
		
		/**
		 *
		 * Creates a new BaseScrollPane instance. If the symbol attached to this
		 * class has children named "_horizontalScrollBar" and/or
		 * "_verticalScrollBar", they will be passed to the scroll bar setters.
		 * If it has a child named "_content", it will be used as the
		 * ScrollPane's content. If it has a child named "_mask", it will be
		 * used as the mask; otherwise the Shape object of the highest index in
		 * the display list will be used.		 		 		 		 		 
		 *
		 */		 		 		 		
		public function BaseScrollPane()
		{
			this._init();
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get content():DisplayObject
		{
			return this.__content;
		}


		/**
		 * @inheritDoc
		 */
		public function get horizontalLineScrollSize():Number
		{
			return this._horizontalLineScrollSize;
		}
		/**
		 * @private
		 */		 		
		public function set horizontalLineScrollSize(value:Number):void
		{
			if (value != this._horizontalLineScrollSize)
			{
				var oldValue:Number = this._horizontalLineScrollSize;
				this._horizontalLineScrollSize = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalLineScrollSize", oldValue, value));
				this.update();
			}
		}


		/**
		 * @inheritDoc
		 */
		public function get horizontalPageScrollSize():Number
		{
			return this._horizontalPageScrollSize;
		}
		/**
		 * @private
		 */	
		public function set horizontalPageScrollSize(value:Number):void
		{
			if (value != this._horizontalPageScrollSize)
			{
				var oldValue:Number = this._horizontalPageScrollSize;
				this._horizontalPageScrollSize = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalPageScrollSize", oldValue, value));
				this.update();
			}
		}


		/**
		 * @inheritDoc
		 */
		public function get horizontalScrollBar():IScrollBar
		{
			return this.__horizontalScrollBar;
		}


		/**
		 * @inheritDoc
		 */
		public function get horizontalScrollPolicy():String
		{
			return this._horizontalScrollPolicy;
		}
		/**
		 * @private
		 */
		public function set horizontalScrollPolicy(horizontalScrollPolicy:String):void
		{
			this._horizontalScrollPolicy = horizontalScrollPolicy;
			this.update();
		}


		/**
		 * @inheritDoc
		 */
		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}
		
		/**
		 * @private
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if (value != this._horizontalScrollPosition)
			{
				var oldValue:Number = this._horizontalScrollPosition;
				this._horizontalScrollPosition = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalScrollPosition", oldValue, value));
				this.update();
			}
		}


		/**
		 * @inheritDoc
		 */
		public function get maxHorizontalScrollPosition():Number
		{
			return this._maxHorizontalScrollPosition;
		}
		/**
		 * @private
		 */
		public function set maxHorizontalScrollPosition(value:Number):void
		{
			if (value != this._maxHorizontalScrollPosition)
			{
				var oldValue:Number = this._maxHorizontalScrollPosition;
				this._maxHorizontalScrollPosition = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxHorizontalScrollPosition", oldValue, value));
				this.update();
			}
		}


		/**
		 * @inheritDoc
		 */
		public function get maxVerticalScrollPosition():Number
		{
			return this._maxVerticalScrollPosition;
		}
		/**
		 * @private
		 */
		public function set maxVerticalScrollPosition(value:Number):void
		{
			if (value != this._maxVerticalScrollPosition)
			{
				var oldValue:Number = this._maxVerticalScrollPosition;
				this._maxVerticalScrollPosition = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "maxVerticalScrollPosition", oldValue, value));
				this.update();
			}
		}
		

		/**
		 * @inheritDoc
		 */
		public function get source():Object
		{
			return this._source;
		}
		/**
		 * @private
		 */
		public function set source(source:Object):void
		{
			var content:DisplayObject;
			var cls:Class;
			var str:String;

			if (source is DisplayObject)
			{
				content = source as DisplayObject;
			}
			else if ((cls = source as Class))
			{
				content = new cls();
			}
			else if ((str = source as String))
			{
				if (this.parent && (content = this.parent.getChildByName(str)))
				{
					// source is the instance name of a movie clip on the same level as the component.
				}
				else
				{
					try
					{
						cls = getDefinitionByName(str) as Class;
						content = new cls() as DisplayObject;
					}
					catch (error:Error)
					{
					}

					if (!content)
					{
						// source is an absolute or relative URL that  identifies the location of the SWF or image file to load
						var request:URLRequest = new URLRequest(str);
						this.load(request);
					}
				}
			}

			if (content is TextField)
			{
				(content as TextField).mouseWheelEnabled = false;
			}

			this._source = source;
			this.__content = content;
			
			if (content)
			{
				if (content.parent != this)
				{
					content.x =
					content.y = 0;				
				}
				this.__contentContainer.addChild(content);
			}
			
			this.update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get useBitmapScrolling():Boolean
		{
			return this.__contentContainer.cacheAsBitmap;
		}
		/**
		 * @private
		 */
		public function set useBitmapScrolling(useBitmapScrolling:Boolean):void
		{
			this.__contentContainer.cacheAsBitmap = useBitmapScrolling;
		}

		
		/**
		 * @inheritDoc
		 */
		public function set draggable(draggable:Boolean):void
		{
			this._draggable = draggable;
			this._dragPoint = new Sprite();
			
			if (draggable) this.source.addEventListener(MouseEvent.MOUSE_DOWN, this._draggableMouseHandler);
			else this.source.removeEventListener(MouseEvent.MOUSE_DOWN, this._draggableMouseHandler);
			this.update();
		}
		public function get draggable():Boolean
		{
			return this._draggable;
		}


		/**
		 * @inheritDoc
		 */
		public function get verticalLineScrollSize():Number
		{
			return this._verticalLineScrollSize;
		}
		/**
		 * @private
		 */
		public function set verticalLineScrollSize(value:Number):void
		{
			if (value != this._verticalLineScrollSize)
			{
				var oldValue:Number = this._verticalLineScrollSize;
				this._verticalLineScrollSize = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalLineScrollSize", oldValue, value));
				this.update();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get verticalPageScrollSize():Number
		{
			return this._verticalPageScrollSize;
		}
		/**
		 * @private
		 */
		public function set verticalPageScrollSize(value:Number):void
		{
			if (value != this._verticalPageScrollSize)
			{
				var oldValue:Number = this._verticalPageScrollSize;
				this._verticalPageScrollSize = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalPageScrollSize", oldValue, value));
				this.update();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get verticalScrollBar():IScrollBar
		{
			return this.__verticalScrollBar;
		}


		/**
		 * @inheritDoc
		 */
		public function get verticalScrollPolicy():String
		{
			return this._verticalScrollPolicy;
		}
		/**
		 * @private
		 */
		public function set verticalScrollPolicy(verticalScrollPolicy:String):void
		{
			this._verticalScrollPolicy = verticalScrollPolicy;
			this.update();
		}


		/**
		 * @inheritDoc
		 */
		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}
		/**
		 * @private
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			if (value != this._verticalScrollPosition)
			{
				var oldValue:Number = this._verticalScrollPosition;
				this._verticalScrollPosition = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalScrollPosition", oldValue, value));
				this.update();
			}
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */	
		public function load(request:URLRequest, context:LoaderContext = null):void
		{
			this._loader = this._loader || new Loader();

			if (this._loader.content)
			{
				this._loader.unload();
			}
			
			this._loader.load(request, context);
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._completeHandler);
			this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this._progressHandler);
			this.__contentContainer.addChild(this._loader);
		}
		
		
		/**
		 * @inheritDoc
		 */	
		public function update():void
		{
			var bounds:Rectangle = this.__contentContainer.getBounds(this.__contentContainer);
			var contentHeight:Number = bounds.height + bounds.y;
			var contentWidth:Number = bounds.width + bounds.x;
			
			if (this.draggable)
			{							
				if (this.verticalScrollBar)
				{
					this.maxVerticalScrollPosition = contentHeight - this.__mask.height;
				}
				
				if (this.horizontalScrollBar)
				{
					this.maxHorizontalScrollPosition = contentWidth - this.__mask.width;
				}
			}

			if (this.verticalScrollBar)
			{
				this.verticalScrollBar.enabled = this.__contentContainer.height > this.__mask.height;
				this.maxVerticalScrollPosition = Math.max(contentHeight - this.__mask.height, 0);

				if (this.verticalScrollPolicy == ScrollPolicy.AUTO)
				{
					this.verticalScrollBar.visible = this.verticalScrollBar.enabled;
				}
				else
				{
					this.verticalScrollBar.visible = this.verticalScrollPolicy == ScrollPolicy.ON;
				}
			}
			if (this.horizontalScrollBar)
			{
				this.horizontalScrollBar.enabled = this.__contentContainer.width > this.__mask.width;
				this.maxHorizontalScrollPosition = Math.max(contentWidth - this.__mask.width, 0);

				if (this.horizontalScrollPolicy == ScrollPolicy.AUTO)
				{
					this.horizontalScrollBar.visible = this.horizontalScrollBar.enabled;
				}
				else
				{
					this.horizontalScrollBar.visible = this.horizontalScrollPolicy == ScrollPolicy.ON;
				}
			}
		}




		//
		// protected methods
		//


		/**
		 *
		 * Provides access to the sprite that holds the ScrollPane's content.
		 * This method can be used by subclasses that want to provide custom
		 * scrolling motion.
		 * 
		 * @return
		 *     The Sprite that contains the content of the ScrollPane		 		 		 		 		 
		 *
		 */
		protected function getContentContainer():DisplayObjectContainer
		{
			return this.__contentContainer as DisplayObjectContainer;
		}


		/**
		 * @inheritDoc
		 */
		protected function getScrollMask():DisplayObject
		{
			return this.__mask;
		}


		/**
		 *
		 * Moves the ScrollPane's content. Called as a result of ScrollEvents.
		 * Subclasses can override this method to provide custom scrolling
		 * motion.		 		 
		 * 
		 * @param x
		 *     The x coordinate to which the content should be moved
		 * @param y
		 *     The y coordinate to which the content should be moved		 		 		 		 		 		 		 
		 *
		 */
		protected function moveContent(x:Number, y:Number):void
		{
			var contentContainer:DisplayObjectContainer = this.getContentContainer();
			if (this.verticalScrollBar || this.draggable)
			{
				contentContainer.y = y;
			}
			if (this.horizontalScrollBar || this.draggable)
			{
				contentContainer.x = x;
			}
		}




		//
		// private methods
		//


		/**
		 *	Initializes the Scrollpane's values and components
		 * 	
		 */
		private function _init():void
		{
			// Find the mask.
			if (!(this.__mask = this.getChildByName('_mask')))
			{ 
				var child:DisplayObject;
				for (var i:int = this.numChildren - 1; i >= 0; i--)
				{
					child = this.getChildAt(i);
					if (child is Shape)
					{
						this.__mask = child;
						break;
					}
				}

				if (!this.__mask)
				{				
					throw new Error('ScrollPane is missing a mask.');
				}
			}

			this._horizontalLineScrollSize =
			this._verticalLineScrollSize = 4;
			this._verticalScrollPolicy = ScrollPolicy.AUTO;
			this._horizontalScrollPolicy = ScrollPolicy.AUTO;
			
			// Create the content container.
			this.__contentContainer = this.getChildByName('_contentContainer') as Sprite;
			if (this.__contentContainer == null)
			{
				this.__contentContainer = new Sprite();
				this.addChild(this.__contentContainer);
			}
			this.__contentContainer.mask = this.__mask;
			this.addEventListener(MouseEvent.MOUSE_WHEEL, this._mouseWheelHandler);
			this._initChildren();
		}


		/**
		 *	This function is called when the user performs a mouse down or mouse up on the content 
		 *	only if the BaseScrollPane's draggable is set to true.
		 *	
		 */
		private function _draggableMouseHandler(e:MouseEvent):void
		{									
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN:																							
					var dragBounds:Rectangle = new Rectangle();
					var containerBounds:Rectangle = this.getContentContainer().getBounds(this);
					var maskBounds:Rectangle = this.getScrollMask().getBounds(this);

					dragBounds.width = containerBounds.width - maskBounds.width;
					dragBounds.height = containerBounds.height - maskBounds.height;
					dragBounds.x = -dragBounds.width;
					dragBounds.y = -dragBounds.height;

					this._dragPoint.x = containerBounds.x;
					this._dragPoint.y = containerBounds.y;
					this._dragPoint.startDrag(false, dragBounds);
			
					this._oldMouseXPosition = this.stage.mouseX;
					this._oldMouseYPosition = this.stage.mouseY;
			
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
					this.stage.addEventListener(MouseEvent.MOUSE_UP, this._draggableMouseHandler);
					break;
				case MouseEvent.MOUSE_UP:
					this._dragPoint.stopDrag();
									
					this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
					this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._draggableMouseHandler);
					break;
			}
		}

		/**
		 *		
		 */
		private function _mouseMoveHandler(e:MouseEvent):void
		{
			this.dragHandler();
		}

		/**
		 *
		 * Initializes the ScrollPane onces its source has completed loading.
		 *
		 */
		private function _completeHandler(e:Event):void
		{
			this.__content = e.currentTarget.content;
			this.update();
			this.dispatchEvent(e);
		}


		/**
		 *
		 * Initializes the horizontal scrollbar, vertical scrollbar, and content
		 * of the ScrollPane, if they are on stage and have the correct names.		 
		 *
		 */
		private function _initChildren():void
		{
			this.__verticalScrollBar = this.getChildByName('_verticalScrollBar') as IScrollBar;
			this.__horizontalScrollBar = this.getChildByName('_horizontalScrollBar') as IScrollBar;
		
			if (this.verticalScrollBar)
			{
				this.verticalPageScrollSize = this.__mask.height;
				this.verticalScrollBar.direction = ScrollBarDirection.VERTICAL;

				BindingUtil.bindProperty(this, "verticalLineScrollSize", this, ["verticalScrollBar", "lineScrollSize"]);
				BindingUtil.bindProperty(this.verticalScrollBar, "lineScrollSize", this, "verticalLineScrollSize");
				BindingUtil.bindProperty(this, "verticalPageScrollSize", this, ["verticalScrollBar", "pageScrollSize"]);
				BindingUtil.bindProperty(this.verticalScrollBar, "pageScrollSize", this, "verticalPageScrollSize");
				BindingUtil.bindProperty(this, "verticalScrollPosition", this, ["verticalScrollBar", "scrollPosition"]);
				BindingUtil.bindProperty(this.verticalScrollBar, "scrollPosition", this, "verticalScrollPosition");
				BindingUtil.bindProperty(this, "maxVerticalScrollPosition", this, ["verticalScrollBar", "maxScrollPosition"]);
				BindingUtil.bindProperty(this.verticalScrollBar, "maxScrollPosition", this, "maxVerticalScrollPosition");

				this.verticalScrollBar.addEventListener(ScrollEvent.SCROLL, this._scrollHandler);
			}

			if (this.horizontalScrollBar)
			{
				this.horizontalPageScrollSize = this.__mask.width;
				this.horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;

				BindingUtil.bindProperty(this, "horizontalLineScrollSize", this, ["horizontalScrollBar", "lineScrollSize"]);
				BindingUtil.bindProperty(this.horizontalScrollBar, "lineScrollSize", this, "horizontalLineScrollSize");
				BindingUtil.bindProperty(this, "horizontalPageScrollSize", this, ["horizontalScrollBar", "pageScrollSize"]);
				BindingUtil.bindProperty(this.horizontalScrollBar, "pageScrollSize", this, "horizontalPageScrollSize");
				BindingUtil.bindProperty(this, "horizontalScrollPosition", this, ["horizontalScrollBar", "scrollPosition"]);
				BindingUtil.bindProperty(this.horizontalScrollBar, "scrollPosition", this, "horizontalScrollPosition");
				BindingUtil.bindProperty(this, "maxHorizontalScrollPosition", this, ["horizontalScrollBar", "maxScrollPosition"]);
				BindingUtil.bindProperty(this.horizontalScrollBar, "maxScrollPosition", this, "maxHorizontalScrollPosition");

				this.horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, this._scrollHandler);
			}
			
			// If the ScrollPane has a _content clip, use it as the source.
			var tmp:DisplayObject;
			if ((tmp = this.getChildByName('_content')))
			{
				this.source = tmp;
			}
		}	


		/**
		 *
		 * Handles the mouse wheel events.
		 *
		 */
		private function _mouseWheelHandler(e:MouseEvent):void
		{			
			if (this.verticalScrollBar && this.verticalScrollBar.enabled)
			{
				this.verticalScrollPosition -= e.delta / 3 * (this.verticalLineScrollSize || this.verticalPageScrollSize || this.verticalScrollBar.pageSize);
			}
			else if (this.horizontalScrollBar && this.horizontalScrollBar.enabled)
			{
				this.horizontalScrollPosition -= e.delta / 3 * (this.horizontalLineScrollSize || this.horizontalPageScrollSize || this.horizontalScrollBar.pageSize);
			}
		}
		
		
		/**
		 *
		 * Relays progress events.
		 *
		 */
		private function _progressHandler(e:ProgressEvent):void
		{
			this.dispatchEvent(e);
		}


		/**
		 *
		 * Moves the content when the scroll event is dispatched.
		 *
		 */
		private function _scrollHandler(e:ScrollEvent):void
		{
			this.scrollHandler(e);
			this.dispatchEvent(e);
		}



		protected function dragHandler():void
		{									
			this.horizontalScrollPosition -= (this.stage.mouseX - this._oldMouseXPosition);			
			this.verticalScrollPosition -= (this.stage.mouseY - this._oldMouseYPosition);
			
			this._oldMouseXPosition = this.stage.mouseX;
			this._oldMouseYPosition = this.stage.mouseY;
			
			if (this.horizontalScrollBar || this.horizontalScrollBar)
				this._scrollAndDragHandler();
			else
				this.moveContent(this._dragPoint.x, this._dragPoint.y);
		}
		
		private function _scrollAndDragHandler():void
		{
			var x:Number = this.horizontalScrollBar ? -this.horizontalScrollPosition : this.__contentContainer.x;
			var y:Number = this.verticalScrollBar ? -this.verticalScrollPosition : this.__contentContainer.y;
			this.moveContent(x, y);
		}



		protected function scrollHandler(e:ScrollEvent):void
		{
			this._scrollAndDragHandler();
		}




	}
}
