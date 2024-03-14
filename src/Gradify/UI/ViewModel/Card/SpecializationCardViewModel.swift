//
//  SpecializationCardViewModel.swift
//  Gradify
//
//  Created by Андрiй on 14.03.2024.
//

import SwiftUI

struct SpecializationCardViewModel: View
{
    @State private var isHovered:                   Bool = false

    @State private var showAboutSpecialization:     Bool = false
    @State private var showEditSpecialization:      Bool = false
    @State private var showDeleteSpecialization:    Bool = false
    
    @Binding var specialization:                    Specialization
    @Binding var isUpdateSpecialization:            Bool
    @ObservedObject var writeModel:                 ReadWriteModel

    
    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(specialization.name)")
                    .font(.title2)
            }// HStack with main info
            
            Spacer()
            
            VStack
            {
                HStack
                {
                    Image(systemName: "info.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(specialization.description)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with info description spec
            }// VStack with another info
            .padding(.horizontal, 6)
            .padding(.top, 4)
            
            Spacer()
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
                    showDeleteSpecialization.toggle()
                }
                label:
                {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
                .buttonStyle(PressedDeleteButtonStyle())
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0)
                .shadow(radius: 6)
                
                Button
                {
                    showEditSpecialization.toggle()
                }
                label:
                {
                    Image(systemName: "pencil.line")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }// edit button
                .buttonStyle(PressedEditButtonStyle())
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0)
                .shadow(radius: 6)
                
                Button
                {
                    showAboutSpecialization.toggle()
                }
                label:
                {
                    Image(systemName: "info")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }// edit button
                .buttonStyle(PressedInfoButtonStyle())
                .frame(width: 25, height: 25)
                .cornerRadius(12)
                .opacity(isHovered ? 1.0 : 0.0)
                .shadow(radius: 6)
            }// HStack with buttons
                .padding(.top, -6)
                .zIndex(1)
            ,alignment: .topLeading)// end overlay
        .onHover
        { hovering in
            withAnimation(Animation.easeInOut(duration: 0.2).delay(hovering ? 0.2 : 0))
            {
                self.isHovered = hovering
            }
        }
        .sheet(isPresented: $showAboutSpecialization)
        {
            RowSpecializationView(isShowView: $showAboutSpecialization, isEditView: $showEditSpecialization, specialization: specialization)
        }
        .sheet(isPresented: $showEditSpecialization)
        {
            EditSpecializationView(isShowView: $showAboutSpecialization, isEditView: $showEditSpecialization, isUpdateListSpecialization: $isUpdateSpecialization, specialization: $specialization, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteSpecialization)
        {
            AcceptDeleteRowSpecialization(specialization: $specialization, isShowSelfView: $showDeleteSpecialization, isUpdateListSpecialization: $isUpdateSpecialization, writeModel: writeModel)
        }
    }
}
