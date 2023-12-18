//
//  PopOverView.swift
//  Gradify
//
//  Created by Андрiй on 18.12.2023.
//

import SwiftUI

struct PopOverView: View {
    @Namespace var animation
    //var animation: Namespace.ID

    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
            Button("Close")
            {
                // Close the popover
                //NSApp.sendAction(#selector(NSPopover.performClose(_:)), to: nil, from: nil)
            }
            .padding()
        }
        .frame(maxWidth: 200, maxHeight: 100)
    }
}

struct PopOverView_Previews: PreviewProvider
{
    static var previews: some View
    {
        PopOverView()
    }
}
