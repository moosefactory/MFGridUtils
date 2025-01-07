/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
//  String+Extras.swift
//  Created by Tristan Leblanc on 20/11/2020.

import Foundation

// MARK: - Variables matching

public extension String {

    /// Replaces variables in a string
    ///
    /// - parameters variablesDictionary
    /// A dictionary of variable/value pairs. Values are strings, it's up to the caller to format any other type
    /// to string before calling this function
    ///
    /// - returns the new string, with replaced {$}
    ///
    /// Variables placeholders are defined in the string using {$variable} syntax.
    ///
    /// ```
    /// let dict = ["name": "Doe", "forename": "John"]
    /// let greetings = "Hello {$forename} {$name}!"
    /// print(greetings.byReplacingVariables(with dict)
    ///
    /// Output:
    /// Hello John Doe!
    /// ```
    
    func byReplacingVariables(with variablesDictionary: [String: String]) -> String {
        var out = self
        variablesDictionary.forEach { key, value in
            out = out.replacingOccurrences(of: "{$\(key)}", with: value)
        }
        return out
    }

    /// Returns string with first character trimmed
    var byRemovingFirstCharacter: String {
        guard count > 1 else { return "" }
        return String(suffix(count-1))
    }
}

public extension Data {
    
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

public extension UUID {

    /// Returns the four first characters of the UUID.
    /// Nice to display or log UUIDs, but don't use it for identification.
    var short: String { String(uuidString.prefix(4)) }
}

//MARK: - String

public extension String {
    
    var ns: NSString {
        return NSString(string: self)
    }
    
    var utf8: Data {
        self.data(using: .utf8) ?? Data()
    }
    
    var byRemovingSpaces: String {
        replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\t", with: "")
    }
    
    var asRawDecimalNumberString: String {
        return filteringCharacters(in: CharacterSet(charactersIn: "0123456789.,")).replacingOccurrences(of: ",", with: ".")
    }

    var asRawIntegerNumberString: String {
        return filteringCharacters(in: CharacterSet(charactersIn: "0123456789"))
    }

    func filteringCharacters(in set: CharacterSet) -> String {
        guard !isEmpty else { return self }
        return String(unicodeScalars.filter { set.contains($0) })
    }
    
    var localized: String {
        return localized()
    }
    
    func localized(in bundle: Bundle? = nil, table: String? = nil) -> String {
        return (bundle ?? Bundle.main).localizedString(forKey: self, value: self, table: table)
    }
}
