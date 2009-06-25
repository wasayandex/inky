package inky.framework.styles.selectors 
{
	import inky.framework.styles.selectors.ISelector;


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
	public class DescendantCombinator implements ISelector
	{
		private var _relatedSelector:ISelector;



		/**
		 *
		 */
		public function get relatedSelector():ISelector
		{ 
			return this._relatedSelector; 
		}
		/**
		 * @private
		 */
		public function set relatedSelector(value:ISelector):void
		{
			this._relatedSelector = value;
		}


		/**
		 *	@inheritDoc
		 */
		public function get specificity():uint
		{
			return this.relatedSelector ? this.relatedSelector.specificity : 0;
		}


		/**
		 * @inheritDoc
		 */
		public function matches(object:Object):Boolean
		{
			var matches:Boolean = object.hasOwnProperty("parent") && object.parent;
			
			if (matches && this.relatedSelector)
			{
				// Need to find at least one descendant that matches the related selector.
				matches = false;
				var descendant:Object = object.parent;
				while (descendant && !matches)
				{
					matches = this.relatedSelector.matches(descendant);
					descendant = descendant.parent;
				}
			}
			return  matches;
		}


		/**
		 *	@inheritDoc
		 */
		public function toCSSString():String
		{
			return this.relatedSelector ? this.relatedSelector.toCSSString() + " " : " ";
		}

	}
	
}