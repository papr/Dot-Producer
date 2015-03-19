//
//  SDPDotView.swift
//  Dot Producer
//
//  Created by Pablo Prietz on 27.02.15.
//  Copyright (c) 2015 Pablo Prietz. All rights reserved.
//

import Cocoa

class SDPDotView: NSView {

	override var opaque: Bool {
		get { return true; }
	}

	@IBOutlet var source: Document?
	var turned: Bool = false
	var turnTimer: NSTimer = NSTimer()

	var data: SDPDots? {
		didSet {
			NSNotificationCenter.defaultCenter().removeObserver(self, name: SDPDotsChangedNotification, object: oldValue)
			NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("dataChanged:"), name: SDPDotsChangedNotification, object: data)
		}
	}

	convenience init(frame frameRect: NSRect, dots dotsource: Document, state turnState: Bool) {
		self.init(frame: frameRect)
		self.source = dotsource
		self.turned = turnState
		self.data = source!.dots
	}

	override func awakeFromNib() {
		self.data = source!.dots
		resetTimer(NSNotification(name: "", object: nil))
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("resetTimer:"), name: SDPTurnFreqChangedNotification, object: source!)
	}

	func dataChanged(note: NSNotification) {
		display()
	}
	func resetTimer(note: NSNotification) {
		turnTimer.invalidate()
		turnTimer = NSTimer.scheduledTimerWithTimeInterval(source!.turnFreq, target: self, selector: "turning:", userInfo: nil, repeats: true)
	}

	func turning(timer: NSTimer) {
		turned = !turned
		display()
	}

	override func drawRect(dirtyRect: NSRect) {
		super.drawRect(dirtyRect)

		var bounds = self.bounds
		let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
		let minEdgeLength = min(bounds.width, bounds.height)
		let absDotRadius = CGFloat(data!.dotRadius) * minEdgeLength

		NSColor.whiteColor().setFill()
		NSBezierPath(rect: bounds).fill()

		var angleDeg: CGFloat = 360.0 / CGFloat(data!.NoD)
		var turnAngleDeg = turned ? angleDeg/2 : 0
		for dotno in 0...data!.NoD {
			var currentAngleDeg = CGFloat(dotno) * angleDeg + turnAngleDeg
			var currentAngleRad = WVDegRad(currentAngleDeg)

			var dp = CGPoint()
			dp.x = center.x + cos(currentAngleRad) * minEdgeLength * CGFloat(data!.circleRadius)
			dp.y = center.y + sin(currentAngleRad) * minEdgeLength * CGFloat(data!.circleRadius)

			let dotRect = NSRect(
				x: dp.x - absDotRadius ,
				y: dp.y - absDotRadius,
				width: 2.0 * absDotRadius,
				height: 2.0 * absDotRadius )
			var dot = NSBezierPath(ovalInRect: dotRect)
			NSColor.blackColor().setFill()
			dot.fill()

			/*
			if dotno == data!.NoD {
				var reddot = NSBezierPath(ovalInRect: NSRect(origin: dp, size: CGSize(width: 5.0,height: 5.0)))
				NSColor.redColor().setFill()
				reddot.fill()
			} */

		}
	}

	func viewData() -> NSData? {
		let bounds = self.bounds
		let bitrep = self.bitmapImageRepForCachingDisplayInRect(bounds)
		bitrep?.size = bounds.size
		self.cacheDisplayInRect(bounds, toBitmapImageRep: bitrep!)
		let data = bitrep?.representationUsingType(
			NSBitmapImageFileType.NSPNGFileType,
			properties: NSDictionary())
		return data
	}

	func WVDegRad(degree: CGFloat) -> CGFloat
	{
		return degree / 180.0 * CGFloat(M_PI);
	}

	func WVRadDeg(radian: CGFloat) -> CGFloat
	{
		return radian / CGFloat(M_PI) * 180.0;
	}
	func WVNormalizedRadian(rad: CGFloat) -> CGFloat
	{
		var  radian = rad
		let one_pi:CGFloat = CGFloat(M_PI)
		while (radian < 0)
		{
			radian += 2.0*one_pi;
		}
		while (radian >= 2.0*one_pi)
		{
			radian -= 2.0*one_pi;
		}
		return radian;
	}
	
}
