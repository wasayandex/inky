package inky.sequencing 
{
	import inky.sequencing.commands.CallCommand;
	import inky.sequencing.ISequence;
	import inky.sequencing.CommandData;
	import inky.sequencing.commands.DispatchEventCommand;
	import inky.sequencing.parsers.ICommandDataParser;
	import inky.sequencing.parsers.StandardCommandDataParser;
	import inky.sequencing.parsers.DispatchEventParser;
	import inky.sequencing.commands.DelayCommand;
	import inky.sequencing.parsers.WaitParser;
	import inky.sequencing.parsers.GTweenParser;
	import inky.sequencing.commands.GTweenCommand;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.29
	 *
	 */
	public class XMLSequence implements ISequence
	{
		private var commandData:Array = [];
		private var parserRegistry:Object = {};
		private var commandRegistry:Object = {};
		private var source:XML;
		private static var standardParser:ICommandDataParser;
		
		/**
		 *
		 */
		public function XMLSequence(source:XML)
		{
			this.source = source;
			this.registerCommand("call", CallCommand);
			this.registerCommand("CallCommand", CallCommand);
			this.registerCommand("dispatchEvent", null, new DispatchEventParser());
			this.registerCommand("DispatchEventCommand", DispatchEventCommand);
			this.registerCommand("wait", null, new WaitParser());
			this.registerCommand("DelayCommand", DelayCommand);
			this.registerCommand("tweenProperties", null, new GTweenParser());
			this.registerCommand("GTweenCommand", GTweenCommand);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return this.source.*.length();
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function getCommandAt(index:int):Object
		{
			if (index < 0 || index >= this.length)
				throw new RangeError("The specified index is out of bounds.");

			var data:Object = this.getCommandDataAt(index);
			return data.command;
		}

		/**
		 * 
		 */
		public function getCommandDataAt(index:int):CommandData
		{
			var data:CommandData = this.commandData[index];
			if (!data)
			{
				var xml:XML = this.source.*[index];
				data =
				this.commandData[index] = this.parseCommandData(xml);
			}
			return data;
		}

		/**
		 * Registers a command with the sequence. Normal use is to omit the
		 * third argument, however, if you want to specify a custom parser,
		 * you may pass <code>null</code> for the second argument (assuming
		 * your custom parser allows it).
		 */
		public function registerCommand(name:Object, type:Class, parser:ICommandDataParser = null):void
		{
			var qName:QName;
			
			if (name is QName)
				qName = QName(name);
			else if (name is String)
				qName = new QName("", String(name));
			else throw new ArgumentError("Name parameter must be either a String or QName");

			this.parserRegistry[name] = parser;
			this.commandRegistry[name] = type;
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function parseCommandData(xml:XML):CommandData
		{
// TODO: Allow custom parser objects. (Third arg of registerCommand?)
			var data:CommandData;
			var name:QName = xml.name();

			if (!this.commandRegistry.hasOwnProperty(name))
				throw new Error("There is no command registered for the name " + name);

			var parser:ICommandDataParser = this.getParser(xml);
			return parser.parse(xml, this.commandRegistry[name]);
		}
		
		/**
		 * 
		 */
		private function getParser(xml:XML):ICommandDataParser
		{
			var name:QName = xml.name();
			var parser:ICommandDataParser = this.parserRegistry[name];
			if (!parser)
			{
				parser =
				XMLSequence.standardParser = XMLSequence.standardParser || new StandardCommandDataParser();
			}
			return parser;
		}

	}
	
}