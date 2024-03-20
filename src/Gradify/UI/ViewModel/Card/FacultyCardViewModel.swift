//
//  FacultyCardViewModel.swift
//  Gradify
//
//  Created by Андрiй on 20.03.2024.
//

import SwiftUI

struct FacultyCardViewModel: View
{
    @State private var isHovered:            Bool = false

    @State private var showAboutFaculty:     Bool = false
    @State private var showEditFaculty:      Bool = false
    @State private var showDeleteFaculty:    Bool = false
    
    @Binding var faculty:                    Faculty
    @Binding var isUpdateFaculty:            Bool
    @ObservedObject var writeModel:          ReadWriteModel

    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(faculty.name)")
                    .font(.title2)
            }// HStack with main info
            .padding(.top, 6)
            
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
                    
                    Text("\(faculty.description)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with info duration teach
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
                    showDeleteFaculty.toggle()
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
                    showEditFaculty.toggle()
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
                    showAboutFaculty.toggle()
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
        .sheet(isPresented: $showAboutFaculty)
        {
            RowFacultyView(isShowView: $showAboutFaculty, isEditView: $showEditFaculty, faculty: faculty)
        }
        .sheet(isPresented: $showEditFaculty)
        {
            EditFacultyView(isShowView: $showAboutFaculty, isEditView: $showEditFaculty, isUpdateListFaculty: $isUpdateFaculty, faculty: $faculty, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteFaculty)
        {
            AcceptDeleteRowFaculty(faculty: $faculty, isShowSelfView: $showDeleteFaculty, isUpdateListFaculty: $isUpdateFaculty, writeModel: writeModel)
        }

    }
}
