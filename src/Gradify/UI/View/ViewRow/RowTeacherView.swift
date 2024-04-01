//
//  RowTeacherView.swift
//  Gradify
//
//  Created by Андрiй on 01.04.2024.
//

import SwiftUI

struct RowTeacherView: View
{
    @State private var hoverOnName:             Bool = false
    @State private var hoverOnLastName:         Bool = false
    @State private var hoverOnSurname:          Bool = false
    @State private var hoverOnContactNumber:    Bool = false
    @State private var hoverOnPassportNumber:   Bool = false
    @State private var hoverOnResidenceAddress: Bool = false
    @State private var hoverOnCategory:         Bool = false
    @State private var hoverOnBirthDay:         Bool = false
    
    @State private var hoverOnSpecialization:   [Bool] = []

    @State private var statusCopyString:        String  = "Скопіювати"
    @State private var maxWidthForButton:       CGFloat = .zero

    @Binding var isShowView:                    Bool
    @Binding var isEditView:                    Bool
    
    var teacher:                                Teacher

    init(isShowView: Binding<Bool>, isEditView: Binding<Bool>, teacher: Teacher)
    {
        self._isShowView = isShowView
        self._isEditView = isEditView
        self.teacher = teacher
        
        self._hoverOnSpecialization = State(initialValue: Array(repeating: false, count: teacher.specialization.count))
    }
    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("[\(teacher.id)] \(teacher.lastName) \(teacher.name) \(teacher.surname)")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                
                Spacer()
            }// HStack navigation panel
            .padding(.top, 8)
            
            Form
            {
                Section(header: Text("Головне"))
                {
                    HStack
                    {
                        Text("Ім'я")
                        
                        Spacer()
                        
                        Text("\(teacher.name)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnName ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnName.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: teacher.name)
                            }
                            label:
                            {
                                Text("Скопіювати ім'я")
                            }
                        }
                    }// HStack with name teacher
                    
                    HStack
                    {
                        Text("Прізвище")
                        
                        Spacer()
                        
                        Text("\(teacher.lastName)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnLastName ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnLastName.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: teacher.lastName)
                            }
                            label:
                            {
                                Text("Скопіювати прізвище")
                            }
                        }
                    }// Hstack with lastname teacher
                    
                    HStack
                    {
                        Text("По батькові")
                        
                        Spacer()
                        
                        Text("\(teacher.surname)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnSurname ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnSurname.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: teacher.surname)
                                }
                                label:
                                {
                                    Text("Скопіювати по батькові")
                                }
                            }
                    }// Hstack with surname teacher
                }// main Section
                
                Section(header: Text("Додаткова інформація"))
                {
                    HStack
                    {
                        Text("Дата народження")
                        
                        Spacer()
                        
                        Text("\(dateFormatter.string(from: teacher.dateBirth))")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnBirthDay ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnBirthDay.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: dateFormatter.string(from: teacher.dateBirth))
                            }
                            label:
                            {
                                Text("Скопіювати дату народження")
                            }
                        }
                    }// Hstack with birthday teacher
                    
                    HStack
                    {
                        Text("Номер телефону")
                        
                        Spacer()
                        
                        Text("\(teacher.contactNumber)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnContactNumber ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnContactNumber.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: teacher.contactNumber)
                            }
                        label:
                            {
                                Text("Скопіювати номер телефону")
                            }
                        }
                    }// Hstack with contact number teacher
                    
                    HStack
                    {
                        Text("Номер паспорту")
                        
                        Spacer()
                        
                        Text("\(teacher.passportNumber)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnPassportNumber ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnPassportNumber.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: teacher.passportNumber)
                                }
                                label:
                                {
                                    Text("Скопіювати номер паспорту")
                                }
                            }
                    }// Hstack with number passport teacher
                    
                    HStack
                    {
                        Text("Адреса проживання")
                        
                        Spacer()
                        
                        Text("\(teacher.residenceAddress)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnResidenceAddress ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnResidenceAddress.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: teacher.residenceAddress)
                            }
                            label:
                            {
                                Text("Скопіювати адресу проживання")
                            }
                        }
                    }// Hstack with residence address teacher
                    
                    HStack
                    {
                        Text("Категорія")
                        
                        Spacer()
                        
                        Text("\(teacher.category)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnCategory ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnCategory.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: teacher.category)
                            }
                            label:
                            {
                                Text("Скопіювати категорію")
                            }
                        }
                    }// Hstack with residence category teacher
                }// Detail section
                
                Section(header: Text("Спеціалізація"))
                {
                    if teacher.specialization.isEmpty
                    {
                        HStack
                        {
                            Spacer()
                            
                            Text("Спеціалізації відсутні")
                            
                            Spacer()
                        }// HStack with info about nil specialization teacher
                    }
                    else
                    {
                        ForEach(teacher.specialization.indices, id: \.self)
                        { index in
                            HStack
                            {
                                Text("Спеціалізація №\(index + 1)")
                                
                                Spacer()
                                
                                Text("\(teacher.specialization[index])")
                                    .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(hoverOnSpecialization.indices.contains(index) && hoverOnSpecialization[index] ? Color.gray.opacity(0.2) : Color.clear)
                                    )
                                    .onHover
                                    { isHovered in
                                        if isHovered
                                        {
                                            if !hoverOnSpecialization.indices.contains(index)
                                            {
                                                hoverOnSpecialization.append(false)
                                            }
                                        }
                                        hoverOnSpecialization[index].toggle()
                                    }
                                    .contextMenu
                                    {
                                        Button
                                        {
                                            copyInBuffer(text: teacher.specialization[index])
                                        }
                                        label:
                                        {
                                            Text("Скопіювати назву спеціалізації")
                                        }
                                    }
                            }// ForEach with teacher specialization
                        }
                    }
                }// Section with specialization
            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)

            Spacer()
            Divider()
            
            HStack
            {
                Button
                {
                    isShowView = false
                    isEditView = true
                }
                label:
                {
                    Image(systemName: "square.and.pencil")
                }// button for edit row
                .padding(.trailing, 12)
                .help("Редагувати запис")
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }

                Spacer()
                                
                Button
                {
                    var allInfo = """
                            [\(teacher.id)] \(teacher.lastName) \(teacher.name) \(teacher.surname)
                            ===========================================
                            Ім'я: \(teacher.name)
                            Прізвище: \(teacher.lastName)
                            По батькові: \(teacher.surname)
                            Дата народження: \(dateFormatter.string(from: teacher.dateBirth))
                            Номер телефону: \(teacher.contactNumber)
                            Номер паспорту: \(teacher.passportNumber)
                            Адреса проживання: \(teacher.residenceAddress)
                            Категорія: \(teacher.category)
                            ===========================================\n
                            """
                    
                    if !teacher.specialization.isEmpty
                    {
                        for index in teacher.specialization.indices
                        {
                            allInfo += "Спеціалізація №\(index + 1) :" + "\(teacher.specialization[index])\n"
                        }
                        
                        allInfo += "===========================================\n"
                    }

                                        
                    copyInBuffer(text: allInfo)
                    statusCopyString = "Скопійовано!"
                }
                label:
                {
                    Text("\(statusCopyString)")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .help("Скопіювати усю інформацію викладача")
                .padding(.horizontal, 12)
                
                Button
                {
                    isShowView = false
                }
                label:
                {
                    Text("Готово")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .keyboardShortcut(.defaultAction)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
            .padding(.horizontal, 22)
            
        }// main VStack
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 400, height: 565)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
        }
    }
}
