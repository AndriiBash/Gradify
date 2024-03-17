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
    @State private var editedBranch:                    String = "Без галузі"
    @State private var editedDescription:               String = ""
    
    @State private var branchList:                      [String] = []

    @State private var statusSaveString:                String = "Зберегти"

    @State private var isWrongIdName:                   Bool = false
    @State private var isWrongName:                     Bool = false
    @State private var isWrongBranch:                   Bool = false
    @State private var isWrongDescription:              Bool = false

    @State private var maxWidthForButton:               CGFloat = .zero

    @Binding var isShowView:                            Bool
    @Binding var isEditView:                            Bool
    @Binding var isUpdateListSpecialization:            Bool
    @Binding var specialization:                        Specialization
    
    @ObservedObject var writeModel:                     ReadWriteModel

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
                        .foregroundColor(isWrongName || isWrongIdName ? Color.red : Color("MainTextForBlur"))
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

                    Picker("Галузь", selection: $editedBranch)
                    {
                        Text("Без галузі")
                                .tag("Без галузі")

                        Divider()
                        
                        ForEach(branchList, id: \.self)
                        { branch in
                            Text(branch)
                                .tag(branch)
                        }
                    }// Picker for select branch speciality
                    .foregroundColor(isWrongBranch ? Color.red : Color("PopUpTextColor"))
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
            
            if isWrongName || isWrongBranch || isWrongDescription
            {
                Text("Заповніть всі поля коректно")
                    .foregroundColor(Color.red)
            }
            
            if isWrongIdName
            {
                Text("Назва спеціалізації не повина збігатися з назвами інших спеціалізацій")
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
                    withAnimation(Animation.easeIn(duration: 0.35))
                    {
                        isWrongName = false
                        isWrongBranch = false
                        isWrongDescription = false
                        isWrongIdName = false
                    }
                    
                    if !editedName.isEmpty && editedBranch != "Без галузі" && !editedDescription.isEmpty && !writeModel.isLoadingFetchData
                    {
                        Task
                        {
                            let listSpecializationKeyName = await writeModel.getSpecializationNameList(withOut: specialization.name)
                        
                            if listSpecializationKeyName.contains(editedName)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                let status = await writeModel.updateSpecialization(id: specialization.id, name: editedName, description: editedDescription, field: editedBranch)
                                                            
                                isUpdateListSpecialization.toggle()
                                
                                statusSaveString = status ? "Збережено" : "Невдалося зберегти"
                            }
                        }
                    }
                    else
                    {
                        withAnimation(Animation.easeIn(duration: 0.35))
                        {
                            
                            if editedName.isEmpty
                            {
                                isWrongName = true
                            }
                            if editedBranch == "Без галузі"
                            {
                                isWrongBranch = true
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
        .frame(width: 400, height: 330)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
            
            Task
            {
                self.editedName = specialization.name
                self.editedBranch = specialization.field
                self.editedDescription = specialization.description
                
                self.branchList         = await writeModel.getBranchName()

            }
        }
    }
}

