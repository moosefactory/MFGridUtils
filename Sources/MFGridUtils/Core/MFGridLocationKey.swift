//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFGridLocationKey.swift
//  Created by Tristan Leblanc on 08/01/2025.

import Foundation

/// MFGridLocationKey is a unique string key based on location.
///
/// It is used in GridDataLayer, to store cells data in a dictionary.

public struct MFGridLocationKey: Hashable {
    
    public var location: MFGridLocation
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(location.h)
        hasher.combine(location.v)
    }
}

public extension MFGridLocation {
    
    var asKey: MFGridLocationKey {
        MFGridLocationKey(location: self)
    }
}
