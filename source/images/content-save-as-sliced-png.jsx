app.preferences.rulerUnits = Units.PIXELS;

var sourceDocument = app.activeDocument;
var headerBounds = new Array(6, 0, 943, 140);
var logoBounds = new Array(6, 6, 506, 140);
var contentBounds = new Array(0, 143, 949, 144);
var footerBounds = new Array(6, 144, 943, 150);

cropAndSave(sourceDocument, headerBounds, "..\\app\\NOS.Wiki\\Themes\\NOS\\images\\layout\\header-background.png", function(doc) {
	doc.layerSets["Logo"].visible = false;
});

cropAndSave(sourceDocument, logoBounds, "..\\app\\NOS.Wiki\\Themes\\NOS\\images\\layout\\header-logo.png");
cropAndSave(sourceDocument, contentBounds, "..\\app\\NOS.Wiki\\Themes\\NOS\\images\\layout\\content-border.png");
cropAndSave(sourceDocument, footerBounds, "..\\app\\NOS.Wiki\\Themes\\NOS\\images\\layout\\footer-background.png");

function cropAndSave(sourceDocument, bounds, filename, processClone)
{
	doc = sourceDocument.duplicate("current");

	if (typeof(processClone) !== "undefined")
	{
		processClone(doc);
	}

	doc.crop(bounds);
	saveAsPng(sourceDocument, doc, filename);
	doc.close(SaveOptions.DONOTSAVECHANGES);
}

function saveAsPng(sourceDocument, document, filename)
{
	// File name: "[PSD File Folder]\[filename]".
	var file = new File(sourceDocument.fullName.parent.fsName + '\\' +
						filename);

	png = new PNGSaveOptions();
	png.interlaced = false;

	document.saveAs(file, png, true, Extension.LOWERCASE);
}