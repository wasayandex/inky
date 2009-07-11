package inky.loading.loaders
{
	import flash.events.IEventDispatcher;


	/**
     * 
     * <p>Dispatched when an IAssetLoader's content becomes accessible, after
     * the object's <code>load()</code> method is called. This event is like
     * Event.COMPLETE, except that it is guaranteed to be dispatched when the
     * <code>load()</code> method is called, even if the item was already
     * loaded.</p>
     *
     * @eventType inky.loading.events.AssetLoaderEvent.READY
     *
     */
	[Event(name="ready", type="inky.loading.events.AssetLoaderEvent")]




	/**
	 *
	 *  <p>Loads external assets for use in an inky application. In general,
	 *	the asset loader classes (XMLLoader, ImageLoader, etc.) are not created
	 *	directly by the user. Instead, the framework creates an instance from
	 *	correseponding nodes in the inky XML.</p>
	 *	
	 *	<p>An example of an XMLLoader being used as a property value:</p>
	 *	
	 *	<listing>
	 *	&lt;inky:Application xmlns:inky="http://exanimo.com/2008/inky"
	 *	    xmlns:custom="&#42;">
	 *	    &lt;custom:MyComponent>
	 *	        &lt;data>
	 *	            &lt;inky:XMLLoader source="my.xml" preload="true" />
	 *	        &lt;/data>
	 *	    &lt;/custom:MyComponent>
	 *	&lt;/inky:Application>
	 *	</listing>
	 *	
	 *	<p>An example of a property being bound to loaded XML:</p>
	 *	
	 *	<listing>
	 *	&lt;inky:Application xmlns:inky="http://exanimo.com/2008/inky"
	 *	    xmlns:custom="&#42;">
	 *	    &lt;custom:MyComponent data="{myXMLLoader.content}" />
	 *	    &lt;inky:XMLLoader inky:id="myXMLLoader" source="my.xml" preload="true" />
	 *	&lt;/inky:Application>
	 *	</listing>
	 *	
	 *	<p>In the first example, the MyComponent's <code>data</code> property
	 *	is set to the XMLLoader instance whereas, in the second example, the
	 *	<code>data</code> property is set to the loaded XML. Note that, in the
	 *	second example, if the XML is not loaded when the the component is
	 *	created the component's <code>data</code> property will first be set to
	 *	<code>null</code>. Once the XML finishes loading, the XMLLoader's
	 *	<code>content</code> property will change and the component's
	 *	<code>data</code> property will be updated with the correct value.
	 * 
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Matthew Tretter
	 *  @since  2008.05.29
	 *
	 */
	public interface IAssetLoader extends IEventDispatcher
	{
		//
		// accessors
		//


		/**
		 *
		 * Indicates the number of bytes that have been loaded thus far during
		 * the load operation.
		 *
		 */
		function get bytesLoaded():uint;


		/**
		 *
		 * Indicates the total number of bytes in the downloaded data.
		 *	
		 */
		function get bytesTotal():uint;


		/**
		 *
		 * The content that is being loaded. Note that the content may not be
		 * available until the AssetLoaderEvent.READY event is dispatched.
		 * 
		 * @see inky.loading.events.AssetLoaderEvent#READY
		 * 
		 */
		function get content():Object;


		/**
		 *
		 */
		function get loaded():Boolean;


		/**
		 *
		 * Specifies whether the Asset should be preloaded by the Application
		 * before its containing section is created.
		 * 
		 * @default false
		 * 
		 */
		function get preload():Boolean;
		/**
		 * @private
		 */
		function set preload(preload:Boolean):void;


		/**
		 *
		 * The file to load. URLs (Strings) and URLRequests are valid values.
		 *
		 * @default null
		 * 
		 */
		function get source():Object;
		/**
		 * @private
		 */
		function set source(source:Object):void;




		//
		// public methods
		//


		/**
		 *
		 * Closes the load operation in progress. Any load operation in
		 * progress is immediately terminated. If no URL is currently being
		 * streamed, an invalid stream error is thrown.
		 *
		 */
		function close():void;


		/**
		 *
		 * Adds the asset to the queue of loading assets.
		 * 
		 * @param source
		 *    The file to load. URLs (Strings) and URLRequests are valid
		 *    values.
		 * 	
		 */
		function load(source:Object = null):void;


		/**
		 * @private
		 *
		 * Immediately loads the asset, bypassing the application's queue.
		 *	
		 */
		function loadAsset():void;


		/**
		 *
		 * Adds the asset at the front of the queue of loading assets.
		 * 
		 * @param source
		 *    The file to load. URLs (Strings) and URLRequests are valid
		 *    values.
		 * 
		 */
		function loadNow(source:Object = null):void;




	}
}
