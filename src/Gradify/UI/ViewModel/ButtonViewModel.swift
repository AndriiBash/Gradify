//
//  ButtonView.swift
//  Gradify
//
//  Created by Андрiй on 08.11.2023.
//


// temp!!!


import SwiftUI

struct ButtonViewModel: View
{
    @State private var isFavorite = false
    
    var body: some View
    {
        VStack
        {
            Button
            {
                withAnimation
                {
                    isFavorite.toggle()
                }
            }
            label:
            {
                Label("Toggle Favorite", systemImage: isFavorite ? "checkmark": "heart")
                    .padding()
            }
            .contentTransition(.symbolEffect(.replace))
        }
        .font(.largeTitle)
    }
}

#Preview
{
    ButtonViewModel()
}
