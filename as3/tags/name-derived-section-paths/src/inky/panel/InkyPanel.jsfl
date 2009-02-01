var dom = fl.getDocumentDOM();
var docName = dom.name.substr(-4).toLowerCase() == '.fla' ? dom.name.substr(0, dom.name.length - 4) : dom.name;
var as3PackagePaths,publishProfileSource,libPublishProfileSource;
var defaultProfile = getPublishProfile();
var renamedClasses = [];
var modifiedLibraryItems = [];

function throwError(msg)
{
	throw new Error(msg);
}





//
//
// Handle documentChanged status
//
//

var documentChanged = false;
function documentChangedHandler()
{
	documentChanged = true;
}
fl.addEventListener('documentChanged', documentChangedHandler);
function checkDocumentChanged()
{
	return documentChanged && !(documentChanged = false);
}


/**
 *
 * Utility function used to convert a path to a uri.
 *
 */  
function path2uri(path)
{
	path = path.replace(/\\/g, '/');
	if ((path.indexOf(':/') != -1) || (path.charAt(0) == '/'))
	{
		while (path.charAt(0) == '/') path = path.substr(1);
		if (path.indexOf('file:///') != 0) path = 'file:///' + path;
	}
	return path;
}




/**
 *
 * Utility function for getting the fla's path. (Because even if
 * dom.path is defined, it doesn't mean getPath will work) 
 *
 */   
function getDocumentURI()
{
	var path = getDocumentPath();
	return path ? path2uri(path) : null;
}


function getDocumentPath()
{
	return dom.path ? dom.path.replace(/\\/g, '/').split('/').slice(0, -1).join('/') + '/' : null;
}

function getPublishProfile()
{
	var publishProfileSource = getDocumentURI() + docName + '_publishProfile.tmp';
	dom.exportPublishProfile(publishProfileSource);
	var publishProfile = FLfile.read(publishProfileSource);
	FLfile.remove(publishProfileSource);
	return publishProfile;
}



function publishSWC(filename)
{
	if (!/\.swc$/.test(filename.toLowerCase()))
	{
		throw new Error('The SWC filename must end in .swc');
	}

	// Change the filename to a .swf extension cuz that's what the publish profile needs.
	var swfFilename = filename.substring(0, filename.length - 1) + 'f';

	// Create a new publish profile for creating the library swc.
	var publishProfile = getPublishProfile();
	var libPublishFormatProperties = '<PublishFormatProperties enabled="true">\n    <defaultNames>0</defaultNames>\n    <flash>1</flash>\n    <generator>0</generator>\n    <projectorWin>0</projectorWin>\n    <projectorMac>0</projectorMac>\n    <html>0</html>\n    <gif>0</gif>\n    <jpeg>0</jpeg>\n    <png>0</png>\n    <qt>0</qt>\n    <rnwk>0</rnwk>\n    <flashDefaultName>0</flashDefaultName>\n    <generatorDefaultName>0</generatorDefaultName>\n    <projectorWinDefaultName>0</projectorWinDefaultName>\n    <projectorMacDefaultName>0</projectorMacDefaultName>\n    <htmlDefaultName>0</htmlDefaultName>\n    <gifDefaultName>0</gifDefaultName>\n    <jpegDefaultName>0</jpegDefaultName>\n    <pngDefaultName>0</pngDefaultName>\n    <qtDefaultName>0</qtDefaultName>\n    <rnwkDefaultName>0</rnwkDefaultName>\n    <flashFileName>%FILE_NAME%</flashFileName>\n    <generatorFileName>no.swt</generatorFileName>\n    <projectorWinFileName>no.exe</projectorWinFileName>\n    <projectorMacFileName>no.app</projectorMacFileName>\n    <htmlFileName>no.html</htmlFileName>\n    <gifFileName>no.gif</gifFileName>\n    <jpegFileName>no.jpg</jpegFileName>\n    <pngFileName>no.png</pngFileName>\n    <qtFileName>no.mov</qtFileName>\n    <rnwkFileName>no.smil</rnwkFileName>\n    </PublishFormatProperties>';
	libPublishFormatProperties = libPublishFormatProperties.replace(/%FILE_NAME%/g, swfFilename);
	var libPublishProfile = publishProfile.replace(/\n/g, '%NEWLINE%').replace(/<PublishFormatProperties.*?\/PublishFormatProperties>/, libPublishFormatProperties).replace(/%NEWLINE%/g, '\n').replace(/<ExportSwc.*?\/ExportSwc>/, '<ExportSwc>1</ExportSwc>');
	tmpPublishProfileSource = getDocumentURI() + docName + '_lib____' + '_publishProfile.tmp.xml';
    if (!FLfile.write(tmpPublishProfileSource, libPublishProfile))
    {
    	cleanupFLA();
    	throw new Error('The publish profile could not be saved');
    }

    // Import the publish profile.
    dom.importPublishProfile(tmpPublishProfileSource);
    
    // Publish the fla to produce the swc file.
	dom.publish();
	
	// Reset the publish profile.
	if (!FLfile.write(tmpPublishProfileSource, publishProfile))
    {
    	cleanupFLA();
    	throw new Error('The publish profile could not be saved');
    }
    dom.importPublishProfile(tmpPublishProfileSource);
    
    // Delete the temp publish profile file.
    FLfile.remove(tmpPublishProfileSource);
    
    // Remove the swf.
    FLfile.remove(path2uri(swfFilename));
}

