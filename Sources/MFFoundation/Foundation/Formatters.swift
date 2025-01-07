/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
//  Formatters.swift
//  Created by Tristan Leblanc on 09/10/2020.

#if !os(watchOS)

import Foundation
import QuartzCore



public extension CGPoint {
    
    /// Returns commma separated point coordinates with 3 decimals precision
    
    var dec3: String {
        return "\(x.dec3),\(y.dec3)"
    }
}

public extension CGSize {
    
    /// Returns commma separated point coordinates with 3 decimals precision

    var dec3: String {
        return "\(width.dec3),\(height.dec3)"
    }
}

//MARK: - 3 Decimals formatter - Usefull for debug logging

public extension CGFloat {

    /// Returns commma separated point coordinates with 3 decimals precision

    var dec3: String {
        Double(self).dec3
    }
}

public extension Double {
    
    static let formatter3Dec: NumberFormatter = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 3
        return f
    }()
    
    /// Returns value formatted 3 decimals precision

    var dec3: String {
        let n = NSNumber(value: Double(self))
        return Double.formatter3Dec.string(from: n) ?? "\(self)"
    }
}


#endif


