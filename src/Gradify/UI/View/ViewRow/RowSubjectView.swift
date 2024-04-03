//
//  RowSubjectView.swift
//  Gradify
//
//  Created by Андрiй on 03.04.2024.
//

import SwiftUI

struct RowSubjectView: View
{
    @State private var hoverOnName:                     Bool = false
    @State private var hoverOnType:                     Bool = false

    @State private var hoverOnTeacher:                  [Bool] = []

    @State private var hoverOnViceLeader:               Bool = false
    @State private var hoverOnDepartmentSubject:        Bool = false
    
    @State private var hoverOnTotalHours:               Bool = false
    @State private var hoverOnLectureHours:             Bool = false
    @State private var hoverOnLabHours:                 Bool = false
    @State private var hoverOnSeminarHours:             Bool = false
    @State private var hoverOnIndependentStudyHours:    Bool = false
    @State private var hoverOnSemectr:                  Bool = false
    @State private var hoverOnSemesterControl:          Bool = false
    
    @State private var statusCopyString:                String  = "Скопіювати"
    @State private var maxWidthForButton:               CGFloat = .zero
    
    @Binding var isShowView:                            Bool
    @Binding var isEditView:                            Bool
    
    var subject:                                        Subject

    
    init(isShowView: Binding<Bool>, isEditView: Binding<Bool>, subject: Subject)
    {
        self._isShowView = isShowView
        self._isEditView = isEditView
        self.subject = subject
        
        self._hoverOnTeacher = State(initialValue: Array(repeating: false, count: subject.teacherList.count))
    }
        
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("[\(subject.id)] \(subject.name)")
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
                        
                        Text("\(subject.name)")
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
                                    copyInBuffer(text: subject.name)
                                }
                                label:
                                {
                                    Text("Скопіювати назву")
                                }
                            }
                    }// HStack with name subject
                    
                    HStack
                    {
                        Text("Тип")
                        
                        Spacer()
                        
                        Text("\(subject.type)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnType ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnType.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: subject.type)
                                }
                                label:
                                {
                                    Text("Скопіювати тип")
                                }
                            }
                    }// HStack with type subject

                    HStack
                    {
                        Text("Кафедра яка викладає")
                        
                        Spacer()
                        
                        Text("\(subject.departamentSubject)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnDepartmentSubject ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnDepartmentSubject.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: subject.departamentSubject)
                                }
                                label:
                                {
                                    Text("Скопіювати назву кафедри яка викладає")
                                }
                            }
                    }// HStack with departamentSubject subject
                    
                    HStack
                    {
                        Text("Семестр в якому вивчається")
                        
                        Spacer()
                        
                        Text("\(subject.semester)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnSemectr ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnSemectr.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: subject.semester)
                                }
                                label:
                                {
                                    Text("Скопіювати назву семестра в якому вивчається дисципліна")
                                }
                            }
                    }// HStack with semester subject

                    HStack
                    {
                        Text("Семестровий контроль")
                        
                        Spacer()
                        
                        Text("\(subject.semesterControl)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnSemesterControl ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnSemesterControl.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: subject.semesterControl)
                                }
                                label:
                                {
                                    Text("Скопіювати семестровий контроль")
                                }
                            }
                    }// HStack with semesterControl subject
                }// main Section
                
                Section(header: Text("Час на вивчення"))
                {
                    HStack
                    {
                        Text("Всього годин")
                        
                        Spacer()
                        
                        Text("\(subject.totalHours) год.")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnTotalHours ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnTotalHours.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: "\(subject.totalHours) год.")
                                }
                                label:
                                {
                                    Text("Скопіювати загальну кількість часу для вивчення диспципліни")
                                }
                            }
                    }// HStack with totalHours for learn subject

                    HStack
                    {
                        Text("Лекційних годин")
                        
                        Spacer()
                        
                        Text("\(subject.lectureHours) год.")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnLectureHours ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnLectureHours.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: "\(subject.lectureHours) год.")
                                }
                                label:
                                {
                                    Text("Скопіювати кількість лекційних годин")
                                }
                            }
                    }// HStack with totalHours for lectureHours subject

                    HStack
                    {
                        Text("Лабораторних годин")
                        
                        Spacer()
                        
                        Text("\(subject.labHours) год.")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnLabHours ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnLabHours.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: "\(subject.labHours) год.")
                                }
                                label:
                                {
                                    Text("Скопіювати кількість лабораторних годин")
                                }
                            }
                    }// HStack with totalHours for labHours subject

                    HStack
                    {
                        Text("Семінарських годин")
                        
                        Spacer()
                        
                        Text("\(subject.seminarHours) год.")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnSeminarHours ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnSeminarHours.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: "\(subject.seminarHours) год.")
                                }
                                label:
                                {
                                    Text("Скопіювати кількість семінарськиї годин")
                                }
                            }
                    }// HStack with totalHours for seminarHours subject

                    HStack
                    {
                        Text("Час на самостійні роботи")
                        
                        Spacer()
                        
                        Text("\(subject.independentStudyHours) год.")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnIndependentStudyHours ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnIndependentStudyHours.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: "\(subject.independentStudyHours) год.")
                                }
                                label:
                                {
                                    Text("Скопіювати кількість часу на самостійні роботи")
                                }
                            }
                    }// HStack with totalHours for independentStudyHours subject
                }// Section with all time for learn subject
                
                Section(header: Text("Викладачі"))
                {
                    if subject.teacherList.isEmpty
                    {
                        HStack
                        {
                            Spacer()
                            
                            Text("Викладачі відсутні")
                            
                            Spacer()
                        }// HStack with info about none teacher in subject
                    }
                    else
                    {
                        ForEach(subject.teacherList.indices, id: \.self)
                        { index in
                            HStack
                            {
                                Text("Викладач №\(index + 1)")
                                
                                Spacer()
                                
                                Text("\(subject.teacherList[index])")
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
                                        copyInBuffer(text: subject.teacherList[index])
                                    }
                                    label:
                                    {
                                        Text("Скопіювати ПІБ викладача")
                                    }
                                }
                            }// ForEach with teacher in subject
                        }
                    }

                }// Section with teachers in subject
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
                            [\(subject.id)] \(subject.name)
                            ===========================================
                            Назва: \(subject.name)
                            Тип: \(subject.type)
                            Кафедра яка викладає: \(subject.departamentSubject)
                            Семестр в якому вивчається: \(subject.semester)
                            Семестровий контроль: \(subject.semesterControl)
                            ===========================================
                            Всього годин: \(subject.totalHours)
                            Лекційних годин: \(subject.lectureHours)
                            Лабораторних годин: \(subject.labHours)
                            Семінарських годин: \(subject.seminarHours)
                            Час на самостіні роботи: \(subject.independentStudyHours)
                            ===========================================\n
                            """
                    
                    if !subject.teacherList.isEmpty
                    {
                        for index in subject.teacherList.indices
                        {
                            allInfo += "Викладач №\(index + 1) :" + "\(subject.teacherList[index])\n"
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

    }
}
