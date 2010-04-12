package inky.app.data 
{
	import inky.app.data.SectionData;
	import inky.dynamic.DynamicObject;
	import inky.app.data.ISectionData;
	import inky.collections.IIterable;
	import inky.collections.Set;
	import inky.collections.IIterable;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.02.03
	 *
	 */
	public class SectionData extends DynamicObject implements ISectionData
	{
		public var className:String;
		private var _id:String;
		private var _owner:ISectionData;
		private var _subsections:Set;
		private var _viewClass:String;


		/**
		 *
		 */
		public function SectionData(id:String, viewClass:String, owner:ISectionData = null)
		{
			this._id = id;
			this._viewClass = viewClass;
			if (owner)
			{
				if (!(owner is SectionData))
					throw new ArgumentError("Custom ISectionData implementations are not supported right now");
				this._owner = owner;
				Set(SectionData(owner).subsections).addItem(this);
			}
		}


		/**
		 * @inheritDoc
		 */
		public function get id():String
		{
			return this._id;
		}


		/**
		 * @inheritDoc
		 */
		public function get owner():ISectionData
		{
			return this._owner;
		}


		/**
		 *
		 */
		public function get subsections():IIterable
		{
// TODO: The type is IIterable so people don't try to add subsections through the list, but we should probably throw an error if they try to cast it to a Set.
			if (!this._subsections)
				this._subsections = new Set();
			return this._subsections; 
		}


		/**
		 * @inheritDoc
		 */
		public function get viewClassStack():Array
		{
			var stack:Array = [];
			var section:ISectionData = this;
			while (section)
			{
// FIXME: What to do here? Do we have to make _viewClass public? Or should this array be constructed outside of the class?
				if (!(section is SectionData))
					throw new Error("Oops. You're using a different ISectionData implementation, huh? That's not supported yet.");
				else
					stack.unshift(SectionData(section)._viewClass);
				section = section.owner;
			}
			return stack; 
		}




	}
	
}