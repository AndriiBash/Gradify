//
//  TempView.swift
//  Gradify
//
//  Created by Андрiй on 31.01.2024.
//

import SwiftUI


struct TempView: View
{
    @ObservedObject private var readModel = ReadWriteModel()
    @State private var scaleLevel: Int = 0
    @State private var offset: CGSize = .zero

    var body: some View
    {
        ZStack
        {
            // Background with image
            
            BlurBehindWindow()
            
            
            // Square
            VStack
            {
                
            }
            .frame(width: 200, height: 200)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20.0))
            .offset(offset)
            .gesture(DragGesture().onChanged
                     { value in
                self.offset = value.translation
            })


        }
    }
}



#Preview
{
    TempView()
}
