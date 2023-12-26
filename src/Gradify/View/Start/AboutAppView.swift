//
//  AboutAppView.swift
//  Gradify
//
//  Created by Андрiй on 23.12.2023.
//

import SwiftUI

struct AboutAppView: View
{
    @State private var isPopoverPresented = false

    #if DEBUG
        @State private var imageName: String = "DevMainLogo"
    #else
        @State private var imageName: String = "RealeseMainLogo"
    #endif
    
    
    var body: some View
    {
        HStack
        {
            VStack
            {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125, height: 125)
                    .foregroundColor(Color("CloudLoginView"))
                    .shadow(radius: 4)
            }// VStack with logo
            .padding(.horizontal, 28)
            
            Spacer()
            
            VStack
            {
                HStack
                {
                    Text("Gradify")
                        .font(.system(size: 26, weight: .bold))
                    
                    Spacer()
                }// HStack with name app

                HStack(spacing: 2)
                {
                    Text("Версія " + (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0.0.0"))
                    
                    Text("(" + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "No version") + ")")
                    
                    Spacer()
                }// HStack with version app
                .padding(.bottom, 18)
                .foregroundColor(Color("TextGray"))
                .font(.system(size: 12, weight: .regular))
                
                HStack // maybe use HStack
                {
                    Text("© Андрій Ізбаш., 2023-2025. Всі права захищені. Gradify і логотип Gradify є дипломною роботою і не мають комерційних цілей.")
                    
                    Spacer()
                }// ScrollView with info for app
                .foregroundColor(Color("TextGray"))
                .font(.system(size: 10, weight: .regular))
                .padding(.bottom, 16)

                HStack
                {
                    Button
                    {
                        let url = URL(string: "https://github.com/AndriiBash/Gradify")!
                        NSWorkspace.shared.open(url)
                    }
                    label:
                    {
                        Text("Вихідний код")
                            .padding(.horizontal, 10)
                    }// button open github opensource
             
                    Spacer()
                    
                    Button
                    {
                        isPopoverPresented.toggle()
                    }
                    label:
                    {
                        Text("Подяка")
                            .padding(.horizontal, 12)
                    }// button open github opensource
                    .popover(isPresented: $isPopoverPresented, content: 
                    {
                        RespectView()
                    })//pop over with thanks
                    
                    Spacer()
                }// HStack with button
                
                Spacer()
            }// VStak with another info
            //.padding(.horizontal, 14)
            
            Spacer()
        }// main VStack
        //.padding(.horizontal, 24)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlurBehindWindow().ignoresSafeArea())
    }
}

#Preview
{
    AboutAppView()
}

