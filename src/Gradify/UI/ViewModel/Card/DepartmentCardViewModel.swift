//
//  DepartmentCardViewModel.swift
//  Gradify
//
//  Created by Андрiй on 22.03.2024.
//

import SwiftUI

struct DepartmentCardViewModel: View
{
    @State private var isHovered:               Bool = false

    @State private var showAboutDepartment:     Bool = false
    @State private var showEditDepartment:      Bool = false
    @State private var showDeleteDepartment:    Bool = false
    
    @Binding var department:                    Department
    @Binding var isUpdateDeparment:             Bool
    @ObservedObject var writeModel:             ReadWriteModel

    var body: some View
    {
        VStack
        {
            Spacer()
            
            HStack
            {
                Text("\(department.name)")
                    .font(.title2)
            }// HStack with main info
            .padding(.top, 6)
            
            Spacer()
            
            VStack
            {
                HStack
                {
                    Image(systemName: "doc.text.magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(department.specialization)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with info specialization department
                
                HStack
                {
                    Image(systemName: "laurel.leading")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(department.departmentLeader)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with departmentLeader department

                HStack
                {
                    Image(systemName: "square.split.bottomrightquarter")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.blue)
                    
                    Text("\(department.departmentOffice)")
                        .font(.subheadline)
                    
                    Spacer()
                }// Hstack with facultyOffice department
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
                    showDeleteDepartment.toggle()
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
                    showEditDepartment.toggle()
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
                    showAboutDepartment.toggle()
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
        .sheet(isPresented: $showAboutDepartment)
        {
            RowDepartmentView(isShowView: $showAboutDepartment, isEditView: $showEditDepartment, department: department)
        }
        .sheet(isPresented: $showEditDepartment)
        {
            //EditFacultyView(isShowView: $showAboutFaculty, isEditView: $showEditFaculty, isUpdateListFaculty: $isUpdateFaculty, faculty: $faculty, writeModel: writeModel)
        }
        .sheet(isPresented: $showDeleteDepartment)
        {
            AcceptDeleteRowDepartment(departament: $department, isShowSelfView: $showDeleteDepartment, isUpdateListDepartment: $isUpdateDeparment, writeModel: writeModel)
        }
    }// body
}
