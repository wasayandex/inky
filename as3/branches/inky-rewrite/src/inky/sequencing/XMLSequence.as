package inky.sequencing 
{
	import inky.sequencing.commands.CallCommand;
	import inky.sequencing.ISequence;
	import inky.sequencing.CommandData;
	import inky.sequencing.commands.DispatchEventCommand;
	import inky.sequencing.parsers.xml.IXMLCommandDataParser;
	import inky.sequencing.parsers.xml.StandardCommandDataParser;
	import inky.sequencing.parsers.xml.DispatchEventParser;
	import inky.sequencing.commands.DelayCommand;
	import inky.sequencing.parsers.xml.WaitParser;
	import inky.sequencing.parsers.xml.GTweenParser;
	import inky.sequencing.commands.GTweenCommand;
	import inky.sequencing.parsers.xml.SetParser;
	import inky.sequencing.commands.SetPropertiesCommand;
	import inky.sequencing.parsers.xml.CallParser;
	import inky.sequencing.AbstractSequence;
	import inky.sequencing.commands.LoadCommand;
	import inky.sequencing.parsers.xml.LoadParser;
	
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
	public class XMLSequence extends AbstractSequence implements ISequence
	{
		private var commandData:Array = [];
		private var parserRegistry:Object = {};
		private var commandRegistry:Object = {};
		private var id:String;
		private var source:XML;
		private static var standardParser:IXMLCommandDataParser;
		private var _variables:Object;
		
		/**
		 *
		 */
		public function XMLSequence(source:XML, variables:Object = null, id:String = "sequence")
		{
			this.id = id;
			this._variables = variables || {};

			if (this._variables[id] && (this._variables[id] != this))
				throw new ArgumentError("The id \"" + id + "\" is already being used on the provided variables for another sequence.")
			
			this._variables[id] = this;
			
			this.source = source;
// TODO: Don't create all these parsers up front for each instance! Create lazily and reuse!
			this.registerCommand("call", null, new CallParser());
			this.registerCommand("CallCommand", CallCommand);
			this.registerCommand("dispatchEvent", null, new DispatchEventParser());
			this.registerCommand("DispatchEventCommand", DispatchEventCommand);
			this.registerCommand("wait", null, new WaitParser());
			this.registerCommand("DelayCommand", DelayCommand);
			this.registerCommand("tween", null, new GTweenParser());
			this.registerCommand("GTweenCommand", GTweenCommand);
			this.registerCommand("set", null, new SetParser());
			this.registerCommand("SetPropertiesCommand", SetPropertiesCommand);
			this.registerCommand("load", null, new LoadParser());
			this.registerCommand("LoadCommand", LoadCommand);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get length():int
		{
			return this.source.*.length();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get variables():Object
		{
			return this._variables;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function getCommandAt(index:int):Object
		{
			if (index < 0 || index >= this.length)
				throw new RangeError("The specified index is out of bounds.");

			var data:Object = this.getCommandDataAt(index);
			return data.command;
		}

		/**
		 * Registers a command with the sequence. Normal use is to omit the
		 * third argument, however, if you want to specify a custom parser,
		 * you may pass <code>null</code> for the second argument (assuming
		 * your custom parser allows it).
		 */
		public function registerCommand(name:Object, type:Class, parser:IXMLCommandDataParser = null):void
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
		private function getCommandDataAt(index:int):CommandData
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
		 * 
		 */
		private function parseCommandData(xml:XML):CommandData
		{
			var data:CommandData;
			var name:QName = xml.name();

			if (!this.commandRegistry.hasOwnProperty(name))
				throw new Error("There is no command registered for the name " + name);

			var parser:IXMLCommandDataParser = this.getParser(xml);
			return parser.parse(xml, this.commandRegistry[name]);
		}
		
		/**
		 * 
		 */
		private function getParser(xml:XML):IXMLCommandDataParser
		{
			var name:QName = xml.name();
			var parser:IXMLCommandDataParser = this.parserRegistry[name];
			if (!parser)
			{
				parser =
				XMLSequence.standardParser = XMLSequence.standardParser || new StandardCommandDataParser();
			}
			return parser;
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 * Prepares the command for execution.
		 */
		override protected function onBeforeCommandExecute():void
		{
			var command:Object = this.currentCommand;
			var injectors:Array = this.commandData[this.currentIndex].injectors;
			
			for each (var injector:Function in injectors)
			{
				injector(command, this.variables);
			}
		}

	}
	
}