function getApplicationClass()
{
	return dom.docClass;
}










//======================================================

	
function cleanupFLA()
{
	fl.trace('cleanup: ' + publishProfileSource)
	if(publishProfileSource) dom.importPublishProfile(publishProfileSource);
	FLfile.remove(libPublishProfileSource);
	FLfile.remove(publishProfileSource);
	FLfile.remove(docPath + docName + '_lib____.swf');
	FLfile.remove(docPath + docName + '_lib____.swc');

/*	for(i=0;i<renamedClasses.length;i++) //un-rename renamed classes.
	{				
		if(FLfile.copy(renamedClasses[i] + '.bkup', renamedClasses[i]))
		{
			if(!FLfile.remove(renamedClasses[i]+'.bkup')) fl.trace('Warning: unable to delete temporary file ' + renamedClasses[i] + '.bkup');
		}
		else fl.trace('Warning: unable to restore file ' + renamedClasses[i]);
	}
*/	for(i=0;i<modifiedLibraryItems.length;i++) modifiedLibraryItems[i].linkageExportInFirstFrame=true; //un-modify modified library items.
}

function publishWithExcludes(excludedClasses)
{		
		publish = true;	//publish flag,set to false to debug (runs the script without any publishing).
		throwOnError = true;

		var cu = unescape(fl.configURI).toLowerCase();
		items = dom.library.items;

		if (cu.indexOf("macintosh hd") > -1) os = "mac";
		else if (cu.indexOf("c|") > -1) os = "win";

		for (var prop in excludedClasses)
		{
			var section = excludedClasses[prop];
			if (section && section.length)
			{
			//	var sectionName = prop.slice(0, prop.indexOf('.'));
				
				publishProfileSource = getDocumentPath() + docName + '_publishProfile.xml'; //the file name to write the current publish profile to.
				dom.exportPublishProfile(publishProfileSource);
				
				var publishProfile = FLfile.read(publishProfileSource);
				fl.trace('publish profile source: ' + publishProfileSource)
				fl.trace('publish profile: ' + publishProfile)
				
				as3PackagePaths = (/<AS3PackagePaths>(.*?)<\/AS3PackagePaths>/.exec(publishProfile)[1] + ';' + fl.as3PackagePaths).replace(/\$\(AppConfig\)/g, fl.configURI).split(';');
				
				//create a new publish profile for creating the library swc.
				var libPublishFormatProperties='<PublishFormatProperties enabled="true">\n<defaultNames>0</defaultNames>\n<flash>1</flash>\n<generator>0</generator>\n<projectorWin>0</projectorWin>\n<projectorMac>0</projectorMac>\n<html>0</html>\n<gif>0</gif>\n<jpeg>0</jpeg>\n<png>0</png>\n<qt>0</qt>\n<rnwk>0</rnwk>\n<flashDefaultName>0</flashDefaultName>\n<generatorDefaultName>0</generatorDefaultName>\n<projectorWinDefaultName>0</projectorWinDefaultName>\n<projectorMacDefaultName>0</projectorMacDefaultName>\n<htmlDefaultName>0</htmlDefaultName>\n<gifDefaultName>0</gifDefaultName>\n<jpegDefaultName>0</jpegDefaultName>\n<pngDefaultName>0</pngDefaultName>\n<qtDefaultName>0</qtDefaultName>\n<rnwkDefaultName>0</rnwkDefaultName>\n<flashFileName>%FILE_NAME%.swf</flashFileName>\n<generatorFileName>%FILE_NAME%.swt</generatorFileName>\n<projectorWinFileName>%FILE_NAME%.exe</projectorWinFileName>\n<projectorMacFileName>%FILE_NAME%.app</projectorMacFileName>\n<htmlFileName>%FILE_NAME%.html</htmlFileName>\n<gifFileName>%FILE_NAME%.gif</gifFileName>\n<jpegFileName>%FILE_NAME%.jpg</jpegFileName>\n <pngFileName>%FILE_NAME%.png</pngFileName>\n<qtFileName>%FILE_NAME%.mov</qtFileName>\n<rnwkFileName>%FILE_NAME%.smil</rnwkFileName>\n</PublishFormatProperties>';
				libPublishFormatProperties = libPublishFormatProperties.replace(/%FILE_NAME%/g, docName);
				
				var libPublishProfile = publishProfile.replace(/\n/g, '%NEWLINE%').replace(/<PublishFormatProperties.*?\/PublishFormatProperties>/, libPublishFormatProperties).replace(/%NEWLINE%/g, '\n').replace(/<ExportSwc.*?\/ExportSwc>/, '<ExportSwc>1</ExportSwc>');
				libPublishProfileSource = getDocumentPath() + docName + '_lib____' + '_publishProfile.xml';

				if (!FLfile.write(libPublishProfileSource, libPublishProfile))
				{
					cleanupFLA();
					failErrorMessage = "The library publish profile could not be saved";
					if (throwOnError) throw failErrorMessage;
					res = false;
				}

				for (i = section.length - 1; i > 0; i--) if (section.indexOf(section[i])!=i) section.splice(i,1);	 //eliminate redundancies in excludes.
			 	dom.importPublishProfile(libPublishProfileSource); 	//set the new library publish profile

				//publish the library fla to produce the swc file						
				if (publish) dom.publish(); 	

				//rename/move excluded classes so that they aren't compiled into the swf
				for (i=0;i<section.length;i++) 
				{
					var classSource;
					var searchDir;
					var className = section[i].replace(/\./g,"/") + ".as";

					for (var j=0; j < as3PackagePaths.length; j++) //find the location(s) of the class.
					{
						if (!as3PackagePaths[j]) continue;
						
						searchDir = as3PackagePaths[j];
						searchDir = unescape(searchDir.replace(/file\:\/\/\//,""));
						searchDir = searchDir.replace(/c|/i,"");
						searchDir = searchDir.replace(/\/\|\//,"/");
						searchDir = searchDir.replace(/\\/g, '/');
						searchDir = searchDir.replace(/\:/g,"/");
						searchDir = searchDir.replace(/\/{2,}/g,"/");
						
						if (searchDir.substr(0,1)==".") searchDir = getDocumentPath()+searchDir;
						searchDir = searchDir.replace(/file\:\/\/\//,"");

						if (os == "mac")
						{
						//	if (!publish) fl.trace("IN MAC");
							if (searchDir.toLowerCase().indexOf("macintosh hd")<0)searchDir="Macintosh HD/"+searchDir;
						}
						else if (os == "win")
						{
						//	if (!publish) fl.trace("IN WIN");
							if (searchDir.toLowerCase().indexOf("c:")<0)searchDir="C:/"+searchDir;
						}

						if (searchDir.lastIndexOf("/")<searchDir.length-1) searchDir += "/";

						searchDir = searchDir.replace(/\/{2,}/g,"/");
						classSource = "file:///" + searchDir + className;

					//	if (!publish) fl.trace("CLASS SOURCE: " + classSource);
						if (FLfile.exists(classSource))
						{
						//	if (!publish) fl.trace("FOUND FILE " + classSource);
							renamedClasses.push(classSource);
/*							if (!FLfile.copy(classSource, classSource + '.bkup') || !FLfile.remove(classSource)) //tmp rename class
							{
								cleanupFLA();
								res = false;
								
								failErrorMessage = "Unable to rename file " + classSource;
								if (throwOnError) throw failErrorMessage;
							}
*/
							break;
						}
					}
				}

				for (i=0;i<items.length;i++) 	//alter library items that have exclude classes in first frame
				{
					item = items[i];
					if ((section.indexOf(item.linkageClassName) != -1) || (section.indexOf(item.linkageBaseClass)!=-1))
					{
						if (item.linkageExportInFirstFrame)
						{
							modifiedLibraryItems.push(item);
							item.linkageExportInFirstFrame = false;
						}
					}
				}

				res = true;
				dom.importPublishProfile(publishProfileSource);

				if (publish) dom.testMovie();
   				cleanupFLA();
			}
			else
			{
				res = true;
				if (publish) dom.testMovie(); 	//no excludes
			}
		}
}



