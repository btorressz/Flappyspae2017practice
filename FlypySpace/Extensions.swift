//
//  Extensions.swift
//  FlypySpace
//
//  Created by Brandon Torres on 4/3/17.
//  Copyright © 2017 Brandon Torres. All rights reserved.
//

import Foundation
import CoreGraphics


public extension CGFloat {
    
    // anything we type here will be available in cgfloat
    
    public static func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        
        // gives the random number
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * Swift.abs(firstNum - secondNum) + firstNum
        
    }
    
}

