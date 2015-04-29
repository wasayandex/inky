# Overview #

Before diving into your first inky application, it's necessary to understand a few simple things about the framework.

Inky allows you to create complex Flash applications with specially formatted XML.  In general, this XML is stored in an external file (i.e. not compiled into your SWF) which has the extension ".inky.xml". The framework loads your inky XML file at runtime and parses it to create your application.  The easiest way to tell your SWF which XML file to use is to give it the same name as your SWF and place it in the same directory.  For example, if your SWF is named 'filename.swf', your inky xml file would be named 'filename.inky.xml'. (If this is not an option, you can specify an alternative XML source using the Application's [dataSource](http://docs.inkyframework.com/as3/inky/framework/core/Application.html#dataSource) property, or by sending your SWF a `dataSource` variable.)

The root node of an inky XML is always an Application element in the inky namespace:

```
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky">
</inky:Application>
```

Inky uses xml namespaces in a few different places so you may want to brush up on them before continuing.


# Your First Application #

## Setup ##

To start your inky project, create a new FLA and save it as "MyFirstApplication.fla". Set the Document class to "inky.framework.core.Application" and make sure that the inky classes are in your class path. Create a new XML file in your publish directory (by default, the same directory as your FLA) and name it "MyFirstApplication.inky.xml". Paste the following into your XML file:

```
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky">
</inky:Application>
```

You've created your first inky application!  Now let's make it do something.


## Creating Objects ##

In order to add Objects to your inky application, you need only add a corresponding element to your inky XML.  The name of the element must be the name of the class, and the namespace must be the package to which the class belongs.  For our example, we'll be working with objects from the `flash.text.*` package, so we first have to define a namespace that points to that package.

```
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky" xmlns:t="flash.text.*">
</inky:Application>
```

Now we will be able to create nodes with the prefix "t", and inky will know that those nodes represent classes in the flash.text package.  We could have chosen anything for our prefix, but "t" is short so we'll stick with that for now.

Having defined our namespace, we can now create instances of classes in the flash.text package.  Edit your inky XML file as follows:

```
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky" xmlns:t="flash.text.*">
	<t:TextField />
</inky:Application>
```

A [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) instance will now be created when you run your inky application.  Also (because [TextFields](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) are [DisplayObjects](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html)), inky will automatically add it to the stage.  Of course, it's pointless to add a [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) if it doesn't have any text. Fortunately, inky makes setting properties just as easy as creating objects.

## Setting Properties ##

To set the `text` property of our newly created [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html), simply add a `text` attribute to the element in your XML as follows.

```
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky" xmlns:t="flash.text.*">
	<t:TextField text="Hello World" />
</inky:Application>
```

Now when you run your SWF (no need to republish!), you should see the "Hello World" text.  If you don't, make sure that your XML file has the same name as your SWF (except for the .inky.xml extension) and is in the same directory, the inky classes are in your classpath, and your FLA is using "inky.framework.core.Application" as its document class.

Attributes aren't the only way to set properties.  You can also use child nodes. For example:

```
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky" xmlns:t="flash.text.*">
	<t:TextField>
		<text>Hello World</text>
	</t:TextField>
</inky:Application>
```

Both styles have the same effect and are, for the most part, interchangeable. You can also use both styles on a single element (for example, set the `text` property as an attribute, but the `y` property as a child node).  However, there are some situations where you _must_ use a child node..


### Complex Property Values and Source Order ###

If the property value is not a Number or String, the property cannot be set with an attribute.  Instead, we must create the object with an XML element (like the [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) above).  For example, the following XML will create a [TextFormat](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextFormat.html) object and sets its [color](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextFormat.html#color) property to red when added to our application.

```
<t:TextFormat color="0xff0000" />
```

By combining that with what we know about setting properties, it's a snap to apply our [TextFormat](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextFormat.html) object to our [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html).

```
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky" xmlns:t="flash.text.*">
	<t:TextField>
		<defaultTextFormat>
			<t:TextFormat color="0xff0000" />
		</defaultTextFormat>
		<text>Hello World</text>
	</t:TextField>
</inky:Application>
```


In this example, we are forced to use a child node (as opposed to an attribute) to set our [defaultTextFormat](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html#defaultTextFormat) property because of the complexity of the [TextFormat](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextFormat.html) object. What may not be immediately obvious, though, is that we must also use a child node to set the `text` property.  The reason is that properties are processed in source order.  In other words, the above XML translates roughly into the following ActionScript:

```
var myTextField:TextField = new TextField();
var tf:TextFormat = new TextFormat();
tf.color = 0xff0000;
myTextField.defaultTextFormat = tf;
myTextField.text = 'Hello World, Also!';
```

If, however, the `text` property were set as an attribute of our [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) node, OR if the `text` node came before the `defaultTextFormat` node, the [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html)'s `text` property would be set _before_ its [defaultTextFormat](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html#defaultTextFormat) property, like in the following code:

```
var myTextField:TextField = new TextField();
var tf:TextFormat = new TextFormat();
tf.color = 0xff0000;
myTextField.text = 'Hello World, Also!';
myTextField.defaultTextFormat = tf;
```

Because the default text format doesn't affect text already in the field, it would appear as though our [TextFormat](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextFormat.html) had not been applied.

## Manipulating Stage Instances ##

Creating objects in XML makes many things much easier. However, one of the main draws of the Flash authoring environment is that it makes design and layout intuitive. Fortunately, you don't have to leave the IDE behind to take advantage of inky's features: in addition to being able to create objects and automatically add them to the stage, the framework is also capable of manipulating objects that you've positioned on stage in the Flash authoring environment.

Return to your FLA and create a dynamic [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) on the stage. Give it an instance name of "myTextField" and change its font, color, and position. Edit your inky XML file as follows:

```
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky" xmlns:t="flash.text.*">
	<t:TextField name="myTextField" text="Hello World" />
</inky:Application>
```

Notice the addition of the name attribute on the TextField node. This tells inky that the data corresponds to a [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) with the name "myTextField". If no [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) exists with that name, the framework will create a new instance, add it to the stage, and give it that name (as in the previous examples).  But be careful!  If you mistype the instance name, inky will create a new [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) (with the misspelled name) and you'll wind up with two.

Publish the FLA and the [TextField](http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/TextField.html) instance you placed on the stage will have its `text` property set to "Hello World". Best of all, the instance need not be on the first frame; inky is smart enough to wait for it.

By employing this technique, your inky application can take advantage of the WSYIWYG style editing that the Flash authoring environment offers.






