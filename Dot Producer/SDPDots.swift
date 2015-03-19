//
//  SDPDots.swift
//  Dot Producer
//
//  Created by Pablo Prietz on 27.02.15.
//  Copyright (c) 2015 Pablo Prietz. All rights reserved.
//

import Cocoa

let SDPDotsChangedNotification = "SDPDotsChangedNotification"

class SDPDots: NSObject {

	var NoD: Int = 6 {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(SDPDotsChangedNotification, object: self)
		}
	}
	var circleRadius: Double = 0.25 // relative value to min(height,width) of view
	{
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(SDPDotsChangedNotification, object: self)
		}
	}
	var dotRadius: Double = 0.05 // relative value to min(height,width) of view
	{
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(SDPDotsChangedNotification, object: self)
		}
	}

	var fileDescription: String {
		get {
			return "sdp_NoD-\(self.NoD)_CR-\(self.circleRadius)_DR-\(self.dotRadius)"
		}
	}
}
