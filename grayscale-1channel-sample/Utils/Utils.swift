//
//  Utils.swift
//  grayscale-1channel-sample
//
//  Created by What on 2018/12/21.
//  Copyright © 2018 dumbass. All rights reserved.
//

import Foundation.NSDate

extension Sequence where Element: FixedWidthInteger {
    
    /// Calculate the avarage of the sum of all elements in sequence which is limited sequence
    ///
    /// - Returns: the avarage
    /// - Warning: Overflow is not handler
    ///
    ///    let arr: [UInt8] = [255, 1, 0]
    ///    arr.average() // 256 is greatter than UInt8.max
    func average() -> Element {
        return reduce(0, +)
    }
}

extension UInt16 {
    var uint8: UInt8 {
        return UInt8(self)
    }
}

extension UInt8 {
    var uint16: UInt16 {
        return UInt16(self)
    }
}

extension Date {
    static var now: TimeInterval {
        return Date().timeIntervalSince1970
    }
}
