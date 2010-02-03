package inky.app.data 
{
	import inky.app.data.SectionData;
	import inky.dynamic.DynamicObject;
	import inky.app.data.ISectionData;
	
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
		private var _name:String;
		internal var _owner:ISectionData;
		
		/**
		 *
		 */
		public function SectionData(name:String)
		{
			this._name = name;
		}


		/**
		 * @inheritDoc
		 */
		public function get name():String
		{ 
			return this._name; 
		}


		/**
		 * @inheritDoc
		 */
		public function get owner():ISectionData
		{
			return this._owner;
		}


	}
	
}