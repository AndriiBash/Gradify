//
//  AddGradeView.swift
//  Gradify
//
//  Created by Андрiй on 14.03.2024.
//

import SwiftUI

struct AddGradeView: View
{
    @State private var subject:                     String = "Предмет не обрано"
    @State private var recipientGroup:              String = "Групу не обрано"
    @State private var recipient:                   String = "Отримувача не обрано"
    @State private var grader:                      String = "Викладача не обрано"
    @State private var score:                       String = "1"
    @State private var dateGiven:                   Date = Date()
    @State private var gradeType:                   String = "Тип не обрано"
    @State private var retakePossible:              String = "Можливо"
    @State private var comment:                     String = ""
    
    @State private var isWrongGrader:               Bool = false
    @State private var isWrongRecipientGroup:       Bool = false
    @State private var isWrongRecipient:            Bool = false
    @State private var isWrongSubject:              Bool = false
    @State private var isWrongGradeType:            Bool = false
    
    @State private var teacherList:                 [String] = []
    @State private var groupList:                   [String] = []
    @State private var studentList:                 [String] = []
    @State private var subjectList:                 [String] = []
    @State private var gradeTypeList:               [String] = []

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
                
                Text("Додавання оцінки")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                
                Spacer()
            }// HStack title
            .padding(.top, 8)
            
            Form
            {
                Section(header: Text("Головне"))
                {
                    Picker("Предмет", selection: $subject)
                    {
                        Text("Предмет не обрано")
                                .tag("Предмет не обрано")

                        Divider()

                        ForEach(subjectList, id: \.self)
                        { subject in
                            Text(subject)
                                .tag(subject)
                        }
                    }// Picker for select subject grade
                    .foregroundColor(isWrongSubject ? Color.red : Color("MainTextForBlur"))

                    Picker("Група отримувача", selection: $recipientGroup)
                    {
                        Text("Групу не обрано")
                                .tag("Групу не обрано")
                       
                        Divider()

                        ForEach(groupList, id: \.self)
                        { group in
                            Text(group)
                                .tag(group)
                        }
                    }// Picker for select group recipient
                    .foregroundColor(isWrongRecipientGroup ? Color.red : Color("MainTextForBlur"))
                    .onChange(of: recipientGroup)
                    { _, newValue in
                        if newValue != "Групу не обрано"
                        {
                            Task
                            {
                                studentList = await writeModel.getStudentList(groupName: newValue)
                                recipient = "Отримувача не обрано"
                            }
                        }
                        else
                        {
                            studentList = []
                        }
                    }
                    
                    Picker("Отримувач", selection: $recipient)
                    {
                        Text("Отримувача не обрано")
                                .tag("Отримувача не обрано")

                        Divider()

                        ForEach(studentList, id: \.self)
                        { student in
                            Text(student)
                                .tag(student)
                        }
                    }// Picker for select grade recipient
                    .foregroundColor(isWrongRecipient ? Color.red : Color("MainTextForBlur"))

                    Picker("Хто виставив", selection: $grader)
                    {
                        Text("Викладача не обрано")
                                .tag("Викладача не обрано")

                        Divider()
                        
                        ForEach(teacherList, id: \.self)
                        { teacher in
                            Text(teacher)
                                .tag(teacher)
                        }
                    }// Picker for select grader grade
                    .foregroundColor(isWrongGrader ? Color.red : Color("MainTextForBlur"))

                    Picker("Оцінка", selection: $score)
                    {
                        Text("1")
                                .tag("1")

                        Text("2")
                                .tag("2")
                        
                        Text("3")
                                .tag("3")
                        
                        Text("4")
                                .tag("4")
                        
                        Text("5")
                                .tag("5")
                    }// Picker for select score grade
                    .foregroundColor(isWrongRecipient ? Color.red : Color("MainTextForBlur"))
                }// main section
                
                Section(header: Text("Детальніше про оцінку"))
                {
                    DatePicker("Дата виставлення", selection: $dateGiven, in: ...Date(), displayedComponents: .date)

                    Picker("Тип оцінки", selection: $gradeType)
                    {
                        Text("Тип не обрано")
                                .tag("Тип не обрано")

                        Divider()
                        
                        ForEach(gradeTypeList, id: \.self)
                        { type in
                            Text(type)
                                .tag(type)
                        }
                    }// Picker for select grade type
                    .foregroundColor(isWrongGradeType ? Color.red : Color("MainTextForBlur"))

                    Picker("Можливість перескладання", selection: $retakePossible)
                    {
                        Text("Можливо")
                                .tag("Можливо")

                        Text("Не можливо")
                                .tag("Не можливо")

                    }// Picker for select retakePossible grade
                }// Section for detail about grade
                
                Section(header: Text("Додатково"))
                {
                    TextField("Коментар", text: $comment)
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if comment.isEmpty
                                {
                                    Text("Коментар про оцінку")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for comment grade
                }// Section for comment about grade
            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)

            if isWrongGrader || isWrongRecipientGroup || isWrongRecipient || isWrongSubject || isWrongGradeType
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
                    withAnimation(Animation.easeIn(duration: 0.35))
                    {
                        isWrongGrader = false
                        isWrongRecipientGroup = false
                        isWrongRecipient = false
                        isWrongSubject = false
                        isWrongGradeType = false
                    }
                             
                    if grader != "Викладача не обрано" && recipientGroup != "Групу не обрано" && recipient != "Отримувача не обрано" && subject != "Предмет не обрано" && gradeType != "Тип не обрано"
                    {
                        Task
                        {
                            isShowForm = false
                            
                            statusSave = await writeModel.addNewGrade(subject: subject, recipient: recipient, recipientGroup: recipientGroup, grader: grader, score: Int(score) ?? 1, dateGiven: dateFormatter.string(from: dateGiven), gradeType: gradeType, retakePossible: retakePossible.contains("Можливо") ? true : false, comment: comment)
                        }
                        
                        statusSave = false
                    }
                    else
                    {
                        withAnimation(Animation.easeIn(duration: 0.35))
                        {
                            if grader == "Викладача не обрано"
                            {
                                isWrongGrader = true
                            }
                            if recipientGroup == "Групу не обрано"
                            {
                               isWrongRecipientGroup = true
                            }
                            if recipient == "Отримувача не обрано"
                            {
                                isWrongRecipient = true
                            }
                            if subject == "Предмет не обрано"
                            {
                                isWrongSubject = true
                            }
                            if gradeType == "Тип не обрано"
                            {
                                isWrongGradeType = true
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
                .padding(.leading, 6)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
            .padding(.horizontal, 22)
        }// main VStack
        .frame(width: 400, height: 565)
        .onAppear
        {
            Task
            {
                self.teacherList    = await writeModel.getTeacherList(withOut: "")
                self.groupList      = await writeModel.getGroupNameList(withOut: "")
                self.studentList    = await writeModel.getStudentList(groupName: "")
                self.subjectList    = await writeModel.getSubjectNameList(withOut: "")
                self.gradeTypeList  = await writeModel.getGradeTypeList()
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
