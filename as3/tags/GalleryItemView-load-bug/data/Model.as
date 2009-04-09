package inky.framework.data
{
	import inky.framework.core.IInkyDataParser;
	import inky.framework.core.Section;
	import inky.framework.managers.MarkupObjectManager;
	import inky.framework.utils.ObjectProxy;
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
	dynamic public class Model extends ObjectProxy implements IInkyDataParser
	{
		namespace local = '';


		/**
		 *
		 * Create a new Model instance. Models are created by the framework as
		 * a result of &lt;inky:Model> tags.
		 *
		 */	
	    public function Model()
		{
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function parseData(xml:XML):void
		{
			var dataNodes:XMLList = xml.*;
			dataNodes = dataNodes.length() ? dataNodes[0].* : null;

			for each (var i:XML in dataNodes)
			{
				this._createModelData(this, i);
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
		private function _createModelData(modelData:ObjectProxy, xml:XML):void
		{
			if (!xml.*.(namespace() == local).length())
			{
				var section:Section = Section.getSection(this);
				var mom:MarkupObjectManager = section ? section.markupObjectManager : MarkupObjectManager.masterMarkupObjectManager;
				mom.setProperty(modelData, xml);
			}
			else
			{
// TODO: If node only has other ObjectProxy objects, just use a regular object?
				var newModelData:ObjectProxy = new ObjectProxy();
				modelData[xml.localName()] = newModelData;
				for each (var i:XML in xml.*)
				{
					this._createModelData(newModelData, i);
				}
			}
		}




	}
}
