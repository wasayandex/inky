package inky.framework.components.accordion.views
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import inky.framework.components.accordion.views.IAccordionItemView;
	import inky.framework.components.accordion.events.AccordionEvent;

	public class AccordionItemView extends MovieClip implements IAccordionItemView
	{
		private var __button:InteractiveObject;
		private var __mask:DisplayObject;
		private var _mouseEventType:String;
		private var _maximumHeight:Number;
		private var _minimumHeight:Number;
		private var _model:Object;
		private var _open:Boolean;
		
		public function AccordionItemView()
		{
			this._init();
		}
		
		//
		// accessors
		//
		
		public function set model(model:Object):void
		{
			this._model = model;
		}
		
		public function get model():Object
		{
			return this._model;
		}
				
/**
*	@inheritDoc
*/
public function get maximumHeight():Number
{
	return this._maximumHeight;
}

/**
*	@inheritDoc
*/
public function set maximumHeight(height:Number):void
{
	this._maximumHeight = height;
}

/**
*	@inheritDoc
*/
public function set minimumHeight(height:Number):void
{
	this._minimumHeight = height;
}

/**
*	@inheritDoc
*/
public function get minimumHeight():Number
{
	return this._minimumHeight;
}
		
		public function set mouseEventType(mouseEventType:String):void
		{
			if (this._mouseEventType) this.__button.removeEventListener(this._mouseEventType, this._openCloseHandler);
			
			this._mouseEventType = mouseEventType;
			this.__button.addEventListener(mouseEventType, this._openCloseHandler);
		}
		
		//
		// public methods
		//
		
		/**
		*	@inheritDoc
		*/
		public function open():void
		{		
			Tweener.addTween(this.getMask(), {height: this.maximumHeight, time: .5, transition: 'easeOutQuad'});
		}
		
		/**
		*	@inheritDoc
		*/
		public function close():void
		{
			Tweener.addTween(this.getMask(), {height: this.minimumHeight, time: .5, transition: 'easeOutQuad'});
		}
		
		//
		// protected functions
		//
		
protected function getMask():DisplayObject
{
	return this.__mask;
}
protected function getButton():InteractiveObject
{
	return this.__button;
}

		//
		// private functions
		//
		
		private function _init():void
		{			
			this.__button = this.getChildByName('_button') as InteractiveObject;
			if (!this.__button) throw new Error("AccordionItemView is missing a button!");
			
			this.__mask = this.getChildByName('_mask') as Sprite;
			if (!this.__mask)
			{
				for (var i:int = 0; i < this.numChildren; i++)
				{
					var shape:Shape = this.getChildAt(i) as Shape;
					if (shape)
					{
						this.__mask = shape;
						break;
					}
				}
			}
			
			if (!this.__mask) throw new Error("AccordionItemView is missing it's mask!");
			this.__mask.height = this.__button.height;
			this.mask = this.__mask;
		
			this.maximumHeight = this.height;
			this.minimumHeight = this.__button.height;
			this.mouseEventType = MouseEvent.CLICK;
			this._open = false;
		}
		
		private function _openCloseHandler(event:MouseEvent):void
		{
			this._open = !this._open;
			if (this._open) this.dispatchEvent(new AccordionEvent(AccordionEvent.OPEN, true));
			else this.dispatchEvent(new AccordionEvent(AccordionEvent.CLOSE, true));
		}
	}
}