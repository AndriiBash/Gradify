//
//  EditSubjectProgramView.swift
//  Gradify
//
//  Created by Андрiй on 04.04.2024.
//

import SwiftUI

struct EditSubjectView: View
{
    @State private var editedName:                          String = ""
    @State private var editedType:                          String = "Навчальний"
    @State private var editedDepartamentSubject:            String = "Кафедру не обрано"
    @State private var editedTotalHours:                    String = ""
    @State private var editedLectureHours:                  String = ""
    @State private var editedLabHours:                      String = ""
    @State private var editedSeminarHours:                  String = ""
    @State private var editedIndependentStudyHours:         String = ""
    @State private var editedSemester:                      String = ""
    @State private var editedSemesterControl:               String = "Залік"
    @State private var editedTeachers:                      [String] = []

    @State private var isWrongIdName:                       Bool = false
    @State private var isWrongName:                         Bool = false
    
    @State private var isWrongTotalHours:                   Bool = false
    @State private var isWrongLectureHours:                 Bool = false
    @State private var isWrongLabHours:                     Bool = false
    @State private var isWrongSeminarHours:                 Bool = false
    @State private var isWrongIndependentStudyHours:        Bool = false
    @State private var isWrongSemester:                     Bool = false
    @State private var isWrongLastTeacher:                  Bool = false
    
    @State private var isWrongTeacher:                      [Bool] = []

    @State private var department:                          [String] = []
    @State private var typeList:                            [String] = []
    @State private var semesterControlList:                 [String] = []
    @State private var teacherList:                         [String] = []

    @State private var statusSaveString:                    String = "Зберегти"

    @State private var maxWidthForButton:                   CGFloat = .zero

    @Binding var isShowView:                                Bool
    @Binding var isEditView:                                Bool
    @Binding var isUpdateListSubject:                       Bool
    @Binding var subject:                                   Subject
    
    @ObservedObject var writeModel:                         ReadWriteModel

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
                                    Text("Назва предмету (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name specialty
                    
                    Picker("Тип", selection: $editedType)
                    {
                        ForEach(typeList, id: \.self)
                        { type in
                            Text(type)
                                .tag(type)
                        }
                    }// Picker for select subject type

                    Picker("Кафедра яка викладає", selection: $editedDepartamentSubject)
                    {
                        Text("Кафедру не обрано")
                                .tag("Кафедру не обрано")

                        Divider()
                        
                        ForEach(department, id: \.self)
                        { department in
                            Text(department)
                                .tag(department)
                        }
                    }// Picker for select department subject

                    TextField("Семестр в якому вивчається", text: $editedSemester)
                        .foregroundColor(isWrongSemester ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedSemester.isEmpty
                                {
                                    Text("2-а")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                        .padding(.bottom)
                                }
                            })// textField for semester learning subject

