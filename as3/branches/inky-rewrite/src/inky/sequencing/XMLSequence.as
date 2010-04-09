package inky.sequencing 
{
	import inky.sequencing.commands.CallCommand;
	import inky.sequencing.ISequence;
	import inky.sequencing.commands.DispatchEventCommand;
	import inky.sequencing.parsers.xml.IXMLCommandParser;
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
	import inky.sequencing.parsers.CommandParserUtil;
	
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
		private static const VARIABLE_REFERENCE:RegExp = /^#(.*)$/;
		private var commands:Array = [];
		private var parserRegistry:Object = {};
		private var commandRegistry:Object = {};
		private var id:String;
		private var source:XML;
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

			var command:Object = this.commands[index];
			if (!command)
			{
				var xml:XML = this.source.*[index];
				command = this.getParser(xml).createCommand(xml);
				this.commands[index] = command;
			}
			
			return command;
		}

		/**
		 * Registers a command with the sequence. Normal use is to omit the
		 * third argument, however, if you want to specify a custom parser,
		 * you may pass <code>null</code> for the second argument (assuming
		 * your custom parser allows it).
		 */
		public function registerCommand(name:Object, type:Class, parser:IXMLCommandParser = null):void
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
		private function getParser(xml:XML):IXMLCommandParser
		{
			var name:QName = xml.name();
			var parser:IXMLCommandParser = this.parserRegistry[name];
			if (!parser)
				throw new Error("No parser registered for " + xml.name());
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
			var xml:XML = this.source.*[this.currentIndex].copy();
			var properties:Object = {};
			var match:Object;
			
			for each (var attr:XML in xml.@*)
			{
				var attrValue:String = attr.toString();
				var attrName:String = attr.localName();
				var value:*;
				
				if ((match = attrValue.match(VARIABLE_REFERENCE)))
					value = CommandParserUtil.evaluatePropertyChain(this.variables, match[1].split("."));
				else
					value = CommandParserUtil.formatValue(attrValue);

				properties[attrName] = value;
			}

			var parser:IXMLCommandParser = this.getParser(xml);
			parser.setCommandProperties(command, properties);
		}

	}
	
}