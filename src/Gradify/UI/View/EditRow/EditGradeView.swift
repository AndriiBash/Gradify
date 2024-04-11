//
//  EditGradeView.swift
//  Gradify
//
//  Created by Андрiй on 14.03.2024.
//

import SwiftUI

struct EditGradeView: View
{
    @State private var editedSubject:                   String = "Предмет не обрано"
    @State private var editedRecipientGroup:            String = "Групу не обрано"
    @State private var editedRecipient:                 String = "Отримувача не обрано"
    @State private var editedGrader:                    String = "Викладача не обрано"
    @State private var editedScore:                     String = "1"
    @State private var editedDateGiven:                 Date = Date()
    @State private var editedGradeType:                 String = "Тип не обрано"
    @State private var editedRetakePossible:            String = "Можливо"
    @State private var editedComment:                   String = ""
    
    @State private var isWrongGrader:                   Bool = false
    @State private var isWrongRecipientGroup:           Bool = false
    @State private var isWrongRecipient:                Bool = false
    @State private var isWrongSubject:                  Bool = false
    @State private var isWrongGradeType:                Bool = false
    
    @State private var teacherList:                     [String] = []
    @State private var groupList:                       [String] = []
    @State private var studentList:                     [String] = []
    @State private var subjectList:                     [String] = []
    @State private var gradeTypeList:                   [String] = []

    @State private var initData:                        Bool = true
    
    @State private var statusSaveString:                String = "Зберегти"

    @State private var maxWidthForButton:               CGFloat = .zero

    @Binding var isShowView:                            Bool
    @Binding var isEditView:                            Bool
    @Binding var isUpdateListGrade:                     Bool
    @Binding var grade:                                 Grade
    
    @ObservedObject var writeModel:                     ReadWriteModel

    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("Редагування [\(editedSubject) - \(editedGrader) \(dateFormatter.string(from: editedDateGiven))]")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                
                Spacer()
            }// HStack title

            Form
            {
                Section(header: Text("Головне"))
                {
                    Picker("Предмет", selection: $editedSubject)
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

                    Picker("Група отримувача", selection: $editedRecipientGroup)
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
                    .onChange(of: editedRecipientGroup)
                    { _, newValue in
                        if !initData
                        {
                            if newValue != "Групу не обрано"
                            {
                                Task
                                {
                                    studentList = await writeModel.getStudentList(groupName: newValue)
                                    editedRecipient = "Отримувача не обрано"
                                }
                            }
                            else
                            {
                                studentList = []
                            }
                        }
                    }
                    
                    Picker("Отримувач", selection: $editedRecipient)
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

                    Picker("Хто виставив", selection: $editedGrader)
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

                    Picker("Оцінка", selection: $editedScore)
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
                    DatePicker("Дата виставлення", selection: $editedDateGiven, in: ...Date(), displayedComponents: .date)

                    Picker("Тип оцінки", selection: $editedGradeType)
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

                    Picker("Можливість перескладання", selection: $editedRetakePossible)
                    {
                        Text("Можливо")
                                .tag("Можливо")

                        Text("Не можливо")
                                .tag("Не можливо")

                    }// Picker for select retakePossible grade
                }// Section for detail about grade
                
                Section(header: Text("Додатково"))
                {
                    TextField("Коментар", text: $editedComment)
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedComment.isEmpty
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
                        isWrongGrader = false
                        isWrongRecipientGroup = false
                        isWrongRecipient = false
                        isWrongSubject = false
                        isWrongGradeType = false
                    }
                    
                    if editedGrader != "Викладача не обрано" && editedRecipientGroup != "Групу не обрано" && editedRecipient != "Отримувача не обрано" && editedSubject != "Предмет не обрано" && editedGradeType != "Тип не обрано"
                    {
                        Task
                        {
                            let status = await writeModel.updateGrade(id: grade.id, subject: editedSubject, recipient: editedRecipient, recipientGroup: editedRecipientGroup, grader: editedGrader, score: Int(editedScore) ?? 1, dateGiven: dateFormatter.string(from: editedDateGiven), gradeType: editedGradeType, retakePossible: editedRetakePossible.contains("Можливо") ? true : false, comment: editedComment)
                            
                            isUpdateListGrade.toggle()
                            
                            statusSaveString = status ? "Збережено" : "Невдалося зберегти"
                        }
                    }
                    else
                    {
                        withAnimation(Animation.easeIn(duration: 0.35))
                        {
                            if editedGrader == "Викладача не обрано"
                            {
                                isWrongGrader = true
                            }
                            if editedRecipientGroup == "Групу не обрано"
                            {
                               isWrongRecipientGroup = true
                            }
                            if editedRecipient == "Отримувача не обрано"
                            {
                                isWrongRecipient = true
                            }
                            if editedSubject == "Предмет не обрано"
                            {
                                isWrongSubject = true
                            }
                            if editedGradeType == "Тип не обрано"
                            {
                                isWrongGradeType = true
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
                .help("Зберегти редаговану інформацію про оцінку")
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
                self.editedSubject = grade.subject
                self.editedRecipientGroup = grade.recipientGroup
                self.editedRecipient = grade.recipient

                self.editedGrader = grade.grader
                self.editedScore = String(grade.score)
                self.editedDateGiven = grade.dateGiven
                self.editedGradeType = grade.gradeType
                self.editedRetakePossible = grade.retakePossible ? "Можливо" : "Не можливо"
                self.editedComment = grade.comment
                
                self.teacherList    = await writeModel.getTeacherList(withOut: "")
                self.groupList      = await writeModel.getGroupNameList(withOut: "")
                self.studentList    = await writeModel.getStudentList(groupName: grade.recipientGroup)
                self.subjectList    = await writeModel.getSubjectNameList(withOut: "")
                self.gradeTypeList  = await writeModel.getGradeTypeList()
                
                self.initData = false
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
