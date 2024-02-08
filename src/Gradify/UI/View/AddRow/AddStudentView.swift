//
//  AddStudentView.swift
//  Gradify
//
//  Created by Андрiй on 04.02.2024.
//

import SwiftUI

struct AddStudentView: View
{
    @State private var name:                    String = ""
    @State private var lastName:                String = ""
    @State private var surname:                 String = ""
    @State private var selectedDate:            Date = Date()
    @State private var contactNumber:           String = ""
    @State private var passportNumber:          String = ""
    @State private var residenceAddress:        String = ""
    @State private var group:                   String = "Без групи"
    @State private var educationProgram:        String = "Немає програми"
        
    @State private var isWrongName:             Bool = false
    @State private var isWrongLastName:         Bool = false
    @State private var isWrongSurname:          Bool = false
    @State private var isWrongContactNumber:    Bool = false
    @State private var isWrongPassportNumber:   Bool = false
    @State private var isWrongResidenceAddress: Bool = false

    @State private var groupList:               [String] = []
    @State private var educatProgramList:       [String] = []

    @Binding var isShowForm:                    Bool
    @Binding var statusSave:                    Bool
    @ObservedObject var writeModel:             ReadWriteModel    
    
    var body: some View
    {
        VStack
        {
            Text("Додавання студента")
                .foregroundColor(Color("MainTextForBlur"))
                .font(.system(size: 13))
                .fontWeight(.bold)
                .padding(.top, 8)

            Form
            {
                Section(header: Text("Головне"))
                {
                    TextField("Ім'я", text: $name)
                        .foregroundColor(isWrongName ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if name.isEmpty
                                {
                                    Text("Біллі")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                    
                    TextField("Прізвище", text: $lastName)
                        .foregroundColor(isWrongLastName ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if lastName.isEmpty
                                {
                                    Text("Геррінґтон")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                    
                    TextField("По батькові", text: $surname)
                        .foregroundColor(isWrongSurname ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if surname.isEmpty
                                {
                                    Text("Андрійович")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                }
                
                Section(header: Text("Додаткова інформація"))
                {
                    DatePicker("Дата народження", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                    
                    TextField("Номер телефону", text: $contactNumber)
                        .foregroundColor(isWrongContactNumber ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if contactNumber.isEmpty
                                {
                                    Text("+380 000 00 00 00")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: contactNumber)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789+".contains($0) }
                                contactNumber = String(filteredValue.prefix(13))
                            }
                    
                    TextField("Номер паспорту", text: $passportNumber)
                        .foregroundColor(isWrongPassportNumber ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if passportNumber.isEmpty
                                {
                                    Text("000000000")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: passportNumber)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                passportNumber = String(filteredValue.prefix(8))
                            }
                    
                    
                    TextField("Адреса проживання", text: $residenceAddress)
                        .foregroundColor(isWrongResidenceAddress ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if residenceAddress.isEmpty
                                {
                                    Text("Вул.Січових Гачистів 4")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                    
                    Picker("Навчальна програма", selection: $educationProgram)
                    {
                        Text("Немає програми")
                                .tag("Немає програми")
                        
                        Divider()
                        
                        ForEach(educatProgramList, id: \.self)
                        {
                            Text($0)
                                .tag($0)
                        }
                    }// Picker for select educationProgram
                    
                    
                    Picker("Група", selection: $group)
                    {
                        Text("Без групи")
                                .tag("Без групи")

                        Divider()
                        
                        ForEach(groupList, id: \.self)
                        {
                            Text($0)
                                .tag($0)
                        }
                    }// Picker for select group
                }
            }// Form with info and TextField
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            Spacer()
            
            if isWrongName || isWrongLastName || isWrongSurname || isWrongContactNumber || isWrongPassportNumber || isWrongResidenceAddress
            {
                Text("Заповніть всі поля коректно")
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
                    if !name.isEmpty && !lastName.isEmpty && !surname.isEmpty && !contactNumber.isEmpty && contactNumber.count >= 12 && passportNumber.count == 8 && !residenceAddress.isEmpty
                    {
                        isShowForm = false
                                                
                        Task
                        {
                            statusSave = await writeModel.addNewStudent(name: name, lastName: lastName, surname: surname, dateBirth:  dateFormatter.string(from: selectedDate), contactNumber: contactNumber, passportNumber: passportNumber, residenceAddress: residenceAddress, educationProgram: educationProgram, group: group)
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
                            if lastName.isEmpty
                            {
                                isWrongLastName = true
                            }
                            if surname.isEmpty
                            {
                                isWrongSurname = true
                            }
                            if contactNumber.isEmpty || contactNumber.count < 12
                            {
                                isWrongContactNumber = true
                            }
                            if passportNumber.count < 8
                            {
                                isWrongPassportNumber = true
                            }
                            if residenceAddress.isEmpty
                            {
                                isWrongResidenceAddress = true
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
                .padding(.horizontal, 12)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
        }// Main VStack
        .frame(width: 400, height: 550)
        .onAppear
        {
            fetchGroupsAndEducationPrograms()
        }
    }
    
    
    private func fetchGroupsAndEducationPrograms()
    {
        Task
        {
            self.groupList = await writeModel.getGroupNameList()
            self.educatProgramList = await writeModel.getEducatProgramNameList()
        }
    }// private func fetchGroupsAndEducationPrograms()
}

/*
 #Preview
 {
 AddStudentView()
 }
 */
