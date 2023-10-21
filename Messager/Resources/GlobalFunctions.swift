//
//  GlobalFunctions.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-18.
//

import Foundation


func fileNameFrom(fileUrl: String) -> String {
    
    return ((fileUrl.components(separatedBy: "_").last)?.components(separatedBy: "?").first)?.components(separatedBy: ".").first ?? ""
}

// MARK: - FILEMANAGER HELPERS
func getDocumentsURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileInDocumentsDirectory(fileName: String) -> String {
    return getDocumentsURL().appendingPathComponent(fileName).path()
}

func fileExistsAtPath(path: String) -> Bool {
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
}

func timeElapsed(_ date: Date) -> String {
    let seconds = Date().timeIntervalSince(date)
    var elapsedTime = ""
    
    if seconds < 60 {
        elapsedTime = "Just now"
    } else if seconds < 60 * 60 {
        let minutes = Int(seconds / 60)
        elapsedTime = "\(minutes) min\(minutes > 1 ? "s" : "")"
    } else if seconds < 24 * 60 * 60 {
        let hours = Int(seconds / (60 * 60))
        elapsedTime = "\(hours) hour\(hours > 1 ? "s" : "")"
    } else {
        elapsedTime = date.longDate()
    }
    
    return elapsedTime
}
