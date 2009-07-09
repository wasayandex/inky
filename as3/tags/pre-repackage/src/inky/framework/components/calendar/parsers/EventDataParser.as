package inky.framework.components.calendar.parsers 
{
	import inky.framework.components.calendar.parsers.IEventDataParser;
	import inky.framework.components.calendar.models.EventModel;

	
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
	 *	@since  2009.03.20
	 *
	 */
	public class EventDataParser implements IEventDataParser
	{

		public function parse(data:XML):EventModel
		{
			var model:EventModel = new EventModel();

			// Set the model properties
			for each (var prop:XML in data.attributes())
			{
				model[String(prop.localName())] = String(prop);
			}
			model.description = data.description;
			return model;
		}

	}
	
}
