package inky.framework.styles.selectors 
{
	import inky.framework.styles.selectors.ISelector;
	import inky.framework.styles.StyleSheet;
	import inky.framework.styles.selectors.SelectorSet;
	import inky.framework.styles.selectors.ISelector;
	import inky.framework.styles.selectors.IdSelector;
	import inky.framework.styles.selectors.ClassSelector;
	import inky.framework.styles.selectors.ChildCombinator;
	import inky.framework.styles.selectors.DescendantCombinator;
	import inky.framework.styles.selectors.UniversalSelector;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.06.15
	 *
	 */
	public class SelectorParser
	{
		
		/**
		 *
		 */
		public function SelectorParser()
		{
		}


		public function parse(text:String):ISelector
		{
// TODO: Make regexps more accurate.
// TODO: Add parsing errors
// FIXME: *.someclass doesn't work
			var match:Object;
			var selector:ISelector;
			var i:int;
			var index:int;
			var selectorSet:SelectorSet;

			// Take out the extra whitespace.
			text = text.replace(/^\s+/, "").replace(/\s+$/, "");

			// Child Combinator
			if ((match = text.match(/(.+)>\s*([^>\s+]+)$/)))
			{
				selectorSet = new SelectorSet();

				// Add the last part, recursively parsing for other rules.
				selectorSet.addItem(this.parse(match[2]));
				
				// Add the first part.
				var childCombinator:ChildCombinator = new ChildCombinator();
				childCombinator.relatedSelector = this.parse(match[1]);
				selectorSet.addItem(childCombinator);

				selector = selectorSet;
			}
			
			// Descendant Combinator
			else if ((match = text.match(/(.+)\s+([\S]+)$/)))
			{
				selectorSet = new SelectorSet();

				// Add the last part, recursively parsing other rules.
				selectorSet.addItem(this.parse(match[2]));
				
				// Add the first part
				var descendantCombinator:DescendantCombinator = new DescendantCombinator();
				descendantCombinator.relatedSelector = this.parse(match[1]);
				selectorSet.addItem(descendantCombinator);
				
				selector = selectorSet;
			}
			
			// universal selector
			else if (text == "*")
			{
				selector = new UniversalSelector();
			}
			
			// id selector
			else if ((match = text.match(/^#([\w\\\.\-]+)(.*)/)))
			{
				var id:String = match[1];
				if (match[2])
				{
					selectorSet = new SelectorSet();
					selectorSet.addItem(new IdSelector(id));
					selectorSet.addItem(this.parse(match[2]));
					selector = selectorSet;
				}
				else
				{
					selector = new IdSelector(id);
				}
			}
			
			// class selector
			else if ((match = text.match(/^\.([\w\\\.\-]+)(.*)/)))
			{
				var className:String = match[1].replace(/\\\./g, ".");

				if (match[2])
				{
					selectorSet = new SelectorSet();
					selectorSet.addItem(new ClassSelector(className));
					selectorSet.addItem(this.parse(match[2]));
					selector = selectorSet;
				}
				else
				{
					selector = new ClassSelector(className);
				}
			}
			else
			{
				throw new Error("Couldn't parse \"" + text + "\"");
			}

			return selector;
		}


		
	}
	
}