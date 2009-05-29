package inky.framework.components.accordion.views
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import inky.framework.collections.IList;
	import inky.framework.components.accordion.events.AccordionEvent;
	import inky.framework.components.accordion.views.IAccordionItemView;
	import inky.framework.components.listViews.IListView;
	
	/**
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	
	 */
	public class AccordionView extends MovieClip implements IListView
	{
		private var _items:Array;
		private var _spacing:Number;
		private var _selectedIndex:int;
		private var _direction:String;
		private var _previousItem:IAccordionItemView;
		private var _itemViewClass:Class;
		private var _model:IList;
		
		/*
		 *	@Constructor
		 */
		public function AccordionView(spacing:Number = 0)
		{
			this._selectedIndex = -1;
			this._direction = 'down';
			this._items = [];
			this.spacing = spacing;			
		}

		//
		// accessors
		//
		
		public function get model():IList
		{
			return this._model;
		}
		
		/**
		 * @private
		 */
		public function set model(model:IList):void
		{
			this._model = model;
			this._setContent();
		}
		
		/**
		 *
		 */
		public function get itemViewClass():Class
		{
			return this._itemViewClass;
		}
		
		/**
		 * @private
		 */
		public function set itemViewClass(itemViewClass:Class):void
		{
			this._itemViewClass = itemViewClass;
		}
		
		
		/**
		*	Set the spacing between each AccordionItemView.
		*	
		*	@param spacing
		*/
		public function set spacing(spacing:Number):void
		{
			if (spacing < 0) throw new Error("AccordionView only suppports a positive number for it's spacing.");
			this._spacing = spacing;
			
			this.selectedIndex = this.selectedIndex;			
		}
		
		/**
		*	Returns the spacing between each AccordionItemView
		*/
		public function get spacing():Number
		{
			return this._spacing;
		}
				
		/**
		*	Returns the number of items in the AccordionView.
		*/
		public function get numItems():Number 
		{
			return this._items.length;
		}
		
		/**
		*	Set the direction that the AccordionItemViews are slideing. Currently there is only support for "up" and "down".	
		*	
		*	@param direction
		*/
		public function set direction(direction:String):void
		{
			this._direction = direction;
		}
		public function get direction():String
		{
			return this._direction;
		}
			
	   /**
		*	Sets the current item to be opened based on the given index. If the user gives a value of -1 
		*	then all items in the AccordionView will close.
		*	
		*	@param selectedIndex
		*	 
	 	*/
		public function set selectedIndex(selectedIndex:int):void
		{
			this._previousItem = this._items[this._selectedIndex];
			this._selectedIndex = selectedIndex;		

			if (this.selectedIndex == -1) this.closeAll();
			else this._positionItems();
			
			this.dispatchEvent(new AccordionEvent(AccordionEvent.CHANGE, true, false));
		}
		
		/**
		* 	Returns the currently selected index in the AccordionView
		*/
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}	
												
		//
		// public methods
		//		
		
		/**
		*	Closes all of the AccordionItemViews and tweens them back to their original positions.
		*/
		public function closeAll():void
		{
			for (var i:int = 0; i < this.numItems; i++)
			{
				var item:IAccordionItemView = this._items[i] as IAccordionItemView;
				var ySpot:Number;
				
				ySpot = i * (item.minimumHeight + this.spacing)
				
				item.close();
				this.moveItem(item, ySpot);
			}		
		}

//!Should this be implemented? If so what would it do?		
public function showItemAt(index:int):void
{
	throw new Error("ShowItemAt has not been implemented!");
}
		
		//
		// protected methods
		//
		
		/**
		*	
		*/
		protected function moveItem(item:IAccordionItemView, position:Number):void
		{
			Tweener.addTween(item, {y: position, time: .5, transition: 'easeInOutQuad'});			
		}	
			
		//
		// private methods
		//
		
		/**
		*	
		*/
		private function _setContent():void
		{	
			this.addEventListener(AccordionEvent.OPEN, this._accordionEventHandler);
			this.addEventListener(AccordionEvent.CLOSE, this._accordionEventHandler);
			
			var length:int = this._model.length;
			for (var i:int = 0; i < length; i++)
			{
				var accordionItem:IAccordionItemView = new this._itemViewClass();
				accordionItem.model = this._model.getItemAt(i);

				accordionItem.y = i * (accordionItem.minimumHeight + this.spacing);
			
				this.addChild(accordionItem as DisplayObject);
				this._items[this._items.length] = accordionItem;
			}			
		}
					
		/**
		 *
		 *	
		 */
		private function _accordionEventHandler(event:AccordionEvent):void
		{	
			var activecontent:IAccordionItemView = event.target as IAccordionItemView;
			var index:Number = this._items.indexOf(activecontent);
			
			if (index == this.selectedIndex) this.closeAll();
			else this.selectedIndex = index;
						
			this.dispatchEvent(new AccordionEvent(AccordionEvent.CHANGE, true, false));
		}
		
		/**
		*	
		*	
		*/
		private function _positionItems():void
		{			
			var ySpot:Number = 0;
			var selectedItem:IAccordionItemView = this._items[this.selectedIndex];

			for (var i:int = 0; i < this.numItems; i++)
			{	
				var item:IAccordionItemView = this._items[i] as IAccordionItemView;
				
				if (this._direction == "down")
				{
					if (i <= this.selectedIndex)
					{
						ySpot = i * (item.minimumHeight + this.spacing);
					}
					else if (i == this.selectedIndex + 1)
					{
						ySpot += selectedItem.maximumHeight + this.spacing; 
					}
					else if (i > this.selectedIndex + 1)
					{
						ySpot += (item.minimumHeight + this.spacing);
					}
				}
				else
				{
					var selectedItemPosition:Number = (this.selectedIndex * (item.minimumHeight + this.spacing)) - (selectedItem.maximumHeight - selectedItem.minimumHeight + this.spacing);
					if (i > this.selectedIndex)
					{
						ySpot = i * (item.minimumHeight + this.spacing);
					}
					else if (i == this.selectedIndex)
					{
						ySpot = selectedItemPosition + this.spacing;
					}
					else if (i < this.selectedIndex)
					{
						ySpot = selectedItemPosition + this.spacing - (this.selectedIndex - i) * (item.minimumHeight + this.spacing);
					}
				}
				
				this.moveItem(item, ySpot);
				
				if (this._previousItem)
				{
					this._previousItem.close();
					this._previousItem = null;
				}

				if (selectedItem == item) 
				{
					selectedItem.open();
				}				
			}
			
		}				
	}
}
