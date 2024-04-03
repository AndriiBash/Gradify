//
//  RowDepartmentView.swift
//  Gradify
//
//  Created by Андрiй on 22.03.2024.
//

import SwiftUI

struct RowDepartmentView: View
{
    @State private var hoverOnName:                 Bool = false
    @State private var hoverOnDescription:          Bool = false
    
    @State private var hoverOnSpecialiazation:      Bool = false
    @State private var hoverOnDepartmentLeader:     Bool = false
    @State private var hoverOnViceLeader:           Bool = false

    @State private var hoverOnTeacher:              [Bool] = []
    @State private var hoverOnDepartemntOffice:     Bool = false
    @State private var hoverOnCreationYear:         Bool = false
    
    @State private var statusCopyString:            String  = "Скопіювати"
    @State private var maxWidthForButton:           CGFloat = .zero
    
    @Binding var isShowView:                        Bool
    @Binding var isEditView:                        Bool
    
    var department:                                 Department
    
    init(isShowView: Binding<Bool>, isEditView: Binding<Bool>, department: Department)
    {
        self._isShowView = isShowView
        self._isEditView = isEditView
        self.department = department
        
        self._hoverOnTeacher = State(initialValue: Array(repeating: false, count: department.teacherList.count))
    }

    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("[\(department.id)] \(department.name)")
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
                        Text("Назва")
                        
                        Spacer()
                        
                        Text("\(department.name)")
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
                                copyInBuffer(text: department.name)
                            }
                            label:
                            {
                                Text("Скопіювати назву")
                            }
                        }
                    }// HStack with name department
                    
                    HStack
                    {
                        Text("Спеціалізація")
                        
                        Spacer()
                        
                        Text("\(department.specialization)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnSpecialiazation ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnSpecialiazation.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: department.specialization)
                            }
                            label:
                            {
                                Text("Скопіювати спеціалізацію")
                            }
                        }
                    }// HStack with specialization department
                    
                    HStack
                    {
                        Text("Завідувач кафедри")
                        
                        Spacer()
                        
                        Text("\(department.departmentLeader)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnDepartmentLeader ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnDepartmentLeader.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: department.departmentLeader)
                            }
                            label:
                            {
                                Text("Скопіювати ПІБ завідувача кафедри")
                            }
                        }
                    }// HStack with departmentLeader department
                    
                    HStack
                    {
                        Text("Зам.завідувача кафедри")
                        
                        Spacer()
                        
                        Text("\(department.viceLeader)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnViceLeader ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnViceLeader.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: department.viceLeader)
                            }
                            label:
                            {
                                Text("Скопіювати ПІБ зам.завідувача кафедри")
                            }
                        }
                    }// HStack with viceLeader department
                    
                    HStack
                    {
                        Text("Аудиторія кафедри")
                        
                        Spacer()
                        
                        Text("\(department.departmentOffice)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnDepartemntOffice ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnDepartemntOffice.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: department.departmentOffice)
                            }
                            label:
                            {
                                Text("Скопіювати назву аудиторію кафедри")
                            }
                        }
                    }// HStack with departmentOffice department
                    
                    HStack
                    {
                        Text("Рік заснування")
                        
                        Spacer()
                        
                        Text("\(department.creationYear) рік")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnCreationYear ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnCreationYear.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: String(department.creationYear) + " рік")
                            }
                            label:
                            {
                                Text("Скопіювати рік засунвання кафедри")
                            }
                        }
                    }// HStack with creationYear department
                }// main section
                
                Section(header: Text("Опис"))
                {
                    HStack
                    {
                        Text("Опис кафери")
                        
                        Spacer()
                        
                        Text("\(department.description) рік")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnDescription ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnDescription.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: department.description)
                            }
                        label:
                            {
                                Text("Скопіювати опис кафедри")
                            }
                        }
                    }// HStack with description department
                }// Section with detail about department
                
                Section(header: Text("Список викладачів кафедри"))
                {
                    if department.teacherList.isEmpty
                    {
                        HStack
                        {
                            Spacer()
                            
                            Text("Викладачі відсутні")
                            
                            Spacer()
                        }// HStack with info about none teacher in department
                    }
                    else
                    {
                        ForEach(department.teacherList.indices, id: \.self)
                        { index in
                            HStack
                            {
                                Text("Викладач №\(index + 1)")
                                
                                Spacer()
                                
                                Text("\(department.teacherList[index])")
                                    .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(hoverOnTeacher.indices.contains(index) && hoverOnTeacher[index] ? Color.gray.opacity(0.2) : Color.clear)
                                    )
                                    .onHover
                                { isHovered in
                                    if isHovered
                                    {
                                        if !hoverOnTeacher.indices.contains(index)
                                        {
                                            hoverOnTeacher.append(false)
                                        }
                                    }
                                    hoverOnTeacher[index].toggle()
                                }
                                .contextMenu
                                {
                                    Button
                                    {
                                        copyInBuffer(text: department.teacherList[index])
                                    }
                                    label:
                                    {
                                        Text("Скопіювати ПІБ викладача")
                                    }
                                }
                            }// ForEach with teacher in departments
                        }
                    }
                }// Section with teacher list
            }// main form
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
                            [\(department.id)] \(department.name)
                            ===========================================
                            Назва: \(department.name)
                            Спеціалізація: \(department.specialization)
                            Завідувач кафедри: \(department.departmentLeader)
                            Зам завідувач кафедри: \(department.viceLeader)
                            Аудиторія кафедри: \(department.departmentOffice)
                            Рік створення: \(department.creationYear)
                            ===========================================
                            Опис: \(department.description)
                            ===========================================\n
                            """
                    
                    if !department.teacherList.isEmpty
                    {
                        for index in department.teacherList.indices
                        {
                            allInfo += "Викладач №\(index + 1) :" + "\(department.teacherList[index])\n"
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
                .help("Скопіювати усю інформацію кафедри")
                .padding(.horizontal, 12)
                
                Button
                {
                    isShowView = false
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
    }// body
}
