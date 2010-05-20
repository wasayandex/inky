package inky.layout.layouts 
{
	import inky.layout.ILayout;
	import flash.utils.Dictionary;
	import inky.layout.ILayoutConstraints;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.22
	 *
	 */
	public class AbstractConstrainedLayout implements ILayout
	{
		private var constraints:Dictionary;

		/**
		 *
		 */
		public function AbstractConstrainedLayout()
		{
			this.constraints = new Dictionary(true);
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Gets the constraints associated with a DisplayObject.
		 */
		public function getConstraints(obj:DisplayObject):ILayoutConstraints
		{
			return this.constraints[obj];
		}

		/**
		 * @inheritDoc
		 */
		public function layoutContainer(container:DisplayObjectContainer, layoutItems:Array = null):void
		{
			throw new Error("You must override layoutContainer()");
		}

		/**
		 * Set constraints for a DisplayObject whose parent is registered with
		 * this layout.
		 *
		 * @param obj
		 *     the DisplayObject whose constraints to set
		 * @param constraints
		 *     the constraints to apply to the given DisplayObject
		 *
		 * @throws ArgumentError
		 *     thrown if the supplied DisplayObject is not a child of a
		 *     registered container
		 */
		public function setConstraints(obj:DisplayObject, constraints:ILayoutConstraints):void
		{
			// Clone constraints so the same object can be changed and set as
			// constraints on another element.
			constraints = constraints.clone() as ILayoutConstraints;

			this.constraints[obj] = constraints;
		}
		
	}
	
}