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
