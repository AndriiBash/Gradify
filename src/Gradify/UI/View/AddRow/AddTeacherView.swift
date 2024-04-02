//
//  AddTeacherView.swift
//  Gradify
//
//  Created by Андрiй on 02.04.2024.
//

import SwiftUI

struct AddTeacherView: View
{
    @State private var name:                        String = ""
    @State private var lastName:                    String = ""
    @State private var surname:                     String = ""
    @State private var selectedDate:                Date = Date()
    @State private var contactNumber:               String = ""
    @State private var passportNumber:              String = ""
    @State private var residenceAddress:            String = ""
    @State private var category:                    String = "Без категорії"

    @State private var specialization:              [String] = []
        
    @State private var isWrongName:                 Bool = false
    @State private var isWrongLastName:             Bool = false
    @State private var isWrongSurname:              Bool = false
    @State private var isWrongContactNumber:        Bool = false
    @State private var isWrongPassportNumber:       Bool = false
    @State private var isWrongResidenceAddress:     Bool = false
    @State private var isWrongLastSpecialization:   Bool = false

    @State private var isWrongSpecialization:       [Bool] = []
    
    @State private var specializationList:          [String] = []
    @State private var categoryList:                [String] = []

    @Binding var isShowForm:                        Bool
    @Binding var statusSave:                        Bool
    @ObservedObject var writeModel:                 ReadWriteModel

    var body: some View
    {
        VStack
        {
            Text("Додавання викладача")
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
                }// main section
                
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
                    
                    Picker("Категорія", selection: $category)
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
                    ForEach(specialization.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Спеціалізація №\(index + 1)", selection: $specialization[index])
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
                                    specialization.remove(at: index)
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
                            if !specialization.contains("Спеціалізацію не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSpecialization = false
                                    
                                    specialization.append("Спеціалізацію не обрано")
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
                    if !name.isEmpty && !lastName.isEmpty && !surname.isEmpty && !contactNumber.isEmpty && contactNumber.count == 13 && passportNumber.count == 8 && !residenceAddress.isEmpty && !specialization.contains("Спеціалізацію не обрано") && !isWrongSpecialization.contains(true) && !writeModel.isLoadingFetchData
                    {
                        isShowForm = false

                        Task
                        {
                            statusSave = await writeModel.addNewTeacher(name: name, lastName: lastName, surname: surname, dateBirth: dateFormatter.string(from: selectedDate), contactNumber: contactNumber, passportNumber: passportNumber, residenceAddress: residenceAddress, category: category, specialization: specialization)
                        }
                        
                        statusSave = false
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
                            isWrongSpecialization = Array(repeating: false, count: specialization.count)

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
                            if contactNumber.isEmpty || contactNumber.count < 13
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
                            if specialization.contains("Спеціалізацію не обрано")
                            {
                                for index in specialization.indices
                                {
                                    if specialization[index] == "Спеціалізацію не обрано"
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
        }// main VStack
        .frame(width: 400, height: 565)
        .onAppear
        {
            Task
            {
                self.specializationList     = await writeModel.getSpecializationNameList()
                self.categoryList           = await writeModel.getTeacherCategory()
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
