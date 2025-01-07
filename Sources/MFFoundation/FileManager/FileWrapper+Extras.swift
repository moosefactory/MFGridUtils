/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
// FileWrapper+Extras
// Created by Tristan Leblanc on 13/04/2021.


import Foundation

//MARK: - File Wrappers Extensions

public extension FileWrapper {

    /// Adds a regular file wrapper to this wrapper
    
    func addFileWrapper(for name: String, with data: Data) -> FileWrapper {
        if let existingFileWrapper = fileWrappers?[name] {
            return existingFileWrapper
        }
        let fw = FileWrapper(regularFileWithContents: data)
        fw.preferredFilename = name
        addFileWrapper(fw)
        return fw
    }
    
    /// Adds a folder file wrapper to this wrapper
    ///
    /// It scans the directory url to add a regular file wrapper for each file inside.
    /// If recursive is true, it also creates wrappers for sub-folders
    
    func addFolderFileWrapper(for name: String, in directoryURL: URL) -> FileWrapper {
        if let existingFileWrapper = fileWrappers?[name] {
            return existingFileWrapper
        }
        let fm = FileManager.default
        var filesWrappers = [String: FileWrapper]()
        fm.forEachDataInDirectory(url: directoryURL) { url, data in
            let fileWrapper = FileWrapper(regularFileWithContents: data)
            filesWrappers[url.lastPathComponent] = fileWrapper
        }
        let fw = FileWrapper(directoryWithFileWrappers: filesWrappers)
        fw.preferredFilename = name
        addFileWrapper(fw)
        return fw
    }
}