                    Picker("Семестровий контроль", selection: $editedSemesterControl)
                    {
                        ForEach(semesterControlList, id: \.self)
                        { semesterControl in
                            Text(semesterControl)
                                .tag(semesterControl)
                        }
                    }// Picker for select semester control type
                }// main Section
                
                Section(header: Text("Час на вивчення"))
                {
                    TextField("Всього годин", text: $editedTotalHours)
                        .foregroundColor(isWrongTotalHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedTotalHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: editedTotalHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                editedTotalHours = String(filteredValue.prefix(3))
                            }

                    TextField("Лекційних годин", text: $editedLectureHours)
                        .foregroundColor(isWrongLectureHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedLectureHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: editedLectureHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                editedLectureHours = String(filteredValue.prefix(3))
                            }

                    TextField("Лабораторних годин", text: $editedLabHours)
                        .foregroundColor(isWrongLabHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if editedLabHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: editedLabHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                editedLabHours = String(filteredValue.prefix(3))
                            }

                    TextField("Семінарських годин", text: $editedSeminarHours)
                        .foregroundColor(isWrongSeminarHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedSeminarHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: editedSeminarHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                editedSeminarHours = String(filteredValue.prefix(3))
                            }

                    TextField("Час на самостійні роботи", text: $editedIndependentStudyHours)
                        .foregroundColor(isWrongIndependentStudyHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedIndependentStudyHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: editedIndependentStudyHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                editedIndependentStudyHours = String(filteredValue.prefix(3))
                            }
                }// Section with time to learn subject
                
                Section(header: Text("Викладачі"))
                {
                    ForEach(editedTeachers.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Викладач №\(index + 1)", selection: $editedTeachers[index])
                            {
                                Text("Викладача не обрано")
                                        .tag("Викладача не обрано")

                                Divider()
                                
                                ForEach(teacherList, id: \.self)
                                { teacher in
                                    Text(teacher)
                                        .tag(teacher)
                                }
                            }// Picker for select teacher
                            .foregroundColor(isWrongTeacher[index] ? Color.red : Color("PopUpTextColor"))
                            
                            Button
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    editedTeachers.remove(at: index)
                                    isWrongTeacher.remove(at: index)
                                    isWrongLastTeacher = false
                                }
                            }
                            label:
                            {
                                Image(systemName: "trash")
                                    .aspectRatio(contentMode: .fit)
                            }// Button for delete teacher
                            .help("Видалити викладача зі списку")
                        }
                    }
                    
                    HStack
                    {
                        if isWrongLastTeacher
                        {
                            Text("Оберіть попереднього викладача!")
                                .foregroundColor(Color.red)
                        }
                        
                        Spacer()
                        
                        Button
                        {
                            if !editedTeachers.contains("Викладача не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastTeacher = false
                                    
                                    editedTeachers.append("Викладача не обрано")
                                    isWrongTeacher.append(false)
                                }
                            }
                            else
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastTeacher = true
                                }
                            }
                        }
                        label:
                        {
                            Image(systemName: "plus")
                                .aspectRatio(contentMode: .fit)
                        }// Button for add teacher
                        .help("Додати нового викладача який викладає дисципліну")
                    }// HStack with button for add teacher
                }// Section with teacher in subject
                .onChange(of: editedDepartamentSubject)
                { _, newValue in
                    if newValue != "Кафедру не обрано"
                    {
                        Task
                        {
                            teacherList = await writeModel.getTeacherList(withDepartment: editedDepartamentSubject)
                        }
                    }
                    else
                    {
                        teacherList = []
                    }
                }

            }// main Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)

            if isWrongName || isWrongTotalHours || isWrongLectureHours || isWrongLabHours || isWrongSeminarHours || isWrongIndependentStudyHours || isWrongSemester || isWrongLastTeacher || isWrongTeacher.contains(true)
            {
                Text("Заповніть всі поля коректно")
                    .foregroundColor(Color.red)
            }
            
            if isWrongIdName
            {
                Text("Назва предмету не повина збігатися з назвами інших предметів")
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
                        isWrongIdName                   = false
                        isWrongName                     = false
                        
                        isWrongTotalHours               = false
                        isWrongLectureHours             = false
                        isWrongLabHours                 = false
                        isWrongSeminarHours             = false
                        isWrongIndependentStudyHours    = false
                        isWrongSemester                 = false
                        isWrongLastTeacher              = false
                        
                        isWrongTeacher = Array(repeating: false, count: editedTeachers.count)
                    }
                    
                    if !editedName.isEmpty && !editedTotalHours.isEmpty && !editedLectureHours.isEmpty && !editedLabHours.isEmpty && !editedSeminarHours.isEmpty && !editedIndependentStudyHours.isEmpty && !editedSemester.isEmpty && !editedTeachers.contains("Викладача не обрано")
                    {
                        Task
                        {
                            let listDepartmentNameList = await writeModel.getDeprmentNameList(withOut: subject.name)
                                                    
                            if listDepartmentNameList.contains(editedName)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                let status = await writeModel.updateSubject(id: subject.id, name: editedName, type: editedType, teacherList: editedTeachers, departamentSubject: editedDepartamentSubject, totalHours: Int(editedTotalHours) ?? 2000, lectureHours: Int(editedLectureHours) ?? 2000, labHours: Int(editedLabHours) ?? 2000, seminarHours: Int(editedSeminarHours) ?? 2000, independentStudyHours: Int(editedIndependentStudyHours) ?? 2000, semester: editedSemester, semesterControl: editedSemesterControl)
                                
                                isUpdateListSubject.toggle()
                                
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
                            if editedTotalHours.isEmpty
                            {
                                isWrongTotalHours = true
                            }
                            if editedLectureHours.isEmpty
                            {
                                isWrongLectureHours = true
                            }
                            if editedLabHours.isEmpty
                            {
                                isWrongLabHours = true
                            }
                            if editedSeminarHours.isEmpty
                            {
                                isWrongSeminarHours = true
                            }
                            if editedIndependentStudyHours.isEmpty
                            {
                                isWrongIndependentStudyHours = true
                            }
                            if editedSemester.isEmpty
                            {
                                isWrongSemester = true
                            }
                            if editedTeachers.contains("Викладача не обрано")
                            {
                                for index in editedTeachers.indices
                                {
                                    if editedTeachers[index] == "Викладача не обрано"
                                    {
                                        isWrongTeacher[index] = true
                                    }
                                }
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
                .help("Зберегти редаговану інформацію про кафедру")
                .keyboardShortcut(.defaultAction)
                .padding(.leading, 12)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
            .padding(.horizontal, 22)
        }// main VStack
        .padding(.top, 8)
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 430, height: 470)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
            
            Task
            {
                self.editedName = subject.name
                self.editedType = subject.type
                self.editedDepartamentSubject = subject.departamentSubject

                self.editedTotalHours = String(subject.totalHours)
                self.editedLectureHours = String(subject.lectureHours)
                self.editedLabHours = String(subject.labHours)
                self.editedSeminarHours = String(subject.seminarHours)
                self.editedIndependentStudyHours = String(subject.independentStudyHours)
                
                self.editedSemester = subject.semester
                self.editedSemesterControl = subject.semesterControl
                self.editedTeachers = subject.teacherList

                self.isWrongTeacher = Array(repeating: false, count: subject.teacherList.count)

                self.department             = await writeModel.getDeprmentNameList(withOut: "")
                self.typeList               = await writeModel.getTypeSubjectList()
                self.semesterControlList    = await writeModel.getSemesterControlList()
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
