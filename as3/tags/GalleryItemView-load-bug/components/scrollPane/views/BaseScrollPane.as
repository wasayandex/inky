package inky.framework.components.scrollPane.views
{
	import inky.framework.components.scrollPane.views.IScrollPane;
	import inky.framework.components.scrollBar.views.IScrollBar;
	import inky.framework.components.scrollBar.ScrollBarDirection;
	import inky.framework.components.scrollBar.ScrollPolicy;
	import inky.framework.components.scrollBar.events.ScrollEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
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
		private var __horizontalScrollBar:IScrollBar;
		private var _horizontalScrollPolicy:String;
		private var _loader:Loader;
		private var __mask:DisplayObject;
		private var _source:Object;
		private var __verticalScrollBar:IScrollBar;
		private var _verticalScrollPolicy:String;
		private var _draggable:Boolean;
		private var _maxVerticalScrollPosition:Number;
		private var _maxHorizontalScrollPosition:Number;
		private var _oldXPosition:Number;
		private var _oldYPosition:Number;


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
			return this.horizontalScrollBar.lineScrollSize;
		}
		/**
		 * @private
		 */		 		
		public function set horizontalLineScrollSize(horizontalLineScrollSize:Number):void
		{
			this.horizontalScrollBar.lineScrollSize = horizontalLineScrollSize;
			this.update();
		}


		/**
		 * @inheritDoc
		 */
		public function get horizontalPageScrollSize():Number
		{
			return this.horizontalScrollBar.pageScrollSize;
		}
		/**
		 * @private
		 */	
		public function set horizontalPageScrollSize(horizontalPageScrollSize:Number):void
		{
			this.horizontalScrollBar.pageScrollSize = horizontalPageScrollSize;
			this.update();
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
			return this.horizontalScrollBar.scrollPosition
		}
		/**
		 * @private
		 */
		public function set horizontalScrollPosition(horizontalScrollPosition:Number):void
		{
			this.horizontalScrollBar.scrollPosition = horizontalScrollPosition;
		}


		/**
		 * @inheritDoc
		 */
		public function get maxHorizontalScrollPosition():Number
		{
			return this.horizontalScrollBar.maxScrollPosition;
		}
		/**
		 * @private
		 */
		public function set maxHorizontalScrollPosition(maxHorizontalScrollPosition:Number):void
		{
			this.horizontalScrollBar.maxScrollPosition = maxHorizontalScrollPosition;
			this.update();
		}


		/**
		 * @inheritDoc
		 */
		public function get maxVerticalScrollPosition():Number
		{
			return this.verticalScrollBar.maxScrollPosition;
		}
		/**
		 * @private
		 */
		public function set maxVerticalScrollPosition(maxVerticalScrollPosition:Number):void
		{
			this.verticalScrollBar.maxScrollPosition = maxVerticalScrollPosition;
			this.update();
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
			return this.verticalScrollBar.lineScrollSize;
		}
		/**
		 * @private
		 */
		public function set verticalLineScrollSize(verticalLineScrollSize:Number):void
		{
			this.verticalScrollBar.lineScrollSize = verticalLineScrollSize;
			this.update();
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get verticalPageScrollSize():Number
		{
			return this.verticalScrollBar.pageScrollSize;
		}
		/**
		 * @private
		 */
		public function set verticalPageScrollSize(verticalPageScrollSize:Number):void
		{
			this.verticalScrollBar.pageScrollSize = verticalPageScrollSize;
			this.update();
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
			return this.verticalScrollBar.scrollPosition
		}
		/**
		 * @private
		 */
		public function set verticalScrollPosition(verticalScrollPosition:Number):void
		{
			this.verticalScrollBar.scrollPosition = verticalScrollPosition;
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

			if (this.draggable)
			{
				this._maxVerticalScrollPosition = (bounds.height + bounds.y) - this.__mask.height;
				this._maxHorizontalScrollPosition = (bounds.width + bounds.x) - this.__mask.width;
			}

			if (this.verticalScrollBar)
			{
				var contentHeight:Number = bounds.height + bounds.y;
				this.verticalScrollBar.enabled = this.__contentContainer.height > this.__mask.height;
				this.verticalScrollBar.maxScrollPosition = contentHeight - this.__mask.height;

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
				var contentWidth:Number = bounds.width + bounds.x;
				this.horizontalScrollBar.enabled = this.__contentContainer.width > this.__mask.width;
				this.horizontalScrollBar.maxScrollPosition = contentWidth - this.__mask.width;

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
			if (this.verticalScrollBar)
			{
				contentContainer.y = y;
			}
			if (this.horizontalScrollBar)
			{
				contentContainer.x = x;
			}
		}




		//
		// private methods
		//


		/**
		*	
		*	
		*/
		private function _draggableMouseHandler(e:MouseEvent):void
		{						
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					this.stage.addEventListener(MouseEvent.MOUSE_UP, this._draggableMouseHandler);
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);
					break;
				case MouseEvent.MOUSE_UP:
					this._oldXPosition = undefined;
					this._oldYPosition = undefined;

					this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._draggableMouseHandler);
					this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this._mouseMoveHandler);				
					break;
			}
		}

		private function _mouseMoveHandler(e:MouseEvent):void
		{	
			if (!this._oldXPosition) this._oldXPosition = e.currentTarget.mouseX;
			if (!this._oldYPosition) this._oldYPosition = e.currentTarget.mouseY;

			var contentContainer:DisplayObject = this.getContentContainer();
			var xPosition:Number = contentContainer.x - (this._oldXPosition - e.currentTarget.mouseX);
			var yPosition:Number = contentContainer.y - (this._oldYPosition - e.currentTarget.mouseY);

			if (Math.abs(xPosition) <= this._maxHorizontalScrollPosition && xPosition <= this.__mask.x && Math.abs(yPosition) <= this._maxVerticalScrollPosition && yPosition <= this.__mask.y)
			{
				if (this.horizontalScrollBar) this.horizontalScrollBar.scrollPosition += (this._oldXPosition - e.currentTarget.mouseX) ;
				if (this.verticalScrollBar) this.verticalScrollBar.scrollPosition += (this._oldYPosition - e.currentTarget.mouseY);

				if (!this.horizontalScrollBar || !this.verticalScrollBar) this.moveContent(xPosition, yPosition);
			}		

			this._oldXPosition = e.currentTarget.mouseX;
			this._oldYPosition = e.currentTarget.mouseY;
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
				this.verticalScrollBar.addEventListener(ScrollEvent.SCROLL, this._scrollHandler);
				this.verticalScrollBar.pageScrollSize =
				this.verticalScrollBar.pageSize = this.__mask.height;
				this.verticalScrollBar.direction = ScrollBarDirection.VERTICAL;
				
				if ((this as Object)._verticalScrollBar)
				{
					(this as Object)._verticalScrollBar = null;
				}
			}

			if (this.horizontalScrollBar)
			{
				this.horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, this._scrollHandler);
				this.horizontalScrollBar.pageScrollSize =
				this.horizontalScrollBar.pageSize = this.__mask.width;
				this.horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;
				
				if ((this as Object)._horizontalScrollBar)
				{
					(this as Object)._horizontalScrollBar = null;
				}
			}
			
			// If the ScrollPane has a _content clip, use it as the source.
			var tmp:DisplayObject;
			if ((tmp = this.getChildByName('_content')))
			{
				(this as Object)._content = null;
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
				this.verticalScrollBar.scrollPosition -= e.delta / 3 * (this.verticalScrollBar.lineScrollSize || this.verticalScrollBar.pageScrollSize || this.verticalScrollBar.pageSize);
			}
			else if (this.horizontalScrollBar && this.horizontalScrollBar.enabled)
			{
				this.horizontalScrollBar.scrollPosition -= e.delta / 3 * (this.horizontalScrollBar.lineScrollSize || this.horizontalScrollBar.pageScrollSize || this.horizontalScrollBar.pageSize);
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

		protected function scrollHandler(e:ScrollEvent):void
		{
			this.moveContent(this.horizontalScrollBar ? -this.horizontalScrollPosition : this.__contentContainer.x, this.verticalScrollBar ? -this.verticalScrollPosition : this.__contentContainer.y);
		}




	}
}
