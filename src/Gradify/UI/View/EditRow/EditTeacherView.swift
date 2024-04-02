//
//  EditTeacherView.swift
//  Gradify
//
//  Created by Андрiй on 02.04.2024.
//

import SwiftUI

struct EditTeacherView: View
{
    @State private var editedName:                      String = ""
    @State private var editedLastName:                  String = ""
    @State private var editedSurname:                   String = ""
    @State private var editedBirthDayDate:              Date = Date()
    @State private var editedContactNumber:             String = ""
    @State private var editedPassportNumber:            String = ""
    @State private var editedResidenceAddress:          String = ""
    @State private var editedCategory:                  String = "Без категорії"

    @State private var editedSpecialization:            [String] = []
    
    @State private var isWrongName:                     Bool = false
    @State private var isWrongLastName:                 Bool = false
    @State private var isWrongSurname:                  Bool = false
    @State private var isWrongContactNumber:            Bool = false
    @State private var isWrongPassportNumber:           Bool = false
    @State private var isWrongResidenceAddress:         Bool = false
    @State private var isWrongLastSpecialization:       Bool = false

    @State private var isWrongSpecialization:           [Bool] = []

    @State private var statusSaveString:                String = "Зберегти"
    @State private var specializationList:          [String] = []
    @State private var categoryList:                [String] = []

    @State private var maxWidthForButton:               CGFloat = .zero

    @Binding var isShowView:                            Bool
    @Binding var isEditView:                            Bool
    @Binding var isUpdateListTeacher:                   Bool
    @Binding var teacher:                               Teacher
    
    @ObservedObject var writeModel:                     ReadWriteModel

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
                }// main section
                
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
                    
                    Picker("Категорія", selection: $editedCategory)
                    {
                        Text("Без категорії")
                                .tag("Без категорії")

                        Divider()
                        
                        ForEach(categoryList, id: \.self)
                        {
                            Text($0)
                                .tag($0)
                        }
                    }// Picker for select category
                }// detail form
                
                Section(header: Text("Спеціалізація"))
                {
                    ForEach(editedSpecialization.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Спеціалізація №\(index + 1)", selection: $editedSpecialization[index])
                            {
                                Text("Спеціалізацію не обрано")
                                        .tag("Спеціалізацію не обрано")

                                Divider()
                                
                                ForEach(specializationList, id: \.self)
                                { subject in
                                    Text(subject)
                                        .tag(subject)
                                }
                            }// Picker for select specialization
                            .foregroundColor(isWrongSpecialization[index] ? Color.red : Color("PopUpTextColor"))
                            
                            Button
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    editedSpecialization.remove(at: index)
                                    isWrongSpecialization.remove(at: index)
                                }
                            }
                            label:
                            {
                                Image(systemName: "trash")
                                    .aspectRatio(contentMode: .fit)
                            }// Button for delete specialization
                            .help("Видалити спеціалізацію")
                        }
                    }
                    
                    HStack
                    {
                        if isWrongLastSpecialization
                        {
                            Text("Оберіть попередній предмет!")
                                .foregroundColor(Color.red)
                        }
                        
                        Spacer()
                        
                        Button
                        {
                            if !editedSpecialization.contains("Спеціалізацію не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSpecialization = false
                                    
                                    editedSpecialization.append("Спеціалізацію не обрано")
                                    isWrongSpecialization.append(false)
                                }
                            }
                            else
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSpecialization = true
                                }
                            }
                        }
                        label:
                        {
                            Image(systemName: "plus")
                                .aspectRatio(contentMode: .fit)
                        }// Button for add specialization
                        .help("Додати нову спеціалізацію для вчителя")
                    }// HStack with button for add specialization
                }// section with specialization
            }// main form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)

            Spacer()
            
            if isWrongName || isWrongLastName || isWrongSurname || isWrongContactNumber || isWrongPassportNumber || isWrongResidenceAddress || isWrongSpecialization.contains(true)
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
                    if !editedName.isEmpty && !editedLastName.isEmpty && !editedSurname.isEmpty && !editedContactNumber.isEmpty && editedContactNumber.count == 13 && editedPassportNumber.count == 8 && !editedResidenceAddress.isEmpty && !editedSpecialization.contains("Спеціалізацію не обрано") && !isWrongSpecialization.contains(true) && !writeModel.isLoadingFetchData
                    {
                        Task
                        {
                            let status = await writeModel.updateTeacher(id: teacher.id, name: editedName, lastName: editedLastName, surname: editedSurname, dateBirth: dateFormatter.string(from: editedBirthDayDate), contactNumber: editedContactNumber, passportNumber: editedPassportNumber, residenceAddress: editedResidenceAddress, category: editedCategory, specialization: editedSpecialization)
                                                        
                            isUpdateListTeacher.toggle()
                            
                            statusSaveString = status ? "Збережено" : "Невдалося зберегти"
                        }
                    }
                    else
                    {
                        withAnimation(Animation.easeIn(duration: 0.35))
                        {
                            isWrongName = false
                            isWrongLastName = false
                            isWrongSurname = false
                            isWrongContactNumber = false
                            isWrongPassportNumber = false
                            isWrongResidenceAddress = false
                            isWrongLastSpecialization = false
                            isWrongSpecialization = Array(repeating: false, count: editedSpecialization.count)
                            
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
                            if editedContactNumber.isEmpty || editedContactNumber.count < 13
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
                            if editedSpecialization.contains("Спеціалізацію не обрано")
                            {
                                for index in editedSpecialization.indices
                                {
                                    if editedSpecialization[index] == "Спеціалізацію не обрано"
                                    {
                                        isWrongSpecialization[index] = true
                                    }
                                }
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

            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }// main VStack
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
                self.specializationList     = await writeModel.getSpecializationNameList()
                self.categoryList           = await writeModel.getTeacherCategory()

                editedName                  = teacher.name
                editedLastName              = teacher.lastName
                editedSurname               = teacher.surname
                editedBirthDayDate          = teacher.dateBirth
                editedContactNumber         = teacher.contactNumber
                editedPassportNumber        = teacher.passportNumber
                editedResidenceAddress      = teacher.residenceAddress
                editedCategory              = teacher.category
                editedSpecialization        = teacher.specialization
                
                isWrongSpecialization = Array(repeating: false, count: teacher.specialization.count)
            }
        }
        .onDisappear
        {
            if self.writeModel.isLoadingFetchData
            {
                withAnimation(Animation.easeIn(duration: 0.35))
                {
                    self.writeModel.isLoadingFetchData = false
                }
            }
        }
    }
}
