package inky.framework.components.calendar.parsers 
{
	import inky.framework.components.calendar.models.DateModel;
	import inky.framework.components.calendar.parsers.IDateDataParser;

	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.03.18
	 *
	 */
	public class DateDataParser implements IDateDataParser
	{
		
		public function parse(data:XML):DateModel
		{
			var model:DateModel = new DateModel();
			
			// Set the model properties
			for each (var prop:XML in data.attributes())
			{
				model[String(prop.localName())] = String(prop);
			}
			model.selectDate(new Date(data.@year, data.@month, data.@date));
			return model;
		}

	}
	
}
