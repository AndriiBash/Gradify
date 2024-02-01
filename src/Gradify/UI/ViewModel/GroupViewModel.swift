//
//  Row.swift
//  Gradify
//
//  Created by Андрiй on 01.02.2024.
//

import Foundation
import SwiftUI

struct GroupViewModel: View
{
    @State private var isHovered: Bool = false

    var name: String
    var lastName: String
    
    var body: some View
    {
        VStack
        {
            Spacer()
         
            Text("\(name)")
                .font(.title)
            Text("\(lastName)")
                .font(.subheadline)
            
            Spacer()
            
            VStack
            {
                Text("Test text in bottom")
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(10, corners: [.bottomRight, .bottomLeft])
            .clipped()
        }// main vstack
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 250, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.thinMaterial)
                .shadow(radius: 8)
        )
        .padding(.leading, 4)
        .overlay( // button on card
            HStack
            {

                Button
                {
                    //self.didTap = true
                }
                label:
                {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0)
                .shadow(radius: 6)
                .buttonStyle(PressedDeleteButtonStyle())
                
                Button
                {
                    // star wars
                }
                label:
                {
                    Image(systemName: "pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }// edit button
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0)
                .shadow(radius: 6)
                .buttonStyle(PressedEditButtonStyle())
                
                Button
                {
                    // nothing...
                }
                label:
                {
                    Image(systemName: "info")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 13, height: 13)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }// edit button
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0)
                .shadow(radius: 6)
                .buttonStyle(PressedInfoButtonStyle())
            }// HStack with buttons
            .padding(.top, 4)
            ,alignment: .topLeading)// end overlay
        .onHover
        { hovering in
            withAnimation(Animation.easeInOut(duration: 0.2).delay(hovering ? 0.3 : 0))
            {
                self.isHovered = hovering
            }
        }

    }
}
