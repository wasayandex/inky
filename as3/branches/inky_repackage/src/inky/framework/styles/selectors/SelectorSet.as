package inky.framework.styles.selectors 
{
	import inky.framework.collections.ArrayList;
	import inky.framework.styles.selectors.ISelector;
	import inky.framework.collections.IIterator;

	
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
	public class SelectorSet extends ArrayList implements ISelector
	{

		/**
		 *	@inheritDoc
		 */
		public function get specificity():uint
		{
// TODO: This should be updated as you manipulate the list, not calculated each time it's requested.
			var specificity:uint = 0;
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var selector:ISelector = i.next() as ISelector;
				specificity += selector.specificity;
			}
			return specificity;
		}



		/**
		 * @inheritDoc
		 */
		public function matches(object:Object):Boolean
		{
			var matches:Boolean = true;
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var selector:ISelector = i.next() as ISelector;
				matches = matches && selector.matches(object);
				if (!matches)
					break;
			}
			return matches;
		}



		/**
		 *	@inheritDoc
		 */
		public function toCSSString():String
		{
			var output:String = "";
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var selector:ISelector = i.next() as ISelector;
				output = selector.toCSSString() + output;
			}
			return output;
		}

	}
}