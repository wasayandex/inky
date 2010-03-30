package inky.components.listViews.dropdownList 
{
	import flash.display.Sprite;
	import inky.components.listViews.IListView;
	import inky.collections.IList;
	import inky.utils.EqualityUtil;
	import inky.binding.events.PropertyChangeEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextField;
	import inky.utils.describeObject;
	import inky.collections.events.CollectionEvent;
	import inky.collections.events.CollectionEventKind;
	
	/**
	 *
	 * A list view that shows a single item when inactive, and reveals the full list of items when active.
	 * 
	 * <p>A drop-down list has 3 main sub-components: a selected item view, a list view, and a list item view.
	 * This (DropdownList) object serves as the selected item view.  By default, it recognizes a dynamic 
	 * TextField named <code>_selectedLabelField</code>, and will optain a label from the 
	 * <code>selectedItem</code> to use as the TextField's text value. A class is specified for the dropdown 
	 * view via the <code>listRenderer</code> property. A class is also specified for the list item view by 
	 * setting the <code>itemRenderer</code> property. Instances of the <code>itemRenderer</code> class are 
	 * used to populate the <code>listRenderer</code>.</p>
	 * 
	 * @see inky.components.listViews.IListView
	 *	
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @since  2010.03.25
	 *
	 */
	public class DropdownList extends Sprite implements IListView
	{
		private var _dataProvider:IList;
		private var _itemRenderer:Class;
		private var _labelField:String;
		private var _labelFunction:Function;
		private var _listRenderer:Class;
		private var _prompt:String;
		private var _selectedIndex:int;
		private var _selectedItem:Object;
		private var _selectedItemRenderer:Class;
		private var __selectedLabelField:TextField;
		private var initializedForModel:Boolean;
		private var isOpen:Boolean;
		private var dropdown:IListView;

		
		/**
		 * Creates a new dropdown list.
		 */
		public function DropdownList()
		{
			this.init();
		}




		//---------------------------------------
		// ACCESSORS
		//---------------------------------------


		/**
		 * Gets or sets the data model of the list of items to be viewed. 
		 *  
		 * @default null
		 */
		public function get dataProvider():IList
		{
			return this._dataProvider;
		}
		/**
		 * @private
		 */
		public function set dataProvider(value:IList):void
		{
			if (!EqualityUtil.objectsAreEqual(value, this._dataProvider))
			{
				if (this._dataProvider)
					this._dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.dataProvider_collectionChangeHandler);
					
				this._dataProvider = value;
				if (value)
					value.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.dataProvider_collectionChangeHandler);

				this.initializedForModel = false;
				this.invalidate();	
			}
		}

		
		// FIXME: itemRenderer is synonymous with rendererClass. Maybe IListView.rendererClass should be renamed to itemRenderer? This change would effect all list views.
		/**
		 * Gets or sets the class to be used by the component to render the items 
		 * in the <code>dataProvider</code>.
		 * 
		 * <p>when the drop-down list is activated, an instance of 
		 * <code>listRenderer</code> is shown, and the <code>dataProvider</code> 
		 * items are represented by instances of <code>itemRenderer</code>.</p>
		 * 
		 * <p><strong>Note:</strong> The <code>listRenderer</code> may have
		 * its own <code>itemRenderer</code> defined, in which case this 
		 * <code>itemRenderer</code> will not be used.</p>
		 * 
		 * @default null
		 * 
		 * @see #listRenderer
		 */
		public function get itemRenderer():Class
		{ 
			return this._itemRenderer; 
		}
		/**
		 * @private
		 */
		public function set itemRenderer(value:Class):void
		{
			this._itemRenderer = value;
		}


		/**
         * Gets or sets the name of the field in the <code>dataProvider</code> object 
         * to be displayed as the label in the selected label field.
		 *
         * <p>By default, the component displays the <code>label</code> property 
		 * of each <code>dataProvider</code> item. If the <code>dataProvider</code> 
		 * items do not contain a <code>label</code> property, you can set the 
		 * <code>labelField</code> property to use a different property.</p>
         *
         * <p><strong>Note:</strong> The <code>labelField</code> property is not used 
         * if the <code>labelFunction</code> property is set to a callback function.</p>
         * 
         * @default "label"
         *
         * @see #labelFunction 
		 */
		public function get labelField():String
		{ 
			return this._labelField != null ? this._labelField : "label"; 
		}
		/**
		 * @private
		 */
		public function set labelField(value:String):void
		{
			var oldValue:String = this._labelField;
			if (oldValue != value)
			{
				this._labelField = value;
				this.invalidate();
			}
		}


        /**
         * Gets or sets the function to be used to obtain the label for the item.
		 *
         * <p>By default, the component displays the <code>label</code> property
		 * for a <code>dataProvider</code> item. But some data sets may not have 
		 * a <code>label</code> field or may not have a field whose value
		 * can be used as a label without modification. For example, a given data 
		 * set might store full names but maintain them in <code>lastName</code> and  
		 * <code>firstName</code> fields. In such a case, this property could be
		 * used to set a callback function that concatenates the values of the 
		 * <code>lastName</code> and <code>firstName</code> fields into a full 
		 * name string to be displayed.</p>
		 *
         * <p><strong>Note:</strong> The <code>labelField</code> property is not used 
         * if the <code>labelFunction</code> property is set to a callback function.</p>
         *
         * @default null
		 */
		public function get labelFunction():Function
		{ 
			return this._labelFunction; 
		}
		/**
		 * @private
		 */
		public function set labelFunction(value:Function):void
		{
			var oldValue:Function = this._labelFunction;
			if (oldValue != value)
			{
				this._labelFunction = value;
				this.invalidate();
			}
		}
		
		
		/**
		 * Gets or sets the class to be used by the component to render the 
		 * drop-down list.
		 * 
		 * <p>when the drop-down list is activated, an instance of 
		 * <code>listRenderer</code> is shown, and the <code>dataProvider</code> 
		 * items are represented by instances of <code>itemRenderer</code>.</p>
		 * 
		 * @default null
		 * 
		 * @see #itemRenderer
		 */
		public function get listRenderer():Class
		{ 
			return this._listRenderer; 
		}
		/**
		 * @private
		 */
		public function set listRenderer(value:Class):void
		{
			this._listRenderer = value;
		}
		
		
		/**
		 * Gets or sets the prompt for the DropdownList component. This prompt is a string 
		 * that is displayed in the selected label field when the <code>selectedIndex</code> 
		 * is -1. It is usually a string like "Select one...". If a prompt is not set, the 
		 * DropdownList component sets the <code>selectedIndex</code> property to 0 and displays 
		 * the first item in the <code>dataProvider</code> property.
         *
         * @default ""
		 */
		public function get prompt():String
		{ 
			return this._prompt;
		}
		/**
		 * @private
		 */
		public function set prompt(value:String):void
		{
			var oldValue:String = this._prompt;
			if (oldValue != value)
			{
				if (value == "")
					this._prompt = null;
				else
					this._prompt = value;
				this.invalidate();
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get itemRendererClass():Class
		{
			return this.itemRenderer;
		}
		/**
		 * @private
		 */
		public function set itemRendererClass(rendererClass:Class):void
		{
			this.itemRenderer = rendererClass;
		}
		
		
		/**
		 * Gets or sets the index of the item that is selected in the list.
		 *
		 * <p>A value of -1 indicates that no item is selected.</p>
         *
         * @see #selectedItem
		 */
		public function get selectedIndex():int
		{ 
			return this._selectedIndex; 
		}
		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			var oldValue:int = this._selectedIndex;
			if (value != oldValue)
				this.updateSelection(this.dataProvider.getItemAt(value));
		}
		
		
		/**
		 * Gets or sets the value of the <code>dataProvider</code> item that is 
		 * selected in the drop-down list.
		 *
         * @default null
         *
         * @see #selectedIndex
		 */
		public function get selectedItem():Object
		{ 
			return this._selectedItem; 
		}
		/**
		 * @private
		 */
		public function set selectedItem(value:Object):void
		{
			var oldValue:Object = this._selectedItem;
			if (value != oldValue && this.dataProvider.getItemIndex(value) != -1)
				this.updateSelection(value);
		}
		
		
		/**
		 * Gets the string that is displayed in the selected label field.
		 * This value is calculated from the data by using the 
		 * <code>labelField</code> or <code>labelFunction</code> property.
         *
		 * @see #labelField
         * @see #labelFunction
		 */
		public function get selectedLabel():String
		{
			if (this.selectedIndex == -1)
				return null;
				
			return this.itemToLabel(this.selectedItem);
		}
		



		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		
		/**
		 * Closes the drop-down list.
		 */
		public function close():void
		{
			if (this.isOpen && this.dispatchEvent(new Event(Event.CLOSE)))
			{
				this.isOpen = false;
				var dropdown:DisplayObject = this.getDropdown() as DisplayObject;
				if (this.stage.contains(dropdown))
					this.stage.removeChild(dropdown);
				this.stage.removeEventListener(MouseEvent.CLICK, this.stage_clickHandler);
			}
		}


		/**
		 *	Invalidates the component, marking it for redrawing before the next frame.
		 */
		public function invalidate():void
		{
			if (this.stage)
				this._invalidate(null);
			else
				this.addEventListener(Event.ADDED_TO_STAGE, this._invalidate);
		}
		
		
		/**
		 * Retrieves the string that the renderer displays for the given data object 
         * based on the <code>labelField</code> and <code>labelFunction</code> properties.
         *
         * <p><strong>Note:</strong> The <code>labelField</code> is not used  
         * if the <code>labelFunction</code> property is set to a callback function.</p>
		 *
		 * @param item The object to be rendered.
		 *
         * @return The string to be displayed based on the data.
		 */
		public function itemToLabel(item:Object):String
		{
			if (item == null)
				return "";
			if (this.labelFunction != null)
				return String(this.labelFunction(item));
			else
				return (item[this.labelField] != null) ? String(item[this.labelField]) : "";
		}
		
		
		/**
		 * Opens the drop-down list.
		 */
		public function open():void
		{
			if (!this.dataProvider || ! this.dataProvider.length)
				return;
			
			if (!this.isOpen && this.dispatchEvent(new Event(Event.OPEN)))
			{
				this.isOpen = true;
				var dropdown:DisplayObject = this.getDropdown() as DisplayObject;
				if (!this.stage.contains(dropdown))
					this.stage.addChild(dropdown);
				this.stage.addEventListener(MouseEvent.CLICK, this.stage_clickHandler);
			}
		}
		
		
		/**
		 * Updates the contents of the component based on the item selection.
		 */
		public function redraw():void
		{
			if (!this.initializedForModel)
				this.initializeForModel();

			if (this.__selectedLabelField)
			{
				var label:String = "";
				if (this.selectedIndex == -1)
				{
					if (this.prompt == null)
					{
						if(this.dataProvider && this.dataProvider.length)
						{
						 	// force selection of first item in dp.
							// TODO: Should this update cause the events to dispatch (possibly by going through updateSelection())?
							this._selectedIndex = 0;
							this._selectedItem = this.dataProvider.getItemAt(0);
							label = this.selectedLabel;
						}
					}
					else
					{
						label = this.prompt;
					}
				}
				else
				{
					label = this.selectedLabel;
				}
				this.__selectedLabelField.text = label;
			}
		}


		/**
		 * @inheritDoc
		 */
		public function showItemAt(index:int):void
		{
			throw new Error("not yet implemented.");
		}
		
		


		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------


		/**
		 * Toggles the active state of the drop-down list.
		 */
		private function clickHandler(event:MouseEvent):void
		{
			if (!this.isOpen)
				this.open();
			else
				this.close();
		}


		/**
		 * 
		 */
		private function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{
			// TODO: Update the selectedIndex and selectedItem when the dataProvider changes.
			if (this.selectedIndex != -1)
			{
				switch (event.kind)
				{
					case CollectionEventKind.ADD:
					{
						break;
					}
					case CollectionEventKind.REMOVE:
					{
						break;
					}
					case CollectionEventKind.MOVE:
					{
						break;
					}
					case CollectionEventKind.REPLACE:
					{
						break;
					}
				}
			}
		}
		
		
		/**
		 * Detects the selection of a list item via a mouse click.
		 * TODO: How should item selection be managed?  Via a model state? Or through this mouse event listener?
		 */
		private function dropDown_clickHandler(event:MouseEvent):void
		{
			if (event.target is this.itemRendererClass)
			{
				var model:Object = event.target.model;
				if (model && this.dataProvider.getItemIndex(model) != -1)
					this.selectedItem = model;
				this.close();
			}
		}
		
		
		/**
		 * Returns the dropdown list. If the dropdown list is not defined, it is created using the listRenderer class.
		 */
		private function getDropdown():IListView
		{
			if (!this.dropdown)
			{
				if (!this.listRenderer)
					throw new Error("No listRenderer defined.");
				
				var pos:Point = this.localToGlobal(new Point(0, 0));
				var dropdownClass:Class = this.listRenderer;
				this.dropdown = new dropdownClass() as IListView;
				
				// TODO: Determine which itemRenderer (rendererClass) takes precedence: the DropdownList's, or the listRenderer's.  Right now, the listRenderer's itemRenderer wins.
				if (!this.dropdown.itemRendererClass)
				{
					if (!this.itemRendererClass)
						throw new Error("No itemRendererClass defined.");
					this.dropdown.itemRendererClass = this.itemRendererClass;
				}
				else
				{
					this.itemRendererClass = this.dropdown.itemRendererClass;
				}
				this.dropdown.dataProvider = this.dataProvider;
				this.dropdown.x = pos.x;
				this.dropdown.y = pos.y;
				this.dropdown.addEventListener(MouseEvent.CLICK, this.dropDown_clickHandler);
			}
			
			return this.dropdown;
		}
		
		
		/**
		 * Called by the constructor.
		 */
		private function init():void
		{
			this._selectedIndex = -1;
			this.__selectedLabelField = this.getChildByName("_selectedLabelField") as TextField;
			this.initializedForModel = false;
			this.isOpen = false;
			this.addEventListener(MouseEvent.CLICK, this.clickHandler);
		}

		
		/**
		 * Initializes model-dependent aspects of the component.
		 */
		private function initializeForModel():void
		{
			if (!this.dataProvider)
				return;
			
			this.selectedIndex = -1;
			this.initializedForModel = true;
		}

		
		/**
		 * 
		 */
		private function _invalidate(event:Event):void
		{
			if (event)
				event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.stage.addEventListener(Event.RENDER, this.stage_renderHandler, false, 0, true);
			this.stage.invalidate();
		}


		/**
		 * Detects user activity outside of the active drop-down list, triggering the list's inactive state.
		 */
		private function stage_clickHandler(event:MouseEvent):void
		{
			if (!this.dropdown.hitTestPoint(event.stageX, event.stageY) && !this.hitTestPoint(event.stageX, event.stageY))
				this.close();
		}
		
		
		/**
		 * 
		 */
		private function stage_renderHandler(event:Event):void
		{
			if (event)
				event.currentTarget.removeEventListener(event.type, arguments.callee);
			
			// TODO: Should this allow redraw if dataProvider is null? What if you null an existing dataProvider?
			if (this.dataProvider || this.initializedForModel)
				this.redraw();
		}
		
		
		/**
		 * Updates the selectedIndex and selectedItem, and triggers a view update.
		 */
		private function updateSelection(value:Object):void
		{
			var oldSelectedItem:Object = this._selectedItem;
			var oldSelectedIndex:int = this._selectedIndex;
			this._selectedItem = value;
			this._selectedIndex = this.dataProvider.getItemIndex(value);
			this.invalidate();
			this.dispatchEvent(new Event(Event.CHANGE));
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedIndex", oldSelectedIndex, this._selectedIndex));	
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selectedItem", oldSelectedItem, this._selectedItem));	
		}
		



	}
	
}