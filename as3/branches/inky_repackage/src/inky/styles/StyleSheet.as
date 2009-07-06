package inky.styles 
{
	import inky.collections.IIterator;
	import inky.collections.IList;
	import inky.collections.ArrayList;
	import inky.styles.StyleSheetRule;
	import inky.styles.selectors.SelectorParser;
	import inky.styles.selectors.ISelector;


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
	public class StyleSheet
	{
		private var _rules:IList;
		private static var _selectorParser:SelectorParser = new SelectorParser();
		private static var rulePattern:RegExp = /([^{]+){([^}]+)}/g;
		private static var declarationPattern:RegExp = /\s*([^\:]+)\s*:\s*([^;]+);/g;
		private static var selectorSeparator:RegExp = /\s*,\s*/;


		/**
		 *
		 */
		public function StyleSheet()
		{
		}


		/**
		 *	
		 */
		public function parseCSS(cssText:String):void
		{
			var ruleMatches:Array;
			var declarationMatches:Array;
			while (ruleMatches = rulePattern.exec(cssText))
			{
				var selectorListText:String = ruleMatches[1];
				var declarationsText:String = ruleMatches[2];
				
				// Create the rule and add it to the list.
				var rule:StyleSheetRule = new StyleSheetRule();
				this.rules.addItem(rule);

				// Parse out the comma-delimited list of selectors.
				for each (var selectorText:String in selectorListText.split(selectorSeparator))
				{
					// Create the selector and add it to the rule.
					var selector:ISelector = StyleSheet._selectorParser.parse(selectorText);
					rule.selectors.addItem(selector);
				}
				
				// Add the declarations to the rule.
				while (declarationMatches = declarationPattern.exec(declarationsText))
				{
					var cssProperty:String = declarationMatches[1];
					var value:String = declarationMatches[2];
					var declaration:StyleSheetDeclaration = new StyleSheetDeclaration(cssProperty, value);
					rule.declarations.addItem(declaration);
				}
			}
		}
		
		
		/**
		 *	
		 */
		public function get rules():IList
		{
			if (!this._rules)
				this._rules = new ArrayList();
			return this._rules;
		}

		
		/**
		 *	
		 */
		public function toCSSString():String
		{
			var ruleStrings:Array = [];
			var j:IIterator;
			for (var i:IIterator = this.rules.iterator(); i.hasNext(); )
			{
				var selectorStrings:Array = [];
				var rule:StyleSheetRule = i.next() as StyleSheetRule;
				
				for (j = rule.selectors.iterator(); j.hasNext(); )
				{
					var selector:ISelector = j.next() as ISelector;
					selectorStrings.push(selector.toCSSString());
				}
				
				var declarations:IList = rule.declarations
				var declarationStrings:Array = [];
				for (j = declarations.iterator(); j.hasNext(); )
				{
					var declaration:StyleSheetDeclaration = j.next() as StyleSheetDeclaration;
					declarationStrings.push("\t" + declaration.cssProperty + ": " + declaration.value + ";");
				}
				
				ruleStrings.push(selectorStrings.join(",\n") + " {\n" + declarationStrings.join("\n") + "\n}");
			}
			return ruleStrings.join("\n\n");
		}




	}
}