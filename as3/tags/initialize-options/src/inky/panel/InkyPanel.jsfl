var dom = fl.getDocumentDOM();
var docName = dom.name.substr(-4).toLowerCase() == '.fla' ? dom.name.substr(0, dom.name.length - 4) : dom.name;

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




function cleanup()
{
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
    	cleanup();
    	throw new Error('The publish profile could not be saved');
    }

    // Import the publish profile.
    dom.importPublishProfile(tmpPublishProfileSource);
    
    // Publish the fla to produce the swc file.
	dom.publish();
	
	// Reset the publish profile.
	if (!FLfile.write(tmpPublishProfileSource, publishProfile))
    {
    	cleanup();
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
