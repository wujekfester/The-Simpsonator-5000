//
//  CustomNSLevelIndicator.swift
//  The Sims
//
//  Created by Aleksander Bernat on 08/06/2019.
//  Copyright © 2019 Aleksander Bernat. All rights reserved.
//

import Cocoa

class CustomNSLevelIndicator: NSLevelIndicator {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        fillColor = .green
        warningFillColor = .yellow
        criticalFillColor = .red
        maxValue = 100
        minValue = 0
        warningValue = 50
        criticalValue = 25
        levelIndicatorStyle = .continuousCapacity
        isEditable = false
        doubleValue = 60.0
        
    }
    
}
