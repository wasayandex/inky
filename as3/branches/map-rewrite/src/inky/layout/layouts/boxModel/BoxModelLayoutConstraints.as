package inky.layout.layouts.boxModel
{
	import inky.layout.ILayoutConstraints;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.07.27
	 *
	 */
	public class BoxModelLayoutConstraints implements ILayoutConstraints
	{
		public var position:String;
		public var top:Number;
		public var left:Number;
		public var right:Number;
		public var bottom:Number;

// TODO: Add float, margin, padding, and any other css-p properties.

		/**
		 *
		 */
		public function BoxModelLayoutConstraints(data:Object)
		{
			this.position = data.position;
			this.top = data.top;
			this.left = data.left;
			this.right = data.right;
			this.bottom = data.bottom;
		}


		/**
		 *	@inheritDoc
		 */
		public function clone():Object
		{
			return new BoxModelLayoutConstraints({position: this.position, top: this.top, left: this.left, right: this.right, bottom: this.bottom});
		}


		
	}
	
}