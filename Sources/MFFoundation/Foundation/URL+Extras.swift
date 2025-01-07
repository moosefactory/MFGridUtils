/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
// URL+Extras
//  Created by Tristan Leblanc on 12/01/2021.

import Foundation

public extension URL {
    var ns: NSURL {
        return NSURL(fileURLWithPath: self.path)
    }
}

public extension NSURL {
    var url: URL? {
        guard let string = self.absoluteString else { return nil }
        return URL(string: string)
    }
}
