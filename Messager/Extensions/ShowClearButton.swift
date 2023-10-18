//
//  ShowClearButton.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-17.
//

import Foundation
import SwiftUI

extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(inputText: text))
    }
}
