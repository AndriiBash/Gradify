//
//  SuccessSaveView.swift
//  Gradify
//
//  Created by Андрiй on 04.02.2024.
//

import SwiftUI

struct SuccessSaveView: View
{
    @State var startAnimate: Bool = true
    @Binding var isAnimated: Bool

    var body: some View
    {
        VStack
        {
            Image(systemName: "checkmark.icloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment: .center)
                .symbolEffect(.bounce, value: startAnimate)
                .foregroundColor(Color.blue)
                .onAppear
                {
                    animateIcon()
                }
                Text("Запис успішно збережено!")
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

struct SuccessSaveView_Previews: PreviewProvider
{
    @State static var isAnimated: Bool = true
    
    static var previews: some View
    {
        SuccessSaveView(isAnimated: $isAnimated)
    }
}
