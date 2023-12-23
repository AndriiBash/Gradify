//
//  AboutAppView.swift
//  Gradify
//
//  Created by Андрiй on 23.12.2023.
//

import SwiftUI

struct AboutAppView: View
{
    var body: some View
    {
        VStack
        {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Image(systemName: "photo.on.rectangle.angled")
        }// main VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlurBehindWindow().ignoresSafeArea())
    }
}

#Preview
{
    AboutAppView()
}

