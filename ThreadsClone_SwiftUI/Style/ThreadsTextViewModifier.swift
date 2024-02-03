//
//  ThreadsTextViewModifier.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI

struct ThreadsTextViewModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 352,height: 38)
            .padding(12)
    }
}
