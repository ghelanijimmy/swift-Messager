//
//  KeyboardDismiss.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-12.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
