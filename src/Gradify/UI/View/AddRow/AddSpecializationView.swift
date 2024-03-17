//
//  AddSpecializationView.swift
//  Gradify
//
//  Created by Андрiй on 14.03.2024.
//

import SwiftUI

struct AddSpecializationView: View
{
    @State private var name:                    String = ""
    @State private var branch:                  String = "Без галузі"
    @State private var description:             String = ""

    @State private var branchList:              [String] = []

    @State private var isWrongName:             Bool = false
    @State private var isWrongBranch:            Bool = false
    @State private var isWrongDescription:      Bool = false

    @State private var isWrongIdName:           Bool = false

    @Binding var isShowForm:                    Bool
    @Binding var statusSave:                    Bool
    @ObservedObject var writeModel:             ReadWriteModel

    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("Додавання спеціалізації")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                
                Spacer()
            }// HStack title
            
            Form
            {
                Section(header: Text("Головне"))
                {
                    TextField("Назва", text: $name)
                        .foregroundColor(isWrongName || isWrongIdName ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if name.isEmpty
                                {
                                    Text("Назва спеціалізації (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for edited name specialization

                    Picker("Галузь", selection: $branch)
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
                    TextField("Детальніше", text: $description)
                        .foregroundColor(isWrongDescription ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if description.isEmpty
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
                Spacer()
                
                Button
                {
                    isShowForm = false
                }
                label:
                {
                    Text("Скасувати")
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
                    
                    if !name.isEmpty && branch != "Без галузі" && !description.isEmpty && !writeModel.isLoadingFetchData
                    {
                                                
                        Task
                        {
                            let listSpecializationKeyName = await writeModel.getSpecializationNameList(withOut: "")
                        
                            if listSpecializationKeyName.contains(name)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                isShowForm = false
                                
                                statusSave = await writeModel.addNewSpecialization(name: name, description: description, field: branch)
                            }
                        }
                        
                        statusSave = false
                    }
                    else
                    {
                        withAnimation(Animation.easeIn(duration: 0.35))
                        {

                            if name.isEmpty
                            {
                                isWrongName = true
                            }
                            if branch == "Без галузі"
                            {
                                isWrongBranch = true
                            }
                            if description.isEmpty
                            {
                                isWrongDescription = true
                            }
                        }
                    }
                }
                label:
                {
                    Text("Зберегти")
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .keyboardShortcut(.defaultAction)
                .padding(.leading, 6)
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
            Task
            {
                self.branchList         = await writeModel.getBranchName()
            }
        }
    }
}
