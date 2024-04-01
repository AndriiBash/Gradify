//
//  RowFacultyView.swift
//  Gradify
//
//  Created by Андрiй on 20.03.2024.
//

import SwiftUI

struct RowFacultyView: View
{
    @State private var hoverOnName:             Bool = false
    @State private var hoverOnDean:             Bool = false
    @State private var hoverOnDescription:      Bool = false
    
    @State private var hoverOnSpecialiazation:  [Bool]
    @State private var hoverOnDepartments:      [Bool]
    
    @State private var statusCopyString:        String  = "Скопіювати"
    @State private var maxWidthForButton:       CGFloat = .zero
    
    @Binding var isShowView:                    Bool
    @Binding var isEditView:                    Bool
    
    var faculty:                                Faculty
   
    
    init(isShowView: Binding<Bool>, isEditView: Binding<Bool>, faculty: Faculty)
    {
        self._isShowView = isShowView
        self._isEditView = isEditView
        self.faculty = faculty
        
        self._hoverOnSpecialiazation = State(initialValue: Array(repeating: false, count: faculty.specialiazation.count))
        self._hoverOnDepartments = State(initialValue: Array(repeating: false, count: faculty.departments.count))
    }
    
    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("[\(faculty.id)] \(faculty.name)")
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
                        
                        Text("\(faculty.name)")
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
                                copyInBuffer(text: faculty.name)
                            }
                            label:
                            {
                                Text("Скопіювати назву")
                            }
                        }
                    }// HStack with name faculty
                    
                    HStack
                    {
                        Text("Декан")
                        
                        Spacer()
                        
                        Text("\(faculty.dean)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnDean ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnDean.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: faculty.dean)
                            }
                        label:
                            {
                                Text("Скопіювати ПІБ декана")
                            }
                        }
                    }// HStack with dean faculty
                }// main section
                
                Section(header: Text("Опис"))
                {
                    HStack
                    {
                        Text("Опис")
                        
                        Spacer()
                        
                        Text("\(faculty.description)")
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
                                copyInBuffer(text: faculty.description)
                            }
                        label:
                            {
                                Text("Скопіювати опис факультета")
                            }
                        }
                    }// HStack with description faculty
                }// Section with description faculty
                
                Section(header: Text("Кафедри"))
                {
                    if faculty.departments.isEmpty
                    {
                        HStack
                        {
                            Spacer()
                            
                            Text("Кафедри відсутні")
                            
                            Spacer()
                        }// HStack with info about none deparments in faculty
                    }
                    else
                    {
                        ForEach(faculty.departments.indices, id: \.self)
                        { index in
                            HStack
                            {
                                Text("Кафдера №\(index + 1)")
                                
                                Spacer()
                                
                                Text("\(faculty.departments[index])")
                                    .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(hoverOnDepartments.indices.contains(index) && hoverOnDepartments[index] ? Color.gray.opacity(0.2) : Color.clear)
                                    )
                                    .onHover
                                { isHovered in
                                    if isHovered
                                    {
                                        if !hoverOnDepartments.indices.contains(index)
                                        {
                                            hoverOnDepartments.append(false)
                                        }
                                    }
                                    hoverOnDepartments[index].toggle()
                                }
                                .contextMenu
                                {
                                    Button
                                    {
                                        copyInBuffer(text: faculty.departments[index])
                                    }
                                    label:
                                    {
                                        Text("Скопіювати назву кафедри")
                                    }
                                }
                            }// ForEach with departments in faculty
                        }
                    }
                }// Section with departent
                
                Section(header: Text("Спеціалізації"))
                {
                    if faculty.specialiazation.isEmpty
                    {
                        HStack
                        {
                            Spacer()
                            
                            Text("Спеціалізації відсутні")
                            
                            Spacer()
                        }// HStack with info about none specialization in faculty
                    }
                    else
                    {
                        ForEach(faculty.specialiazation.indices, id: \.self)
                        { index in
                            HStack
                            {
                                Text("Cпеціалізація №\(index + 1)")
                                
                                Spacer()
                                
                                Text("\(faculty.specialiazation[index])")
                                    .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(hoverOnSpecialiazation.indices.contains(index) && hoverOnSpecialiazation[index] ? Color.gray.opacity(0.2) : Color.clear)
                                    )
                                    .onHover
                                { isHovered in
                                    if isHovered
                                    {
                                        if !hoverOnSpecialiazation.indices.contains(index)
                                        {
                                            hoverOnSpecialiazation.append(false)
                                        }
                                    }
                                    hoverOnSpecialiazation[index].toggle()
                                }
                                .contextMenu
                                {
                                    Button
                                    {
                                        copyInBuffer(text: faculty.specialiazation[index])
                                    }
                                    label:
                                    {
                                        Text("Скопіювати назву спеціалізації")
                                    }
                                }
                            }// ForEach with departments in faculty
                        }
                    }
                }// Section with specialiaztion

            }// main Form
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
                            [\(faculty.id)] \(faculty.name)
                            ===========================================
                            Назва: \(faculty.name)
                            Декан: \(faculty.dean)
                            ===========================================
                            Опис: \(faculty.description)
                            ===========================================\n
                            """
                    
                    if !faculty.departments.isEmpty
                    {
                        for index in faculty.departments.indices
                        {
                            allInfo += "Кафедра №\(index + 1) :" + "\(faculty.departments[index])\n"
                        }
                        
                        allInfo += "===========================================\n"
                    }
                    
                    if !faculty.specialiazation.isEmpty
                    {
                        for index in faculty.specialiazation.indices
                        {
                            allInfo += "Спеціалізація №\(index + 1) :" + "\(faculty.departments[index])\n"
                        }
                        
                        allInfo += "==========================================="
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
                .help("Скопіювати усю інформацію факультета")
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
        }// Main VStack
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

