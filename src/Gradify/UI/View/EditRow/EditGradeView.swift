//
//  EditGradeView.swift
//  Gradify
//
//  Created by Андрiй on 14.03.2024.
//

import SwiftUI

struct EditGradeView: View
{
    @State private var editedSubject:                   String = "Без предмету"
    @State private var editedRecipient:                 String = ""
    @State private var editedGrader:                    String = ""
    @State private var editedScore:                     Int = 1
    @State private var editedDate:                      Date = Date()
    @State private var editedTypeGrade:                 String = ""
    @State private var editedRetakePossible:            String = "Неможливо"
    @State private var editedComment:                   String = ""

    @State private var changeTypeSubject:               String = "Без типу навчального предмета"
    @State private var changeGroupStudent:              String = "Без групиs"
    @State private var changeCategoryTeacher:           String = ""
    
    @State private var isWrongSubject:                  Bool = false
    @State private var isWrongRecipient:                Bool = false
    @State private var isWrongGrader:                   Bool = false

    @State private var statusSaveString:                String = "Зберегти"
    @State private var subjectList:                     [String] = []
    @State private var subjectType:                     [String] = []
    @State private var studentList:                     [String] = []
    @State private var groupList:                       [String] = []
    @State private var categoryTeacherList:             [String] = []
    @State private var teacherList:                     [String] = []
    
    @State private var maxWidthForButton:               CGFloat = .zero

    @Binding var isShowView:                            Bool
    @Binding var isEditView:                            Bool
    @Binding var isUpdateListGroup:                     Bool
    @Binding var grade:                                 Grade
    
    @ObservedObject var writeModel:                     ReadWriteModel

    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                // Spacer()
                
                Text("Редагування \(grade.grader) : \(grade.score) (\(dateFormatter.string(from: grade.dateGiven)))")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
            }// HStack title
            
            
            
            
            
            Spacer()
            
            Form
            {
                Section(header: Text("Головне"))
                {
                    Picker("Тип предмету", selection: $changeTypeSubject)
                    {
                        Text("Без типу навчального предмета")
                                .tag("Без типу навчального предмета")

                        Divider()
                        
                        ForEach(subjectType, id: \.self)
                        { typeName in
                            Text(typeName)
                                .tag(typeName)
                        }
                    }// Picker for select type subject
                    .onChange(of: changeTypeSubject)
                    { newValue, oldValue in
                        editedSubject = "Без предмету"
                        
                        if changeTypeSubject != "Без типу навчального предмета"
                        {
                            subjectList = ["ds","dsd"]
                        }
                        else
                        {
                            subjectList = []
                        }
                        
                    }

                    Picker("Предмет", selection: $editedSubject)
                    {
                        Text("Без предмету")
                                .tag("Без предмету")

                        Divider()
                        
                        ForEach(subjectList, id: \.self)
                        { subjectName in
                            Text(subjectName)
                                .tag(subjectName)
                        }
                    }// Picker for select  subject
                    
                    
                    
                    
                    
                    
                    
                    Picker("Група студента", selection: $changeGroupStudent)
                    {
                        Text("Без групи")
                                .tag("Без групи")

                        Divider()
                        
                        ForEach(groupList, id: \.self)
                        { groupName in
                            Text(groupName)
                                .tag(groupName)
                        }
                    }// Picker for select student group
                    .onChange(of: changeGroupStudent)
                    { newValue, oldValue in
                        editedRecipient = "Немає студента"
                        
                        if changeGroupStudent != "Без групи"
                        {
                            Task
                            {
                                studentList = await writeModel.getStudentList(groupName: changeGroupStudent)
                            }
                        }
                        else
                        {
                            groupList = []
                        }
                        
                    }

                    Picker("Студент", selection: $editedRecipient)
                    {
                        Text("Немає студента")
                                .tag("Немає студента")

                        Divider()
                        
                        ForEach(studentList, id: \.self)
                        { studentName in
                            Text(studentName)
                                .tag(studentName)
                        }
                    }// Picker for select recipent (student)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }// Main Section
            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            
            
            
            
            
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
                self.groupList              = await writeModel.getGroupNameList()
                self.categoryTeacherList    = await writeModel.getTeacherCategory()
                self.subjectType            = await writeModel.getSubjectType()
                
                self.editedSubject = grade.subject
                self.editedRecipient = grade.recipient
                self.editedGrader = grade.grader
                self.editedScore = grade.score
                self.editedDate = grade.dateGiven
                self.editedTypeGrade = grade.gradeType
                self.editedRetakePossible = grade.retakePossible ? "Можливо" : "Неможливо"
                
                self.changeGroupStudent     = await writeModel.getGroupStudent(of: grade.recipient)
                // set current array's
            }
        }
    }
}
