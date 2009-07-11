package
{
	import flash.text.TextField;
	import inky.core.Section;


	/**
	 *
	 * ..
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  30.01.2008
	 *
	 */
	public class ZipSection extends Section
	{

		public function set data(data:Object):void
		{
			this.textField.text = data.content.toXMLString();
		}

	}
}