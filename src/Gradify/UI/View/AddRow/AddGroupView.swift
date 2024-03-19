//
//  AddGroupView.swift
//  Gradify
//
//  Created by Андрiй on 12.03.2024.
//

import SwiftUI

struct AddGroupView: View
{
    @State private var name:                        String = ""
    @State private var curator:                     String = "Без куратора"
    @State private var leaderGroup:                 String = "Без старости"
    @State private var department:                  String = "Без кафедри"
    @State private var educationProgram:            String = "Без навчальної програми"
    
    @State private var isWrongName:                 Bool = false
    @State private var isWrongIdName:               Bool = false

    @State private var curatorList:                 [String] = []
    @State private var studentList:                 [String] = []
    @State private var departmentList:              [String] = []
    @State private var educationProgramList:        [String] = []

    @Binding var isShowForm:                        Bool
    @Binding var statusSave:                        Bool
    @ObservedObject var writeModel:                 ReadWriteModel

    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("Додавання групи")
                    .padding(.top, 10)
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
                                    Text("ДЖиМ-12")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for edited name group
                    
                    Picker("Куратор", selection: $curator)
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
                    
                    Picker("Староста", selection: $leaderGroup)
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
                    
                    Picker("Кафедра", selection: $department)
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

                    Picker("Навчальна програма", selection: $educationProgram)
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
                }// Section main
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
                        isWrongIdName = false
                    }
                    
                    if !name.isEmpty && !writeModel.isLoadingFetchData
                    {
                        Task
                        {
                            let listGroupKeyName = await writeModel.getGroupNameList(withOut: "")
                                                    
                            if listGroupKeyName.contains(name)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                                
                                print("error!")
                            }
                            else
                            {
                                print("true!")

                                isShowForm = false
                                
                                statusSave = await writeModel.addNewGroup(name: name, curator: curator, leaderGroup: leaderGroup, department: department, educationProgram: educationProgram)
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
                .padding(.leading, 12)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
            .padding(.horizontal, 22)
        }// main VStack
        .frame(width: 400, height: 370)
        .onAppear
        {
            Task
            {
                self.curatorList            = await writeModel.getTeacherList()
                self.studentList            = await writeModel.getStudentList(groupName: "Без групи")
                self.departmentList         = await writeModel.getDeprmentList()
                self.educationProgramList   = await writeModel.getEducatProgramNameList(withOut: "")
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
