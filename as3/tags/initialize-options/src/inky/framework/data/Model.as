package inky.framework.data
{
	import inky.framework.core.IInkyDataParser;
	import inky.framework.core.Section;
	import inky.framework.data.ModelData;
	import inky.framework.managers.MarkupObjectManager;
	import flash.events.EventDispatcher;


	/**
	 *
	 * <p>Stores data for your application. Models are IInkyDataParsers, which
	 * means that their Inky XML is parsed in a special manner.</p>
	 *	
	 * <p>The &lt;data> node of the &lt;inky:Model> tag is compiled into a tree
	 * of ActionScript objects. The following is an example usage of the
	 * &lt;inky:Model> tag:</p>
	 * 
	 * <listing>
	 * &lt;inky:Model inky:id="myModel">
	 *     &lt;data>
	 *         &lt;name>
	 *             &lt;first>John&lt;/first>
	 *             &lt;last>Doe&lt;/last>
	 *         &lt;/name>
	 *         &lt;email>jd&#64;someplace.com&lt;/email>
	 *     &lt;/data>
	 * &lt;/inky:Model>
	 * </listing>
	 *
	 * <p>The model can then be used in binding expressions as follows:</p>
	 *	
	 * <listing>
	 * &lt;t:TextField text="{myModel.data.name.first}" />
	 * </listing>
	 *	
	 * @see inky.framework.core.IInkyDataParser	
	 *
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.06.04
	 *
	 */
	public class Model extends EventDispatcher implements IInkyDataParser
	{
		private var _data:ModelData;
		namespace local = '';


		/**
		 *
		 * Create a new Model instance. Models are created by the framework as
		 * a result of &lt;inky:Model> tags.
		 *
		 */	
	    public function Model()
		{
			this._data = new ModelData();
		}




		//
		// accessors
		//


		/**
		 *
		 * The model's data.
		 *
		 */
		public function get data():ModelData
		{
			return this._data;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function parseData(xml:XML):void
		{
// TODO: Set properties that aren't nested in data node.
			for each (var i:XML in xml.data.*)
			{
				this._createModelData(this.data, i);
			}
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 *	
		 */
		private function _createModelData(modelData:ModelData, xml:XML):void
		{
			if (!xml.*.(namespace() == local).length())
			{
				var mom:MarkupObjectManager = Section.getSection(this).markupObjectManager;
				mom.setProperty(modelData, xml);
			}
			else
			{
// TODO: If node only has other modeldata objects, just use a regular object?
				var newModelData:ModelData = new ModelData();
				modelData[xml.localName()] = newModelData;
				for each (var i:XML in xml.*)
				{
					this._createModelData(newModelData, i);
				}
			}
		}




	}
}
