//
//  EditStudentView.swift
//  Gradify
//
//  Created by Андрiй on 05.02.2024.
//

import SwiftUI

struct EditStudentView: View
{
    @State private var editedName:                    String = ""
    @State private var editedLastName:                String = ""
    @State private var editedSurname:                 String = ""
    @State private var editedBirthDayDate:            Date = Date()
    @State private var editedContactNumber:           String = ""
    @State private var editedPassportNumber:          String = ""
    @State private var editedResidenceAddress:        String = ""
    @State private var editedGroup:                   String = "Без групи"
    @State private var editedEducationProgram:        String = "Немає програми"
    
    @State private var isWrongName:                   Bool = false
    @State private var isWrongLastName:               Bool = false
    @State private var isWrongSurname:                Bool = false
    @State private var isWrongContactNumber:          Bool = false
    @State private var isWrongPassportNumber:         Bool = false
    @State private var isWrongResidenceAddress:       Bool = false

    @State private var statusSaveString:              String = "Зберегти"
    @State private var groupList:                     [String] = []
    @State private var educatProgramList:             [String] = []

    @State private var maxWidthForButton:             CGFloat = .zero

    @Binding var isShowView:                          Bool
    @Binding var isEditView:                          Bool
    @Binding var isUpdateListStudent:                 Bool
    @Binding var student:                             Student
    
    @ObservedObject var writeModel:                   ReadWriteModel

    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("Редагування [\(editedLastName) \(editedName) \(editedSurname)]")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                
                Spacer()
            }// HStack title
                
            Form
            {
                Section(header: Text("Головне"))
                {
                    TextField("Ім'я", text: $editedName)
                        .foregroundColor(isWrongName ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedName.isEmpty
                                {
                                    Text("Біллі")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                    
                    TextField("Прізвище", text: $editedLastName)
                        .foregroundColor(isWrongLastName ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedLastName.isEmpty
                                {
                                    Text("Геррінґтон")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                    
                    TextField("По батькові", text: $editedSurname)
                        .foregroundColor(isWrongSurname ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedSurname.isEmpty
                                {
                                    Text("Андрійович")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                }// Section with main info
                
                Section(header: Text("Додаткова інформація"))
                {
                    DatePicker("Дата народження", selection: $editedBirthDayDate, in: ...Date(), displayedComponents: .date)
                    
                    TextField("Номер телефону", text: $editedContactNumber)
                        .foregroundColor(isWrongContactNumber ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedContactNumber.isEmpty
                                {
                                    Text("+380 000 00 00 00")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: editedContactNumber)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789+".contains($0) }
                                editedContactNumber = String(filteredValue.prefix(13))
                            }
                    
                    TextField("Номер паспорту", text: $editedPassportNumber)
                        .foregroundColor(isWrongPassportNumber ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedPassportNumber.isEmpty
                                {
                                    Text("000000000")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: editedPassportNumber)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                editedPassportNumber = String(filteredValue.prefix(8))
                            }
                    
                    
                    TextField("Адреса проживання", text: $editedResidenceAddress)
                        .foregroundColor(isWrongResidenceAddress ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedResidenceAddress.isEmpty
                                {
                                    Text("Вул.Січових Гачистів 4")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                    
                    Picker("Навчальна програма", selection: $editedEducationProgram)
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
                    
                    Picker("Група", selection: $editedGroup)
                    {
                        Text("Без групи")
                                .tag("Без групи")

                        Divider()
                        
                        ForEach(groupList, id: \.self) { groupName in
                                        Text(groupName)
                                            .tag(groupName)
                                    }
                    }// Picker for select group
                }// Section with additional info student
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
                Button
                {
                    isEditView = false
                    isShowView = true
                }
                label:
                {
                    Image(systemName: "info.square")
                        //.resizable()
                        //.aspectRatio(contentMode: .fit)
                        //.frame(width: 20, height: 20)
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
                    if !editedName.isEmpty && !editedLastName.isEmpty && !editedSurname.isEmpty && !editedContactNumber.isEmpty && editedContactNumber.count >= 12 && editedPassportNumber.count == 8 && !editedResidenceAddress.isEmpty
                    {
                        Task
                        {
                            let status = await writeModel.updateStudent(id: student.id, name: editedName, lastName: editedLastName, surname: editedSurname, dateBirth: dateFormatter.string(from: editedBirthDayDate), contactNumber: editedContactNumber, passportNumber: editedPassportNumber, residenceAddress: editedResidenceAddress, educationProgram: editedEducationProgram, group: editedGroup)
                            
                            isUpdateListStudent.toggle()
                            
                            statusSaveString = status ? "Збережено" : "Невдалося зберегти"
                        }
                    }
                    else
                    {
                        withAnimation(Animation.easeIn(duration: 0.35))
                        {
                            isWrongName             = false
                            isWrongLastName         = false
                            isWrongSurname          = false
                            isWrongContactNumber    = false
                            isWrongPassportNumber   = false
                            isWrongResidenceAddress = false

                            if editedName.isEmpty
                            {
                                isWrongName = true
                            }
                            if editedLastName.isEmpty
                            {
                                isWrongLastName = true
                            }
                            if editedSurname.isEmpty
                            {
                                isWrongSurname = true
                            }
                            if editedContactNumber.isEmpty || editedContactNumber.count < 12
                            {
                                isWrongContactNumber = true
                            }
                            if editedPassportNumber.count < 8
                            {
                                isWrongPassportNumber = true
                            }
                            if editedResidenceAddress.isEmpty
                            {
                                isWrongResidenceAddress = true
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
                .help("Зберегти редаговану інформацію про студента")
                .keyboardShortcut(.defaultAction)
                .padding(.leading, 12)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
            .padding(.horizontal, 22)
        }// VStack main
        .padding(.top, 8)
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 400, height: 565)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
            
            Task
            {
                self.groupList              = await writeModel.getGroupNameList()
                self.educatProgramList      = await writeModel.getEducatProgramNameList()
                
                editedGroup                 = student.group
                editedEducationProgram      = student.educationProgram
                editedName                  = student.name
                editedLastName              = student.lastName
                editedSurname               = student.surname
                editedBirthDayDate          = student.dateBirth
                editedContactNumber         = student.contactNumber
                editedPassportNumber        = student.passportNumber
                editedResidenceAddress      = student.residenceAddress
            }
        }
        
    }
}

/*
#Preview
{
    EditStudentView()
}
*/
