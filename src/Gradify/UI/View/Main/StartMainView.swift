//
//  StartMainView.swift
//  Gradify
//
//  Created by Андрiй on 17.04.2024.
//

import SwiftUI

struct StartMainView: View 
{
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0
    
    let windowSize = NSScreen.main?.visibleFrame.size ?? .zero

    
    
    var body: some View
    {
        ZStack 
        {
            BlurBehindWindow()
                .ignoresSafeArea()
        
            
            VStack
            {
                Text("Вітання!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)
                    .padding()

                Text("Для початку роботи у Gradify оберіть список зліва який вас цікавить")
                    .font(.system(size: 12, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding()
            }// main VStack
        }// main ZStack
        .frame(maxWidth: .infinity,
               minHeight: 240, maxHeight: .infinity)
        .navigationTitle("Початкова сторінка")

    }
}
