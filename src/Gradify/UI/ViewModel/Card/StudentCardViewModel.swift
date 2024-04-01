//
//  Row.swift
//  Gradify
//
//  Created by Андрiй on 01.02.2024.
//

import Foundation
import SwiftUI

struct StudentCardViewModel: View
{
    @State private var isHovered:        Bool = false

    @State private var showAboutStudent: Bool = false
    @State private var showEditStudent:  Bool = false
    @State private var showDeleteStudent:Bool = false
    
    @Binding var student:                Student
    @Binding var isUpdateStudent:        Bool
    @ObservedObject var writeModel:      ReadWriteModel
    
    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(student.lastName) \(student.name) \(student.surname)")
                    .font(.title2)
            }// HStack with main info
            
            VStack
            {
                HStack
                {
                    Image(systemName: "birthday.cake")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(dateFormatter.string(from: student.dateBirth))")
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
                    
                    Text("\(student.contactNumber)")
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
                    
                    Text("\(student.residenceAddress)")
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
                    showDeleteStudent.toggle()
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
                    showEditStudent.toggle()
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
                    showAboutStudent.toggle()
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
        .sheet(isPresented: $showAboutStudent)
        {
            RowStudentView(isShowView: $showAboutStudent, isEditView: $showEditStudent, student: student)
        }
        .sheet(isPresented: $showEditStudent)
        {
            EditStudentView(isShowView: $showAboutStudent, isEditView: $showEditStudent, isUpdateListStudent: $isUpdateStudent, student: $student, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteStudent)
        {
            AcceptDeleteRowStudent(student: $student, isShowSelfView: $showDeleteStudent, isUpdateListStudent: $isUpdateStudent, writeModel: writeModel)
        }
    }// body
}
