# Overview #

This tutorial will walk you through the building of a simple application for an imaginary company named "Sylvio's Petsitters."  The application will makes use of a few basic features of inky, and be expanded upon in subsequent chapters. Before jumping into this tutorial, you should be familiar with [The Basics](http://code.google.com/p/inky/wiki/Basics).  It is also recommended that you download [the code for this application](http://inky.googlecode.com/svn/trunk/examples/petsitters-1/) and follow along.

# Setup #

To start your inky project, create a new FLA and save it as "PetsittersApplication.fla". Make sure that the inky classes are located in the FLA's classpath. (For more information on classpaths, [see the Flash documentation](http://livedocs.adobe.com/flash/9.0/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000775.html).)  In the same directory as your FLA, create an ActionScript file named "PetsittersApplication.as" with the following code:

```
package
{
	import flash.display.*;
	import flash.text.TextField;
	import inky.framework.core.Application;
	public class PetsittersApplication extends Application
	{
	}
}
```

This is our main application class, and we'll be coming back to it shortly.

Set the Document Class of your FLA to "PetsittersApplication" and click the pencil next to the Document Class field to make sure that Flash can find our application class. (If you get a message saying that the definition could not be found, you've probably spelled something wrong.)

Next, create a new XML file in your publish directory (the directory that the SWF will be created in) and name it "PetsittersApplication.inky.xml". Paste the following into your XML file:

```
<?xml version="1.0" encoding="utf-8" ?>
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky">
</inky:Application>
```

Just like a typical website is comprised of pages, inky applications are made up of "Sections." Sylvio wants the application to have three sections -- an "about" section, a "pricing" section, and a "hours" section -- so our application will need a way to navigate between them. Add three buttons to the stage and give them instance names "aboutButton", "pricingButton", and "hoursButton".

# Your First Section #

In order to add a section to your application, you must do three things: 1) create a class that handles the functionality of your section, 2) create a symbol in the library that represents your section, and 3) add a "Section" node to your inky XML. The first section we create will be the about section, so save the following as "AboutSection.as".

```
package
{
	import flash.display.*;
	import flash.text.TextField;
	import inky.framework.core.Section;
	public class AboutSection extends Section
	{
	}
}
```

Next, create a MovieClip in your library named "AboutSection". In the symbol's properties panel, check off "Export for ActionScript" and set the class to "AboutSection".  (Click the checkbox next to the class field to make sure that the FLA can find your AboutSection class.) Once you've created your symbol, make it look like an about section: put some text in there, draw some shapes.. whatever.  But DO NOT put the section on the stage; inky will automatically add it to the stage when the user navigates to it.

Finally, we need to add a Section node to our inky XML. Like the "Application" node, Section nodes must be in the inky namespace (you need to type "

&lt;inky:Section&gt;

" instead of "

&lt;Section&gt;

"). In addition, you must specify which class to use (with the inky:class attribute) and a name for the section.

```
<?xml version="1.0" encoding="utf-8" ?>
<inky:Application xmlns:inky="http://inkyframework.com/2008/inky">
	<inky:Section inky:class="AboutSection" name="about" y="25" />
</inky:Application>
```

Note that I've also given the section a `y` value so that it doesn't cover the application's navigation when it's added to the stage.

Our about section is now ready, however, the user has no way of navigating to it! To remedy this, we need to edit our PetsittersApplication class to add functionality to the aboutButton clip that we created earlier.

```
package
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import inky.framework.core.Application;
	public class PetsittersApplication extends Application
	{
		public function PetsittersApplication()
		{
			this.aboutButton.addEventListener(MouseEvent.CLICK, this._aboutButtonClickHandler);
		}
		
		private function _aboutButtonClickHandler(e:MouseEvent):void
		{
			this.gotoSection('about');
		}
	}
}
```

Now, when the user clicks on the about button, the application's [gotoSection](http://docs.inkyframework.com/as3/inky/framework/core/Application.html#gotoSection()) method will be called. ([gotoSection](http://docs.inkyframework.com/as3/inky/framework/core/Application.html#gotoSection()) accepts [SPaths](http://docs.inkyframework.com/as3/inky/framework/utils/SPath.html), which are URL-like identifiers composed of section names.) As as a result, the AboutSection MovieClip will be added to the stage.

# Twice More! #

Add the remaining sections -- "hours" and "pricing" -- using the exact same process. Don't forget to add the button click handlers!