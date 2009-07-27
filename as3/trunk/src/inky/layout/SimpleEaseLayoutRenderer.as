package inky.layout
{
	import inky.layout.ILayoutRenderer;
	import inky.layout.Layout;
	import inky.layout.events.LayoutRendererEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	
	/**
	 *
	 *	
	 *	
	 *	
	 *	
	 */
	public class SimpleEaseLayoutRenderer extends BasicLayoutRenderer implements ILayoutRenderer
	{
		private var _targets:Dictionary;
		private var _beginFromLayout:Boolean;
		private var _firstCall:Boolean;
		private static var _defaultEase:Number = 0.3;
		private static var _sprite:Sprite = new Sprite();
		public var xEase:Number;
		public var yEase:Number;
		public var widthEase:Number;
		public var heightEase:Number;


		/**
		 *
		 * Create a new LayoutRenderer that animates DisplayObjects to their
		 * new positions and sizes whenever the layout changes.
		 *
		 * @param easeOrXEase
		 *        (optional) the x easing value or (if it is the only argument)
		 *        the ease values for all of the properties.
		 * @param yEase
		 *        the y easing value
		 * @param widthEase
		 *        the width easing value
		 * @param heightEase
		 *        the height easing value
		 * @param beginFromLayout
		 *        if true, the renderer will place DisplayObjects at their
		 *        target location immediately the first time drawLayout is
		 *        called, and only animate on subsequent calls. otherwise, the
		 *        DisplayObjects will animate to their initial positions as
		 *        well.
		 *	
		 */
		public function SimpleEaseLayoutRenderer(easeOrXEase:Number = 0.3, yEase:Number = NaN, widthEase:Number = NaN, heightEase:Number = NaN, beginFromLayout:Boolean = false)
		{
			this.xEase = isNaN(easeOrXEase) ? SimpleEaseLayoutRenderer._defaultEase : easeOrXEase;
			
			// If you only provide one argument, use it for all of the ease
			// values.
			if (isNaN(yEase) && isNaN(widthEase) && isNaN(heightEase))
			{
				this.yEase =
				this.widthEase =
				this.heightEase = this.xEase;
			}
			else
			{
				this.yEase = isNaN(yEase) ? SimpleEaseLayoutRenderer._defaultEase : yEase;
				this.widthEase = isNaN(widthEase) ? SimpleEaseLayoutRenderer._defaultEase : widthEase;
				this.heightEase = isNaN(heightEase) ? SimpleEaseLayoutRenderer._defaultEase : heightEase;
			}
			
			this._beginFromLayout = beginFromLayout;

			if (!this._argIsValid(this.xEase) || !this._argIsValid(this.yEase) || !this._argIsValid(this.widthEase) || !this._argIsValid(this.heightEase))
			{
				throw new ArgumentError('Ease values must be greater than zero and less than two.');
			}
		}




		//
		// public methods.
		//
		
		
		/**
		 *
		 *
		 *	
		 */
		public override function drawLayout(layout:Layout, container:DisplayObjectContainer):void
		{
			if (!layout) return;
			
			super.drawLayout(layout, container);
			this._targets = new Dictionary(true);
			var bounds:Rectangle;
			var child:DisplayObject;
			var id:String;
			var i:uint;
			
			if (this._beginFromLayout)
			{
				for (i = 0; i < layout.length; i++)
				{
					bounds = layout.getItemAt(i);
					id = layout.getItemId(i);
					child = container.getChildByName(id);
					super.move(child, bounds.x, bounds.y);
					super.setSize(child, bounds.width, bounds.height);
				}
				this._beginFromLayout = false;
			}
			else
			{
				for (i = 0; i < layout.length; i++)
				{
					bounds = layout.getItemAt(i);
					id = layout.getItemId(i);
					child = container.getChildByName(id);
					this._targets[child] = bounds;
				}

				SimpleEaseLayoutRenderer._sprite.addEventListener(Event.ENTER_FRAME, this._enterFrameHandler, false, 0, true);
			}
		}
		
		
		/**
		 *
		 * Overridden so that the child isn't set to the final position immediately.
		 *	
		 */
		public override function move(child:DisplayObject, x:Number, y:Number):void
		{
		}


		/**
		 *
		 * Overridden so that the child isn't set to the final size immediately.
		 *	
		 */
		public override function setSize(child:DisplayObject, width:Number, height:Number):void
		{
		}
		
		
		
		
		//
		// private methods
		//
		
		
		/**
		 *
		 *	
		 *	
		 */
		private function _argIsValid(easeValue:Number):Boolean
		{
			return true;
			return easeValue > 0 && easeValue < 2;
		}		


		/**
		 *
		 *	
		 *	
		 */
		private function _enterFrameHandler(e:Event):void
		{
			var bounds:Rectangle;
			var childCount:uint = 0;
	
			for (var child:Object in this._targets)
			{
				childCount++;
				bounds = this._targets[child];
				child.x += this.xEase * (bounds.x - child.x);
				child.y += this.yEase * (bounds.y - child.y);
				child.width += this.widthEase * (bounds.width - child.width);
				child.height += this.heightEase * (bounds.height - child.height);
		
				// If the child is within half a pixel of all of its targeted
				// values, stop animating it.
				if (!(Math.abs(bounds.x - child.x) > 0.5 || Math.abs(bounds.y - child.y) > 0.5 || Math.abs(bounds.width - child.width) > 0.5 || Math.abs(bounds.height - child.height) > 0.5))
				{
					child.x = bounds.x;
					child.y = bounds.y;
					child.width = bounds.width;
					child.height = bounds.height;

// BUG
// TODO: container property of event should not be null!!!
					this.dispatchEvent(new LayoutRendererEvent(LayoutRendererEvent.UPDATE, false, false, null));
			
					delete this._targets[child];
					childCount--;
				}
			}
	
			// When all of the DisplayObjects are done animating, remove the
			// ENTER_FRAME listener.
			if (!childCount)
			{
				SimpleEaseLayoutRenderer._sprite.removeEventListener(Event.ENTER_FRAME, this._enterFrameHandler);
// BUG
// TODO: container property of event should not be null!!!
				this.dispatchEvent(new LayoutRendererEvent(LayoutRendererEvent.FINISH, false, false, null));
			}
		}




	}
}
