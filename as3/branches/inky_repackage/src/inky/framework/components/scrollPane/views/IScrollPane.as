package inky.framework.components.scrollPane.views
{
	import inky.framework.display.IDisplayObject;
	import inky.framework.components.scrollBar.views.IScrollBar;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;


	/**
	 *
	 * The ScrollPane component displays display objects and JPEG, GIF, and PNG
	 * files, as well as SWF files, in a scrollable area. You can use a scroll
	 * pane to limit the screen area that is occupied by these media types. The
	 * scroll pane can display content that is loaded from a local disk or from
	 * the Internet. You can set this content while authoring and, at run time,
	 * by using ActionScript. 
	 *
	 * @author    Matthew Tretter (matthew@exanimo.com)
	 *	
	 * @see http://exanimo.com/actionscript/scrollpane/	 	 
	 *	
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *	
	 */
	public interface IScrollPane extends IDisplayObject
	{
		//
		// accessors
		//


		/**
		 *
		 * Gets a reference to the content loaded into the scroll pane.
		 * 
		 * @default null		 		 
		 *
		 */
		function get content():DisplayObject;


		/**
		 *
		 * Gets or sets a value that describes the amount of content to be
		 * scrolled, horizontally, when a scroll arrow is clicked. This value is
		 * measured in pixels.
		 * 
		 * @default 4
		 *
		 */
		function get horizontalLineScrollSize():Number;
		/**
		 * @private
		 */		 		
		function set horizontalLineScrollSize(value:Number):void;


		/**
		 *
		 * Gets or sets the count of pixels by which to move the scroll thumb on
		 * the horizontal scroll bar when the scroll bar track is pressed. When
		 * this value is 0, this property retrieves the available width of the
		 * component.
		 * 
		 * @default 0
		 *
		 */
		function get horizontalPageScrollSize():Number;
		/**
		 * @private
		 */		 		
		function set horizontalPageScrollSize(value:Number):void;


		/**
		 *
		 * Gets a reference to the horizontal scroll bar.
		 *
		 */
		function get horizontalScrollBar():IScrollBar;


		/**
		 *
		 * Gets or sets a value that indicates the state of the horizontal
		 * scroll bar. A value of ScrollPolicy.ON indicates that the horizontal
		 * scroll bar is always on; a value of ScrollPolicy.OFF indicates that
		 * the horizontal scroll bar is always off; and a value of
		 * ScrollPolicy.AUTO indicates that its state automatically changes.
		 *
		 * @default ScrollPolicy.AUTO
		 *		 		 
		 */
		function get horizontalScrollPolicy():String;
		/**
		 * @private
		 */		 		
		function set horizontalScrollPolicy(horizontalScrollPolicy:String):void;


		/**
		 *
		 * Gets or sets a value that describes the horizontal position of the
		 * horizontal scroll bar in the scroll pane, in pixels.
		 * 
		 * @default 0		 		 
		 *
		 */
		function get horizontalScrollPosition():Number;
		/**
		 * @private
		 */		 		
		function set horizontalScrollPosition(value:Number):void;


		/**
		 *
		 * Gets the maximum horizontal scroll position for the current content,
		 * in pixels.
		 *
		 */
		function get maxHorizontalScrollPosition():Number;
		/**
		 * @private
		 */		 		
		function set maxHorizontalScrollPosition(value:Number):void;


		/**
		 *
		 * Gets the maximum vertical scroll position for the current content, in
		 * pixels.
		 *
		 */
		function get maxVerticalScrollPosition():Number;
		/**
		 * @private
		 */	
		function set maxVerticalScrollPosition(value:Number):void;
		

		/**
		 *
		 * Gets or sets an absolute or relative URL that identifies the
		 * location of the SWF or image file to load, the class name of a movie
		 * clip in the library, a reference to a display object, or a instance
		 * name of a movie clip on the same level as the component.
		 *	
		 * Valid image file formats include GIF, PNG, and JPEG. To load an
		 * asset by using a URLRequest object, use the load() method.
		 *
		 * @default null
		 *
		 */
		function get source():Object;
		/**
		 * @private
		 */		 		
		function set source(source:Object):void;

		
		/**
		 *
		 * When set to true, the cacheAsBitmap property for the scrolling
		 * content is set to true; when set to false this value is turned off.
		 *
		 * @default false
		 *		 		 
		 */
		function get useBitmapScrolling():Boolean;
		function set useBitmapScrolling(useBitmapScrolling:Boolean):void;

		/**
		*	When set to true the user is able to drag the ScrollPane's source within the 
		*	bounds of the ScrollPane. When set to false the value is turned off.
		*	
		*	@default false	
		*/
		function set draggable(draggable:Boolean):void;
		function get draggable():Boolean;


		/**
		 *
		 * Gets or sets a value that describes how many pixels to scroll
		 * vertically when a scroll arrow is clicked.
		 * 
		 * @default 4		 		 
		 *
		 */
		function get verticalLineScrollSize():Number;
		/**
		 * @private
		 */		 		
		function set verticalLineScrollSize(verticalLineScrollSize:Number):void;
		
		
		/**
		 *
		 * Gets or sets the count of pixels by which to move the scroll thumb on
		 * the vertical scroll bar when the scroll bar track is pressed. When
		 * this value is 0, this property retrieves the available height of the
		 * component.
		 * 
		 * @default 0		 		 
		 *
		 */
		function get verticalPageScrollSize():Number;
		/**
		 * @private
		 */		 		
		function set verticalPageScrollSize(verticalPageScrollSize:Number):void;
		
		
		/**
		 *
		 * Gets a reference to the vertical scroll bar.
		 *
		 */
		function get verticalScrollBar():IScrollBar;


		/**
		 *
		 * Gets or sets a value that indicates the state of the vertical scroll
		 * bar. A value of ScrollPolicy.ON indicates that the vertical scroll
		 * bar is always on; a value of ScrollPolicy.OFF indicates that the
		 * vertical scroll bar is always off; and a value of ScrollPolicy.AUTO
		 * indicates that its state automatically changes.
		 * 
		 * @default ScrollPolicy.AUTO		 		 
		 *
		 */
		function get verticalScrollPolicy():String;
		/**
		 * @private
		 */		 		
		function set verticalScrollPolicy(verticalScrollPolicy:String):void;


		/**
		 *
		 * Gets or sets a value that describes the vertical position of the
		 * vertical scroll bar in the scroll pane, in pixels.
		 * 
		 * @default 0		 		 
		 *
		 */
		function get verticalScrollPosition():Number;
		/**
		 * @private
		 */		 		
		function set verticalScrollPosition(verticalScrollPosition:Number):void;




		//
		// methods
		//
		
		
		/**
		 *
		 * The request parameter of this method accepts only a URLRequest object
		 * whose source property contains a string, a class, or a URLRequest
		 * object. By default, the LoaderContext object uses the current domain
		 * as the application domain. To specify a different application domain
		 * value, to check a policy file, or to change the security domain,
		 * initialize a new LoaderContext object and pass it to this method.
		 * 
		 * @param request
		 *     The URLRequest object to use to load an image into the scroll
		 *     pane.
		 * @param context
		 *     (optional) The LoaderContext object that sets the context of the
		 *     load operation.		 		 		 		 		 
		 *
		 */		
		function load(request:URLRequest, context:LoaderContext = null):void;
		
		
		/**
		 *
		 * Refreshes the scroll bar properties based on the width and height of
		 * the content. This is useful if the content of the ScrollPane changes
		 * during run time.
		 *
		 */		
		function update():void;




	}
}
