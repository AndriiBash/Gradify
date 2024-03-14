//
//  EditSpecializationView.swift
//  Gradify
//
//  Created by Андрiй on 14.03.2024.
//

import SwiftUI

struct EditSpecializationView: View
{
    @State private var editedName:                      String = ""
    @State private var editedField:                     String = ""
    @State private var editedDescription:               String = ""
    
    @State private var statusSaveString:                String = "Зберегти"

    @State private var isWrongName:                     Bool = false
    @State private var isWrongField:                    Bool = false
    @State private var isWrongDescription:              Bool = false

    @State private var maxWidthForButton:             CGFloat = .zero

    @Binding var isShowView:                          Bool
    @Binding var isEditView:                          Bool
    @Binding var isUpdateListSpecialization:          Bool
    @Binding var specialization:                      Specialization
    
    @ObservedObject var writeModel:                   ReadWriteModel

    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("Редагування [\(editedName)]")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                
                Spacer()
            }// HStack title
            
            Form
            {
                Section(header: Text("Головне"))
                {
                    TextField("Назва", text: $editedName)
                        .foregroundColor(isWrongName ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedName.isEmpty
                                {
                                    Text("Dungeon Master")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for edited name specialization

                    TextField("Галузь", text: $editedField)
                        .foregroundColor(isWrongField ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedField.isEmpty
                                {
                                    Text("Галузь спеціалізаціїї")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for edited name specialization
                }// Section with main info
            
                Section(header: Text("Інше"))
                {
                    TextField("Детальніше", text: $editedDescription)
                        .foregroundColor(isWrongDescription ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedDescription.isEmpty
                                {
                                    Text("Детальніше про спеціалізацію")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for edited name specialization
                }
            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            Spacer()
            
            if isWrongName
            {
                Text("Заповніть всі поля коректно")
                    .foregroundColor(Color.red)
            }
            
            Divider()

            HStack
            {
                Button
                {
                    isEditView = false
                    isShowView = true
                }
                label:
                {
                    Image(systemName: "info.square")
                }// button for edit row
                .padding(.trailing, 12)
                .help("Режим перегляду запису")
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }
                
                Spacer()
                
                Button
                {
                    isEditView = false
                }
                label:
                {
                    Text("Скасувати")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                
                Button
                {
                    if !editedName.isEmpty && !editedField.isEmpty && !editedDescription.isEmpty && !writeModel.isLoadingFetchData
                    {
                        Task
                        {
                            let status = await writeModel.updateSpecialization(id: specialization.id, name: editedName, description: editedDescription, field: editedField)
                                                        
                            isUpdateListSpecialization.toggle()
                            
                            statusSaveString = status ? "Збережено" : "Невдалося зберегти"
                        }
                    }
                    else
                    {
                        withAnimation(Animation.easeIn(duration: 0.35))
                        {
                            isWrongName = false
                            isWrongField = false
                            isWrongDescription = false
                            
                            if editedName.isEmpty
                            {
                                isWrongName = true
                            }
                            if editedField.isEmpty
                            {
                                isWrongField = true
                            }
                            if editedDescription.isEmpty
                            {
                                isWrongDescription = true
                            }
                        }
                    }
                }
                label:
                {
                    Text("\(statusSaveString)")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .help("Зберегти редаговану інформацію про спеціалізацію")
                .keyboardShortcut(.defaultAction)
                .padding(.leading, 12)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
            .padding(.horizontal, 22)
        }// VStack main
        .padding(.top, 8)
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 400, height: 350)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
            
            Task
            {
                self.editedName = specialization.name
                self.editedField = specialization.field
                self.editedDescription = specialization.description
            }
        }
    }
}

