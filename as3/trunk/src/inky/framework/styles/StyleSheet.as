package inky.framework.styles 
{
	import inky.framework.collections.IIterator;
	import inky.framework.collections.IList;
	import inky.framework.collections.ArrayList;
	import inky.framework.styles.StyleSheetRule;
	import inky.framework.styles.selectors.SelectorParser;
	import inky.framework.styles.selectors.ISelector;


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
				var selectorText:String = ruleMatches[1];
				var declarationsText:String = ruleMatches[2];
				
				// Create the rule and add it to the list.
				var rule:StyleSheetRule = new StyleSheetRule();
				this.rules.addItem(rule);
				
				// Create the selector and add it to the rule.
				var selector:ISelector = StyleSheet._selectorParser.parse(selectorText, this);
				rule.selector = selector;
				
				// Add the declarations to the rule.
				while (declarationMatches = declarationPattern.exec(declarationsText))
				{
					var property:String = declarationMatches[1];
					var value:String = declarationMatches[2];
					var declaration:StyleSheetDeclaration = new StyleSheetDeclaration(property, value);
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

		
		
		
		public function toCSSString():String
		{
			var ruleStrings:Array = [];
			for (var i:IIterator = this.rules.iterator(); i.hasNext(); )
			{
				var rule:StyleSheetRule = i.next() as StyleSheetRule;
				
				var declarations:IList = rule.declarations
				var declarationStrings:Array = [];
				for (var j:IIterator = declarations.iterator(); j.hasNext(); )
				{
					var declaration:StyleSheetDeclaration = j.next() as StyleSheetDeclaration;
					declarationStrings.push("\t" + declaration.property + ": " + declaration.value + ";");
				}
				
				ruleStrings.push(rule.selector.toCSSString() + " {\n" + declarationStrings.join("\n") + "\n}");
			}
			return ruleStrings.join("\n\n");
		}
		
		
	}
	
}