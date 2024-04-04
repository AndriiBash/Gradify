//
//  SubjectCardViewModel.swift
//  Gradify
//
//  Created by Андрiй on 03.04.2024.
//

import SwiftUI

struct SubjectCardViewModel: View
{
    @State private var isHovered:                   Bool = false

    @State private var showAboutSubject:            Bool = false
    @State private var showEditSubject:             Bool = false
    @State private var showDeleteSubject:           Bool = false
    
    @Binding var subject:                           Subject
    @Binding var isUpdateSubject:                   Bool
    @ObservedObject var writeModel:                 ReadWriteModel

    
    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(subject.name)")
                    .font(.title2)
            }// HStack with main info
            
            Spacer()
            
            VStack
            {
                HStack
                {
                    Image(systemName: "globe.desk")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(subject.departamentSubject)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with info departament Subject subject
                
                HStack
                {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(subject.totalHours) годин")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with info totalHours lern subject

                HStack
                {
                    Image(systemName: "command")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(subject.semesterControl)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with info semesterControl subject                
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
                    showDeleteSubject.toggle()
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
                    showEditSubject.toggle()
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
                    showAboutSubject.toggle()
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
        .sheet(isPresented: $showAboutSubject)
        {
            RowSubjectView(isShowView: $showAboutSubject, isEditView: $showEditSubject, subject: subject)
        }
        .sheet(isPresented: $showEditSubject)
        {
            EditSubjectView(isShowView: $showAboutSubject, isEditView: $showEditSubject, isUpdateListSubject: $isUpdateSubject, subject: $subject, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteSubject)
        {
            AcceptDeleteRowSubject(subject: $subject, isShowSelfView: $showDeleteSubject, isUpdateListSubject: $isUpdateSubject, writeModel: writeModel)
        }

    }
}
