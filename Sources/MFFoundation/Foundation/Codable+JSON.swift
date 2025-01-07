/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
// JSON.swift
// Created by Tristan Leblanc on 22/11/2020.

import Foundation

public protocol JSONCodable: Codable {
    
}

public extension JSONCodable {
    
    static func make(with json: Data) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: json)
    }
    
    func json() throws -> Data  {
        return try JSONEncoder().encode(self)
    }
}
