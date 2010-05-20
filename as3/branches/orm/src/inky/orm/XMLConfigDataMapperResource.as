package inky.orm 
{
	import inky.orm.DataMapperResource;
	import inky.orm.inspection.ITypeInspector;
	import inky.orm.inspection.XMLTypeInspector;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.05.20
	 *
	 */
	public class XMLConfigDataMapperResource extends DataMapperResource
	{
		private var xml:XML;
		
		/**
		 *
		 */
		public function XMLConfigDataMapperResource(xml:XML)
		{
			if (this.xml && xml != this.xml)
				throw new ArgumentError();
			this.xml = xml;
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function _createTypeInspector():ITypeInspector
		{
			return new XMLTypeInspector(this.xml);
		}

	}
	
}