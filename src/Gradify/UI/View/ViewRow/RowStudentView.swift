//
//  RowStudentView.swift
//  Gradify
//
//  Created by Андрiй on 05.02.2024.
//

import SwiftUI

struct RowStudentView: View
{
    @State private var hoverOnName:             Bool = false
    @State private var hoverOnLastName:         Bool = false
    @State private var hoverOnSurname:          Bool = false
    @State private var hoverOnContactNumber:    Bool = false
    @State private var hoverOnPassportNumber:   Bool = false
    @State private var hoverOnResidenceAddress: Bool = false
    @State private var hoverOnGroup:            Bool = false
    @State private var hoverOnEducationProgram: Bool = false
    @State private var hoverOnBirthDay:         Bool = false
    
    @State private var statusCopyString:        String  = "Скопіювати"
    @State private var maxWidthForButton:       CGFloat = .zero

    @Binding var isShowView: Bool
    @Binding var isEditView: Bool
    
    var student: Student
    
    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()

                Text("[\(student.id)] \(student.lastName) \(student.name) \(student.surname)")
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
                        
                        Text("\(student.name)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnName ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnName.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: student.name)
                                }
                                label:
                                {
                                    Text("Скопіювати ім'я")
                                }
                            }
                    }// HStack with name student
                    
                    HStack
                    {
                        Text("Прізвище")
                        
                        Spacer()
                        
                        Text("\(student.lastName)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnLastName ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnLastName.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: student.lastName)
                                }
                                label:
                                {
                                    Text("Скопіювати прізвище")
                                }
                            }
                    }// Hstack with lastname student
                    
                    HStack
                    {
                        Text("По батькові")
                        
                        Spacer()
                        
                        Text("\(student.surname)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnSurname ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnSurname.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: student.surname)
                                }
                                label:
                                {
                                    Text("Скопіювати по батькові")
                                }
                            }
                    }// Hstack with surname student
                }
                
                Section(header: Text("Додаткова інформація"))
                {
                    HStack
                    {
                        Text("Дата народження")
                        
                        Spacer()

                        Text("\(dateFormatter.string(from: student.dateBirth))")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnBirthDay ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnBirthDay.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: dateFormatter.string(from: student.dateBirth))
                                }
                                label:
                                {
                                    Text("Скопіювати дату народження")
                                }
                            }
                    }// Hstack with birthday student

                    HStack
                    {
                        Text("Номер телефону")
                        
                        Spacer()
                        
                        Text("\(student.contactNumber)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnContactNumber ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnContactNumber.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: student.contactNumber)
                                }
                                label:
                                {
                                    Text("Скопіювати номер телефону")
                                }
                            }
                    }// Hstack with contact number student

                    HStack
                    {
                        Text("Номер паспорту")
                        
                        Spacer()
                        
                        Text("\(student.passportNumber)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnPassportNumber ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnPassportNumber.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: student.passportNumber)
                                }
                                label:
                                {
                                    Text("Скопіювати номер паспорту")
                                }
                            }
                    }// Hstack with number passport student

                    HStack
                    {
                        Text("Адреса проживання")
                        
                        Spacer()
                        
                        Text("\(student.residenceAddress)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnResidenceAddress ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnResidenceAddress.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: student.residenceAddress)
                                }
                                label:
                                {
                                    Text("Скопіювати адресу проживання")
                                }
                            }
                    }// Hstack with residence address student

                    HStack
                    {
                        Text("Навчальна програма")
                        
                        Spacer()
                        
                        Text("\(student.educationProgram)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnEducationProgram ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnEducationProgram.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: student.educationProgram)
                                }
                                label:
                                {
                                    Text("Скопіювати назву навчальної програми")
                                }
                            }
                    }// Hstack with education program student

                    HStack
                    {
                        Text("Група")
                        
                        Spacer()
                        
                        Text("\(student.group)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(hoverOnGroup ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            {isHovered in
                                changePointingHandCursor(shouldChangeCursor: isHovered)
                                hoverOnGroup.toggle()
                            }
                            .contextMenu()
                            {
                                Button
                                {
                                    copyInBuffer(text: student.group)
                                }
                                label:
                                {
                                    Text("Скопіювати назву групи")
                                }
                            }
                    }// Hstack with group student
                }// Section with additional info student
            }// Form with info and TextField
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
                        //.resizable()
                        //.aspectRatio(contentMode: .fit)
                        //.frame(width: 20, height: 20)
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
                    let allInfo = """
                            [\(student.id)] \(student.lastName) \(student.name) \(student.surname)
                            ===========================================
                            Ім'я: \(student.name)
                            Прізвище: \(student.lastName)
                            По батькові: \(student.surname)
                            Дата народження: \(dateFormatter.string(from: student.dateBirth))
                            Номер телефону: \(student.contactNumber)
                            Номер паспорту: \(student.passportNumber)
                            Адреса проживання: \(student.residenceAddress)
                            Навчальна програма: \(student.educationProgram)
                            Група: \(student.group)
                            ===========================================
                            """
                            
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
                .help("Скопіювати усю інформацію студента")
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
        }// Main VStack
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


/*
 #Preview
{
    RowStudentView()
}
*/

