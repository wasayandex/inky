package inky.framework.styles 
{
	import flash.utils.Dictionary;
	import inky.framework.styles.StyleSheet;
	import inky.framework.collections.IIterator;
	import inky.framework.styles.StyleSheetRule;
	import inky.framework.styles.StyleSheetDeclaration;


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
		private var _styleSheets:Array;


		/**
		 *
		 */
		public function StyleManager()
		{
			this._objects = new Dictionary(true);
			this._styleSheets = [];
		}


		/**
		 *	
		 */
		public function addStyleSheet(styleSheet:StyleSheet):void
		{
// TODO: Should we just expose a styleSheets list and listen for ADD/REMOVE events instead?
// TODO: Listen for changes on style sheet?
			if (this._styleSheets.indexOf(styleSheet) == -1)
			{
				this._styleSheets.push(styleSheet);
				this._updateAllObjects([styleSheet]);
			}
		}


		/**
		 *	Registers an instance with this manager.
		 */
		public function registerObject(object:IStyleable):void
		{
			if (object && (this._objects[object] === undefined))
			{
				this._objects[object] = null;
				this._updateObjectStyles(object, this._styleSheets);
			}
		}


		/**
		 *	Unregisters an instance with this manager.
		 */
		public function unregisterObject(object:IStyleable):void
		{
			delete this._objects[object];
		}




		//
		// private methods
		//


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
			var rule:StyleSheetRule;
			var rulesToApply:Array = [];

			// Determine which rules apply to the object in question.
			for each (var styleSheet:StyleSheet in styleSheets)
			{
				for (i = styleSheet.rules.iterator(); i.hasNext(); )
				{
					rule = i.next() as StyleSheetRule;
					if (rule.selector.matches(object))
						rulesToApply.push(rule);
				}
			}
// TODO: "cascade" styles. (figure out how the declarations impact eachother.) Does this require us to keep track of which rules are applied to each object (so that we have the selectors)?

			// Apply the styles.
			for each (rule in rulesToApply)
			{
				for (i = rule.declarations.iterator(); i.hasNext(); )
				{
					var declaration:StyleSheetDeclaration = i.next() as StyleSheetDeclaration;
					object.setStyle(declaration.property, declaration.value);
				}
			}
		}




	}
}