//
//  TextFieldClearButton.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-17.
//

import Foundation
import SwiftUI


struct TextFieldClearButton: ViewModifier {
    @Binding var inputText: String
    func body(content: Content) -> some View {
        content
            .overlay {
                if !inputText.isEmpty {
                    HStack {
                        Spacer()
                        Button(action: {
                            inputText = ""
                        }, label: {
                            Image(systemName: "multiply.circle.fill")
                        })
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 4)
                    }
                }
            }
    }
}
