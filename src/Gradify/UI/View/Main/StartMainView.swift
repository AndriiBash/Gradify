//
//  StartMainView.swift
//  Gradify
//
//  Created by Андрiй on 17.04.2024.
//

import SwiftUI

struct StartMainView: View 
{
    @State private var isHovered:           Bool = false
    @State private var showHelpMenu:        Bool = false
    @State private var offset:              CGSize = .zero
    
    var body: some View
    {
        ZStack 
        {
            BlurBehindWindow()
                .ignoresSafeArea()
        
            VStack(spacing: 28)
            {
                Text("Вітання!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)

                VStack(spacing: 8)
                {
                    Text("Для початку роботи з Gradify оберіть список зліва який вас цікавить")
                        .font(.system(size: 14, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Button
                    {
                        // debug moment
                        print("Відкрити довідку на сторінці де описано відкриття меню")
                    }
                    label:
                    {
                        Text("Немає списку?")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }// button
                    .buttonStyle(PlainButtonStyle())
                }// VStack with subtitle text
                .padding(.horizontal)
            }// main VStack
            .foregroundColor(Color("MainTextForBlur"))
            .frame(width: 280, height: 170)
            .overlay( // button on card
                HStack
                {
                    Button
                    {
                        if let path = Bundle.main.path(forResource: "helpGradify.pdf", ofType: nil)
                        {
                            let url = URL(fileURLWithPath: path)
                            NSWorkspace.shared.open(url)
                        }
                        else
                        {
                            print("no dovidka")
                        }
                        
                        //NSHelpManager.shared.openHelpAnchor(NSHelpManager.AnchorName("MyAnchor"), inBook: NSHelpManager.BookName("com.company.App.help") )
                    }
                    label:
                    {
                        Image(systemName: "questionmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PressedEditButtonStyle())
                    .frame(width: 25, height: 25)
                    .cornerRadius(12)
                    .opacity(isHovered ? 1.0 : 0.0)
                    .shadow(radius: 6)
                    .help("Довідка застосунку")
                }
                .padding(.top, -8)
                .padding(.leading, -4)
                .zIndex(1)
                ,alignment: .topLeading)// end overlay
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thinMaterial)
                    .shadow(radius: 8)
            )
            .onHover
            { hovering in
                withAnimation(Animation.easeInOut(duration: 0.2).delay(hovering ? 0.2 : 0))
                {
                    self.isHovered = hovering
                }
            }
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged
                    { value in
                        offset = value.translation
                    }
                    .onEnded 
                    { value in
                        withAnimation
                        {
                            offset = .zero
                        }
                    })
        }// main ZStack
        .frame(maxWidth: .infinity,
               minHeight: 240, maxHeight: .infinity)
        .navigationTitle("Початкова сторінка")
    }
}
