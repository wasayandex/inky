/**
 *
 * Resolves a URI to the provided base URI
 *
 */
function resolveURI(uri, base)
{
	if (uri.indexOf("/") == 0)
	{
		return uri;
	}
	else if (uri.indexOf("file:///") == 0)
	{
		return uri;
	}
	else
	{
		return base.lastIndexOf("/") == base.length - 1 ? base + uri : base + "/" + uri;
	}
}


/**
 *
 * Finds a file in a given directory.
 *
 * @return
 *     the uri of the file, or null if not found
 *
 */
function findFile(name, folderURI, recursive)
{
// FIXME: prevent multiple recursion (caused by aliases?)
	var fileURI = null;
	recursive = arguments.length < 3 ? true : recursive;
	
	var tmp = resolveURI(name, folderURI);
	if (FLfile.exists(tmp))
	{
		fileURI = tmp;
	}
	else if (recursive)
	{
		var subdirectories = FLfile.listFolder(folderURI, "directories");
		for (var i = 0; i < subdirectories.length; i++)
		{
			var subdirectory = subdirectories[i];
			if (subdirectory.charAt(0) != ".") // eclude hidden directories
			{
				if ((fileURI = findFile(name, resolveURI(subdirectory, folderURI))))
					break;
			}
		}
	}

	return fileURI;
}


/**
 *
 * Gets the directory of a file, given the file uri.
 *
 * @param fileURI
 *     the uri of the file
 * @return
 *     the directory of the file
 *
 */
function getFileDirectory(fileURI)
{
	return fileURI.replace(/\/[^\/]+$/, "");
}


/**
 *
 * Creates the symbol
 *
 * @param fileURI
 *     the uri of the file
 * @return
 *     the directory of the file
 *
 */
function createSymbol(className)
{
	var dom = fl.getDocumentDOM();

	if (!dom.pathURI)
	{
		alert("You must save your FLA before running this script");
		return;
	}
	
	if (!className)
		className = prompt("Enter class name");

	if (!className)
		return;

	var pathSeparator = "/";
	var currentDir = getFileDirectory(dom.pathURI);
	var classPaths = dom.sourcePath.split(";").concat(fl.sourcePath.split(";")).filter(function(el){return !!el.replace(/^\s+$/, "");});
	var tmp;
	var classFile = null;
	var i;
	var path;
	var qualifiedClassName;

	// Look for the class in the class path.
	for (i = 0; i < classPaths.length; i++)
	{
		path = classPaths[i];
		if (path)
		{
			var fileName = className.replace(/\./g, "/") + ".as";
			path = resolveURI(path, currentDir);
			if ((tmp = findFile(fileName, path)))
			{
				// The class file was found!
				classFile = tmp;
				qualifiedClassName = classFile.replace(path, "").replace(/\.as$/, "").replace(/\//g, ".");
				break;
			}
		}
	}

	if (!classFile)
	{
// TODO: display a different dialog if only one classpath?
		// Create xmlui panel.
		var xml = '<dialog title="Class not found. Wanna create it?" buttons="accept,cancel"><label value="Chose a class path:" /><radiogroup id="path">';
		for (i = 0; i < classPaths.length; i++)
		{
			path = classPaths[i];
			xml += '<radio label="' + path + '" value="' + path +'" />';
		}
		xml += '</radiogroup></dialog>';

		// Determine where the user wants to save the class.
		var xmlURI = resolveURI("createSymbol.tmp.xml", getFileDirectory(fl.scriptURI));
		FLfile.write(xmlURI, xml);
		var result = dom.xmlPanel(xmlURI);
		FLfile.remove(xmlURI);
		
		if (result.dismiss == "accept")
		{
			// Create the class.
			classFile = resolveURI(className.replace(/\./g, "/") + ".as", resolveURI(result.path, currentDir));
			var classDir = getFileDirectory(classFile);
			if (!FLfile.createFolder(classDir))
				alert("Could not create class");
			else if (!FLfile.write(classFile, ""))
				alert("Could not create class");
			else
				qualifiedClassName = className;
		}
	}

	if (qualifiedClassName)
	{
		var library = dom.library;
		
		// Get the folder of the selected library item so we can put the new item in the same place.
		var selection = library.getSelectedItems();
		selection = selection && selection.length ? selection[0] : null;
		var folder = "";
		if (selection)
		{
			if (selection.itemType == "folder")
				folder = selection.name;
			else
				folder = selection.name.match(/(.*)\/[^\/]+$|/)[1];
		}
		
		// Create a symbol and set the linkage.
		var itemName = (folder ? folder + "/" : "") + qualifiedClassName.split(".").pop();
		library.addNewItem("movie clip", itemName);
		library.selectItem(itemName);
		library.setItemProperty("linkageExportForAS", true);
		library.setItemProperty("linkageExportInFirstFrame", true);
		library.setItemProperty("linkageClassName", qualifiedClassName);
		library.editItem();
	}
}

createSymbol();