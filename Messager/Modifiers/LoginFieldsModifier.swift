//
//  LoginFieldsModifier.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-12.
//

import SwiftUI

struct LoginFieldsModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            content
                .padding()
            Divider()
        }
    }
}

#Preview {
    TextField("Test", text: .constant(""))
        .modifier(LoginFieldsModifier())
}
