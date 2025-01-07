/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
//  Random.swift
//  Created by Tristan Leblanc on 19/11/2020.

import Foundation

public extension Double {
    
    /// Returns a  random value between 0 and 1
    static func random() -> Double {
        return Double(Double(arc4random()) / Double(UInt32.max))
    }
    
    /// Returns a  random value between 0 and 1
    static func random(_ max: Double) -> Double {
        return max * Double(Double(arc4random()) / Double(UInt32.max))
    }
    
    /// Returns a  random value between 0 and 2π
    static func randomAngle() -> Double {
        return Double.pi * 2 * (Double(Double(arc4random()) / Double(UInt32.max)))
    }
    
    /// Returns a random value between -1 and 1
    static func signedRandom() -> Double {
        return Double( ((Double(arc4random()) / Double(UInt32.max)) - 0.5) * 2 )
    }
    
    /// Returns a random number between min and max
    static func random(min: Double = 0, max: Double = 1) -> Double {
        let r = Double(arc4random()) / Double(UInt32.max)
        return min + Double(r) * (max - min)
    }
    
    /// Returns a random number given a possible variation centered on median value
    static func random(median: Double, variation: Double) -> Double {
        let r = Double(arc4random()) / Double(UInt32.max)
        return median + Double(r) - variation / 2
    }
    

    /// Returns a random number given a possible variation centered on median value
    static func gaussion(median: Double, variation: Double) -> Double {
        let r = Double(arc4random()) / Double(UInt32.max)
        return median + Double(r) - variation / 2
    }
    
    func randomNormalValue(average: Double, standardDeviation: Double) -> Double {
        let x1 = Double.random()
        let x2 = Double.random()
        let z1 = sqrt(-2 * log(x1)) * cos(2 * .pi * x2)

        return z1 * standardDeviation + average
    }
}

public extension Int {
    
    /// Returns a random Int number
    static func random(min: Int = 0, max: Int = Int.max) -> Int {
        let r = Double(arc4random()) / Double(UInt32.max)
        return min + Int(r * Double(max - min))
    }
}

public extension UInt8 {
    
    /// Returns a random UInt8 number
    static func random(min: UInt8 = 0, max: UInt8 = UInt8.max) -> UInt8 {
        let r = Double(arc4random()) / Double(UInt32.max)
        return min + UInt8(r * Double(max - min))
    }
}

public extension UInt16 {
    
    /// Returns a random UInt8 number
    static func random(min: UInt16 = 0, max: UInt16 = UInt16.max) -> UInt16 {
        let r = Double(arc4random()) / Double(UInt32.max)
        return min + UInt16(r * Double(max - min))
    }
}

public extension Float {
    
    /// Returns a random float number
    static func random(min: Float = 0, max: Float = 1) -> Float {
        let x = Float(arc4random()) / Float(UInt32.max)
        return min + Float(x) * (max - min)
    }
}
