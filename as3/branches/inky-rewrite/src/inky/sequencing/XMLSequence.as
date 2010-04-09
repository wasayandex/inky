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
	import inky.sequencing.parsers.xml.TraceParser;
	import inky.sequencing.parsers.xml.XMLCommandParserRegistry;
	
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
		private var parserRegistry:XMLCommandParserRegistry;
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
				command = this.getParser(xml.name()).createCommand(xml);
				this.commands[index] = command;
			}
			
			return command;
		}

		/**
		 * 
		 */
		public function registerCommandParser(name:Object, parser:Object):void
		{
			if (!this.parserRegistry)
				this.parserRegistry = new XMLCommandParserRegistry();
			this.parserRegistry.registerParser(name, parser);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function getParser(name:Object):IXMLCommandParser
		{
			var parser:IXMLCommandParser;
			if (this.parserRegistry)
				parser = this.parserRegistry.getParser(name);
			
			if (!parser)
				parser = XMLCommandParserRegistry.globalRegistry.getParser(name);
			
			if (!parser)
				throw new Error("No parser is registered for the name \"" + name + "\".");
			
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

			var parser:IXMLCommandParser = this.getParser(xml.name());
			parser.setCommandProperties(command, properties);
		}

	}
	
}