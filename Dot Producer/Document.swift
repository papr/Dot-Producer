//
//  Document.swift
//  Dot Producer
//
//  Created by Pablo Prietz on 27.02.15.
//  Copyright (c) 2015 Pablo Prietz. All rights reserved.
//

import Cocoa

let SDPTurnFreqChangedNotification = "SDPTurnFreqChangedNotification"

class Document: NSDocument {

	var dots: SDPDots = SDPDots()
	var turnFreq: NSTimeInterval = 0.25 {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(SDPTurnFreqChangedNotification, object: self)
		}
	}
	
	@IBOutlet var view: SDPDotView!

	override init() {
	    super.init()
		// Add your subclass-specific initialization here.
	}

	override func windowControllerDidLoadNib(aController: NSWindowController) {
		super.windowControllerDidLoadNib(aController)
	}

	override class func autosavesInPlace() -> Bool {
		return true
	}

	override var windowNibName: String? {
		// Returns the nib file name of the document
		// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
		return "Document"
	}

	override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
		// Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
		// You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
		outError.memory = NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		return nil
	}

	override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		// Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
		// You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
		// If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
		outError.memory = NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		return false
	}


	@IBAction func export(sender: NSMenuItem) {
		let op = NSOpenPanel()
		op.title = "Dot Image Export Folder"
		op.canChooseDirectories = true
		op.canChooseFiles = false
		op.canCreateDirectories = true

		op.beginWithCompletionHandler { (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton {
				let exportedFileURL = op.URL!

				let imageRect: NSRect = NSRect(
					x: 0, y: 0,
					width: 500, height: 500)
				let viewOff = SDPDotView(
					frame: imageRect,
					dots: self,
					state: false)
				let viewOn  = SDPDotView(
					frame: imageRect,
					dots: self,
					state: true)

				let imgOff: NSData = viewOff.viewData()!
				let imgOn : NSData = viewOn.viewData()!

				self.drawImagesToFiles([imgOff, imgOn], toFolder: exportedFileURL)
			}
		}
	}

	func drawImagesToFiles(images: [NSData], toFolder folder: NSURL) -> Bool {
		var success = true
		for turned in [false, true]
		{

			var filename = dots.fileDescription + (turned ? "_on" : "_off") + ".jpg"
			var loc = folder.URLByAppendingPathComponent(filename, isDirectory: false)

			var img = images[turned ? 1 : 0]

			let writesuc = img.writeToURL(loc, atomically: true)
			if !writesuc { success = false }
		}
		return success
	}

	func ShouldSerializeView() -> Bool {
		return false;
	}
}

