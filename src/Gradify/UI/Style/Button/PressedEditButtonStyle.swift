//
//  PressedEditButtonStyle.swift
//  Gradify
//
//  Created by Андрiй on 01.02.2024.
//

import Foundation
import SwiftUI

struct PressedEditButtonStyle: ButtonStyle
{
    func makeBody(configuration: Self.Configuration) -> some View
    {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color("PressedEditButton") : Color("EditButton"))
    }
}
