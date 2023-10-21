//
//  DateExtension.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-21.
//

import Foundation

extension Date {
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        return dateFormatter.string(from: self)
    }
}
