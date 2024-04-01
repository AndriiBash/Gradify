//
//  TeacherCardViewModel.swift
//  Gradify
//
//  Created by Андрiй on 01.04.2024.
//

import SwiftUI

struct TeacherCardViewModel: View
{
    @State private var isHovered:               Bool = false

    @State private var showAboutTeacher:        Bool = false
    @State private var showEditTeacher:         Bool = false
    @State private var showDeleteTaecher:       Bool = false
    
    @Binding var teacher:                       Teacher
    @Binding var isUpdateTeacher:               Bool
    @ObservedObject var writeModel:             ReadWriteModel

    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(teacher.lastName) \(teacher.name) \(teacher.surname)")
                    .font(.title2)
            }// HStack with main info
            .padding(.top, 6)
            
            Spacer()
            
            VStack
            {
                HStack
                {
                    Image(systemName: "birthday.cake")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(dateFormatter.string(from: teacher.dateBirth))")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with contact number
                
                HStack
                {
                    Image(systemName: "phone.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(teacher.contactNumber)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with contact number
                
                HStack
                {
                    Image(systemName: "house")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(teacher.residenceAddress)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with residence address
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
                    showDeleteTaecher.toggle()
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
                    showEditTeacher.toggle()
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
                    showAboutTeacher.toggle()
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
        .sheet(isPresented: $showAboutTeacher)
        {
            RowTeacherView(isShowView: $showAboutTeacher, isEditView: $showEditTeacher, teacher: teacher)
        }
        .sheet(isPresented: $showEditTeacher)
        {
            //EditDepartmentView(isShowView: $showAboutDepartment, isEditView: $showEditDepartment, isUpdateListDepartment: $isUpdateDeparment, department: $department, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteTaecher)
        {
            AcceptDeleteRowTeacher(teacher: $teacher, isShowSelfView: $showDeleteTaecher, isUpdateListTeacher: $isUpdateTeacher, writeModel: writeModel)
        }
        
    } // body
}
