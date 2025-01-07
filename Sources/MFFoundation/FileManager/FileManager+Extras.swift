/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
//  Files.swift
//  Created by Tristan Leblanc on 21/11/2020.

import Foundation

public extension FileManager {
    
    /// Read data from all files in a directory
    ///
    /// This function does not test any parameter and does nothing with nils
    
    func forEachDataInDirectory(url: URL, closure: (URL, Data)->Void) {
        forEachFileInDirectory(url: url) { fileURL in
            if fileExists(atPath: fileURL.path), let data = try? Data(contentsOf: fileURL) {
                closure(fileURL, data)
            }
        }
    }
    
    /// Iterate files urls in a directory
    
    func forEachFileInDirectory(url: URL?, closure: (URL)->Void) {
        guard let url = url, let fileURLs = try? contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []) else {
            return
        }
        for fileURL in fileURLs {
            var isDir: ObjCBool = false
            let url = fileURL.absoluteString
            let path = String(url.suffix(url.count - 7))
            if fileExists(atPath: path, isDirectory: &isDir) {
                if !isDir.boolValue {
                    closure(fileURL)
                }
            }
        }
    }
    
    /// Iterate directories urls in a directory
    
    func forEachFolderInDirectory(url: URL?, closure: (URL)->Void) {
        guard let url = url, let fileURLs = try? contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []) else {
            return
        }
        for fileURL in fileURLs {
            var isDir: ObjCBool = false
            if fileExists(atPath: fileURL.absoluteString, isDirectory: &isDir) {
                if !isDir.boolValue {
                    closure(fileURL)
                }
            }
        }
    }
}
