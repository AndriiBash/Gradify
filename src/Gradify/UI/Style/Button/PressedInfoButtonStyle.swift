//
//  PressedInfoButtonStyle.swift
//  Gradify
//
//  Created by Андрiй on 01.02.2024.
//

import Foundation
import SwiftUI

struct PressedInfoButtonStyle: ButtonStyle
{
    func makeBody(configuration: Self.Configuration) -> some View
    {
        configuration.label
            .padding(6)
            .background(configuration.isPressed ? Color("PressedInfoButton") : Color("InfoButton"))
            .cornerRadius(12)
    }
}
