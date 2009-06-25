package inky.styles 
{
	import flash.utils.Dictionary;
	import inky.styles.StyleSheet;
	import inky.collections.IIterator;
	import inky.collections.ISet;
	import inky.styles.StyleSheetRule;
	import inky.styles.StyleSheetDeclaration;
	import inky.collections.events.CollectionEvent;
	import inky.collections.events.CollectionEventKind;
	import inky.collections.ISet;
	import inky.collections.Set;
	import inky.styles.selectors.ISelector;
	import inky.styles.StyleableTextField;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2009.06.11
	 *
	 */
	public class StyleManager
	{
		private var _objects:Dictionary;
		private var _styleSheets:ISet;


		/**
		 *
		 */
		public function StyleManager()
		{
			this._objects = new Dictionary(true);

			this._styleSheets = new Set();
			this._styleSheets.addEventListener(CollectionEvent.COLLECTION_CHANGE, this._styleSheetsListChangeHandler);
		}




		//
		// accessors
		//


		/**
		 *
		 * Gets a list of style sheets for which this manager is responsible.
		 * 
		 */
		public function get styleSheets():ISet
		{ 
			return this._styleSheets; 
		}




		//
		// public methods
		//
		

		/**
		 *	Registers an instance with this manager.
		 */
		public function registerObject(object:IStyleable):void
		{
			if (object && (this._objects[object] === undefined))
			{
				this._objects[object] = null;

if (object is StyleableTextField)
{
	for (var i:IIterator = StyleableTextField(object).elements.iterator(); i.hasNext(); )
	{
		this.registerObject(i.next() as IStyleable);
	}
}
				this._updateObjectStyles(object, this._styleSheets.toArray());
			}
		}


		/**
		 *	Unregisters an instance with this manager.
		 */
		public function unregisterObject(object:IStyleable):void
		{
			delete this._objects[object];

if (object is StyleableTextField)
{
	for (var i:IIterator = StyleableTextField(object).elements.iterator(); i.hasNext(); )
	{
		this.unregisterObject(i.next() as IStyleable);
	}
}

		}




		//
		// private methods
		//


		/**
		 *	
		 */
		private function _styleSheetsListChangeHandler(event:CollectionEvent):void
		{
// TODO: Add support for other manipulations (i.e. REMOVE)
			if (event.kind == CollectionEventKind.ADD)
			{
				this._updateAllObjects(event.items);
			}
		}


		/**
		 *	Update all registered objects with the specified style sheets.
		 */
		private function _updateAllObjects(styleSheets:Array):void
		{
			for (var object:Object in this._objects)
			{
				this._updateObjectStyles(object as IStyleable, styleSheets);
			}
		}


		/**
		 *	Apply the given style sheets to the specified object.
		 */
		private function _updateObjectStyles(object:IStyleable, styleSheets:Array):void
		{
			if (!object || !styleSheets || !styleSheets.length)
				return;
			
			var i:IIterator;
			var j:IIterator;
			var rule:StyleSheetRule;
			var rulesToApply:Array = [];

			// Determine which rules apply to the object in question.
			for each (var styleSheet:StyleSheet in styleSheets)
			{
				for (i = styleSheet.rules.iterator(); i.hasNext(); )
				{
					rule = i.next() as StyleSheetRule;
					for (j = rule.selectors.iterator(); j.hasNext(); )
					{
						var selector:ISelector = j.next() as ISelector;
						if (selector.matches(object))
						{
							rulesToApply.push(rule);
							break;
						}
					}
				}
			}

if (rulesToApply.length)
	trace("applying style to\t" + object);

// TODO: "cascade" styles. (figure out how the declarations impact eachother.) Does this require us to keep track of which rules are applied to each object (so that we have the selectors)?
// TODO: Obey specificity
			// Apply the styles.
			for each (rule in rulesToApply)
			{
				for (i = rule.declarations.iterator(); i.hasNext(); )
				{
					var declaration:StyleSheetDeclaration = i.next() as StyleSheetDeclaration;
					object.style[declaration.property] = declaration.value;
trace("\t" + declaration.property + ": " + declaration.value);
				}
			}
		}




	}
}