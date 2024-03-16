//
//  SpecialityCardViewModel.swift
//  Gradify
//
//  Created by Андрiй on 16.03.2024.
//

import SwiftUI

struct SpecialityCardViewModel: View
{
    @State private var isHovered:               Bool = false

    @State private var showAboutSpeciality:     Bool = false
    @State private var showEditSpeciality:      Bool = false
    @State private var showDeleteSpeciality:    Bool = false
    
    @Binding var speciality:                    Specialty
    @Binding var isUpdateSpecialization:        Bool
    @ObservedObject var writeModel:             ReadWriteModel

    
    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(speciality.name)")
                    .font(.title2)
            }// HStack with main info
            
            Spacer()
            
            VStack
            {
                HStack
                {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(speciality.duration)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with info duration teach
                
                HStack
                {
                    Image(systemName: "hryvniasign")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(speciality.tuitionCost) грн.")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with info tuition Cost

                HStack
                {
                    Image(systemName: "doc.text.magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(speciality.specialization)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with info specialization speciality

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
                    showDeleteSpeciality.toggle()
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
                    showEditSpeciality.toggle()
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
                    showAboutSpeciality.toggle()
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
        .sheet(isPresented: $showAboutSpeciality)
        {
            RowSpecialityView(isShowView: $showAboutSpeciality, isEditView: $showEditSpeciality, speciality: speciality)
        }
        .sheet(isPresented: $showEditSpeciality)
        {
            //EditSpecializationView(isShowView: $showAboutSpecialization, isEditView: $showEditSpecialization, isUpdateListSpecialization: $isUpdateSpecialization, specialization: $specialization, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteSpeciality)
        {
            AcceptDeleteRowSpecialty(specialty: $speciality, isShowSelfView: $showDeleteSpeciality, isUpdateListSpecialty: $isUpdateSpecialization, writeModel: writeModel)
        }
    }// body
}
