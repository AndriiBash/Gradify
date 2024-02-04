//
//  ErrorSaveView.swift
//  Gradify
//
//  Created by Андрiй on 04.02.2024.
//

import SwiftUI

struct ErrorSaveView: View
{
    @Binding var isAnimated: Bool
    @State var startAnimate: Bool = true

    var body: some View
    {
        VStack
        {
            Image(systemName: "xmark.icloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .symbolEffect(.bounce, value: startAnimate)
                .foregroundColor(Color.red)
                .onAppear
                {
                    animateIcon()
                }
                Text("Запис не вдалося зберегти!")
                    .foregroundColor(Color("MainTextForBlur"))
                    .fontWeight(.bold)
            //.colorScheme(.dark)
        }// VStack
        .frame(width: 220, height: 220)
        .ignoresSafeArea()
    }
    
    func animateIcon()
    {
        if isAnimated
        {
            startAnimate.toggle()
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5)
            {
                DispatchQueue.main.async
                {
                    animateIcon()
                }
            }
        }
    }// func animateIcon()

}

struct ErrorSavveView_Previews: PreviewProvider
{
    @State static var isAnimated: Bool = true
    
    static var previews: some View
    {
        ErrorSaveView(isAnimated: $isAnimated)
    }
}
