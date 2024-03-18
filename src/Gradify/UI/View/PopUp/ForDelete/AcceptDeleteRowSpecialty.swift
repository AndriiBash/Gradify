//
//  AcceptDeleteRowSpecialty.swift
//  Gradify
//
//  Created by Андрiй on 11.03.2024.
//

import SwiftUI

struct AcceptDeleteRowSpecialty: View
{
    @Binding var specialty:                 Specialty
    @Binding var isShowSelfView:            Bool
    @Binding var isUpdateListSpecialty:     Bool
    @ObservedObject var writeModel:         ReadWriteModel

    var body: some View
    {
        VStack
        {
            Spacer()
            
            ZStack
            {
                Color.red
                    .cornerRadius(12)
                
                Image(systemName: "trash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white)
                    .shadow(radius: 8)
                    .padding(12)
            }// ZStack with image
            .frame(width: 65, height: 65, alignment: .center)
            .padding(.vertical, 6)

            Spacer()
            
            VStack(spacing: 12)
            {
                Text(String(localized: "Справді видалити цей запис?"))
                    .fontWeight(.bold)
                
                Text(String(localized: "Цей запис буде видалено назавжди, та відновити його буде неможливо."))
                    .font(.system(size: 12))
                
                VStack(spacing: 6)
                {
                    Button
                    {
                        Task
                        {
                            await writeModel.deleteSpeciality(withId: specialty.id)
                            isUpdateListSpecialty.toggle()
                            isShowSelfView = false
                        }
                    }
                    label:
                    {
                        Text(String(localized: "Видалити запис"))
                            .frame(width: 260)
                            .padding(.vertical, 4)
                            .foregroundColor(Color.red)
                            //.padding(.vertical, 3)
                    }
                    .onHover
                    { isHovered in
                        changePointingHandCursor(shouldChangeCursor: isHovered)
                    }// change cursor when hover

                    Button
                    {
                        isShowSelfView = false;
                    }
                    label:
                    {
                        Text(String(localized: "Скасувати"))
                            .padding(.vertical, 4)
                            .frame(width: 260)
                    }// button cansel restart
                    .onHover
                    { isHovered in
                        changePointingHandCursor(shouldChangeCursor: isHovered)
                    }// change cursor when hover

                }// VStack with button
                .padding(.top, 6)
            }// VStack with info about restart app
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            Spacer()
        }// main VStack
        .frame(width: 290, height: 250)
        .padding()
    }
}
