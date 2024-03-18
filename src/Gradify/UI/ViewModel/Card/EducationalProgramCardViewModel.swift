//
//  EducationalProgramCardViewModel.swift
//  Gradify
//
//  Created by Андрiй on 18.03.2024.
//

import SwiftUI

struct EducationalProgramCardViewModel: View
{
    @State private var isHovered:                       Bool = false

    @State private var showAboutEducationalProgram:     Bool = false
    @State private var showEditEducationalProgram:      Bool = false
    @State private var showDeleteEducationalProgram:    Bool = false
    
    @Binding var educationalProgramm:                   EducationalProgram
    @Binding var isUpdateEducationalProgramm:           Bool
    @ObservedObject var writeModel:                     ReadWriteModel

    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(educationalProgramm.name)")
                    .font(.title2)
            }// HStack with main info
            
            VStack
            {
                HStack
                {
                    Image(systemName: "hammer.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(educationalProgramm.specialty)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack speciality seducational Programm
                
                HStack
                {
                    Image(systemName: "level")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(educationalProgramm.level)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with educationalProgramm level
                
                HStack
                {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(educationalProgramm.duration)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with duration educationalProgramm
                
                
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
                    showDeleteEducationalProgram.toggle()
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
                    showEditEducationalProgram.toggle()
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
                    showAboutEducationalProgram.toggle()
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
        .sheet(isPresented: $showAboutEducationalProgram)
        {
            RowEducationalProgramView(isShowView: $showAboutEducationalProgram, isEditView: $showEditEducationalProgram, educationProgram: educationalProgramm)
        }
        .sheet(isPresented: $showEditEducationalProgram)
        {
            EditEducationProgramView(isShowView: $showAboutEducationalProgram, isEditView: $showEditEducationalProgram, isUpdateListSpeciality: $isUpdateEducationalProgramm, educationProgram: $educationalProgramm, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteEducationalProgram)
        {
            AcceptDeleteRowEducationalProgram(educationalProgram: $educationalProgramm, isShowSelfView: $showDeleteEducationalProgram, isUpdateListEducationalProgram: $isUpdateEducationalProgramm, writeModel: writeModel)
        }

    }
}
