//
//  BlueBehindWindow.swift
//  Gradify
//
//  Created by Андрiй on 23.12.2023.
//

import Foundation
import SwiftUI

struct BlurBehindWindow: NSViewRepresentable
{
    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.state = .active
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .hudWindow//.ultraDark
        
        return visualEffectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
