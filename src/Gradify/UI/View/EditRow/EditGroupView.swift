//
//  EditGroupView.swift
//  Gradify
//
//  Created by Андрiй on 12.03.2024.
//

import SwiftUI

struct EditGroupView: View
{
    @State private var editedName:                      String = ""
    @State private var editedCurator:                   String = "Без куратора"
    @State private var editedLeaderGroup:               String = "Без старости"
    @State private var editedDepartment:                String = "Без кафедри"
    @State private var editedEducationProgram:          String = "Без навчальної програми"
    
    @State private var isWrongName:                     Bool = false
    @State private var isWrongIdName:                   Bool = false

    @State private var statusSaveString:                String = "Зберегти"
    @State private var curatorList:                     [String] = []
    @State private var studentList:                     [String] = []
    @State private var departmentList:                  [String] = []
    @State private var educationProgramList:            [String] = []

    @State private var maxWidthForButton:             CGFloat = .zero

    @Binding var isShowView:                          Bool
    @Binding var isEditView:                          Bool
    @Binding var isUpdateListGroup:                   Bool
    @Binding var group:                               Group
    
    @ObservedObject var writeModel:                   ReadWriteModel

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
                                    Text("ДЖиМ-12")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for edited name group
                    
                    Picker("Куратор", selection: $editedCurator)
                    {
                        Text("Без куратора")
                                .tag("Без куратора")

                        Divider()
                        
                        ForEach(curatorList, id: \.self)
                        { curatorName in
                            Text(curatorName)
                                .tag(curatorName)
                        }
                    }// Picker for select curator
                    
                    Picker("Староста", selection: $editedLeaderGroup)
                    {
                        Text("Без старости")
                                .tag("Без старости")

                        Divider()
                        
                        ForEach(studentList, id: \.self)
                        { studentName in
                            Text(studentName)
                                .tag(studentName)
                        }
                    }// Picker for select leader group
                    
                    Picker("Кафедра", selection: $editedDepartment)
                    {
                        Text("Без кафедри")
                                .tag("Без кафедри")

                        Divider()
                        
                        ForEach(departmentList, id: \.self)
                        { departmentName in
                            Text(departmentName)
                                .tag(departmentName)
                        }
                    }// Picker for select department group

                    Picker("Навчальна програма", selection: $editedEducationProgram)
                    {
                        Text("Без навчальної програми")
                                .tag("Без навчальної програми")

                        Divider()
                        
                        ForEach(educationProgramList, id: \.self)
                        { educationName in
                            Text(educationName)
                                .tag(educationName)
                        }
                    }// Picker for select department group
                }// Section with main info
            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            Spacer()
            
            if isWrongName
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
                        isWrongIdName = false
                    }
                    
                    if !editedName.isEmpty && !writeModel.isLoadingFetchData
                    {
                        
                        
                        Task
                        {
                            let listGroupKeyName = await writeModel.getGroupNameList(withOut: group.name)

                            if listGroupKeyName.contains(editedName)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                let status = await writeModel.updateGroup(id: group.id, name: editedName, curator: editedCurator, leaderGroup: editedLeaderGroup, department: editedDepartment, educationProgram: editedEducationProgram)

                                isUpdateListGroup.toggle()
                                
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
        .frame(width: 400, height: 370)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
            
            Task
            {
                self.curatorList            = await writeModel.getTeacherList(withOut: "")
                self.studentList            = await writeModel.getStudentList(groupName: self.group.name)
                self.departmentList         = await writeModel.getDeprmentNameList(withOut: "")
                self.educationProgramList   = await writeModel.getEducatProgramNameList(withOut: "")
            
                self.editedName = group.name
                self.editedCurator = group.curator
                self.editedLeaderGroup = group.groupLeader
                self.editedDepartment = group.departmentName
                self.editedEducationProgram = group.educationProgram
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
