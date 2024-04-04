//
//  AddSubjectView.swift
//  Gradify
//
//  Created by Андрiй on 04.04.2024.
//

import SwiftUI

struct AddSubjectView: View
{
    @State private var name:                        String = ""
    @State private var type:                        String = "Навчальний"
    @State private var departamentSubject:          String = "Кафедру не обрано"
    @State private var totalHours:                  String = ""
    @State private var lectureHours:                String = ""
    @State private var labHours:                    String = ""
    @State private var seminarHours:                String = ""
    @State private var independentStudyHours:       String = ""
    @State private var semester:                    String = ""
    @State private var semesterControl:             String = "Залік"
    @State private var teachers:                    [String] = []

    @State private var isWrongIdName:               Bool = false
    @State private var isWrongName:                 Bool = false
    
    @State private var isWrongTotalHours:           Bool = false
    @State private var isWrongLectureHours:         Bool = false
    @State private var isWrongLabHours:             Bool = false
    @State private var isWrongSeminarHours:         Bool = false
    @State private var isWrongIndependentStudyHours:Bool = false
    @State private var isWrongSemester:             Bool = false
    @State private var isWrongLastTeacher:          Bool = false
    
    @State private var isWrongTeacher:              [Bool] = []

    @State private var department:                  [String] = []
    @State private var typeList:                    [String] = []
    @State private var semesterControlList:         [String] = []
    @State private var teacherList:                 [String] = []

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
                
                Text("Додавання предмета")
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
                                    Text("Назва предмету (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name specialty
                    
                    Picker("Тип", selection: $type)
                    {
                        ForEach(typeList, id: \.self)
                        { type in
                            Text(type)
                                .tag(type)
                        }
                    }// Picker for select subject type

                    Picker("Кафедра яка викладає", selection: $departamentSubject)
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

                    TextField("Семестр в якому вивчається", text: $semester)
                        .foregroundColor(isWrongSemester ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if semester.isEmpty
                                {
                                    Text("2-а")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                        .padding(.bottom)
                                }
                            })// textField for semester learning subject

                    Picker("Семестровий контроль", selection: $semesterControl)
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
                    TextField("Всього годин", text: $totalHours)
                        .foregroundColor(isWrongTotalHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if totalHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: totalHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                totalHours = String(filteredValue.prefix(3))
                            }

                    TextField("Лекційних годин", text: $lectureHours)
                        .foregroundColor(isWrongLectureHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if lectureHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: lectureHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                lectureHours = String(filteredValue.prefix(3))
                            }

                    TextField("Лабораторних годин", text: $labHours)
                        .foregroundColor(isWrongLabHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if labHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: labHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                labHours = String(filteredValue.prefix(3))
                            }

                    TextField("Семінарських годин", text: $seminarHours)
                        .foregroundColor(isWrongSeminarHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if seminarHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: seminarHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                seminarHours = String(filteredValue.prefix(3))
                            }

                    TextField("Час на самостійні роботи", text: $independentStudyHours)
                        .foregroundColor(isWrongIndependentStudyHours ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                if independentStudyHours.isEmpty
                                {
                                    Text("0 год")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })
                            .onChange(of: independentStudyHours)
                            { _, newValue in
                                let filteredValue = newValue.filter { "0123456789".contains($0) }
                                independentStudyHours = String(filteredValue.prefix(3))
                            }
                }// Section with time to learn subject
                
                Section(header: Text("Викладачі"))
                {
                    ForEach(teachers.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Викладач №\(index + 1)", selection: $teachers[index])
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
                                    teachers.remove(at: index)
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
                            if !teachers.contains("Викладача не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastTeacher = false
                                    
                                    teachers.append("Викладача не обрано")
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
                .onChange(of: departamentSubject)
                { _, newValue in
                    if newValue != "Кафедру не обрано"
                    {
                        Task
                        {
                            teacherList = await writeModel.getTeacherList(withDepartment: departamentSubject)
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
                        isWrongIdName                   = false
                        isWrongName                     = false
                        
                        isWrongTotalHours               = false
                        isWrongLectureHours             = false
                        isWrongLabHours                 = false
                        isWrongSeminarHours             = false
                        isWrongIndependentStudyHours    = false
                        isWrongSemester                 = false
                        isWrongLastTeacher              = false
                        
                        isWrongTeacher = Array(repeating: false, count: teachers.count)
                    }
                                        
                    if !name.isEmpty && !totalHours.isEmpty && !lectureHours.isEmpty && !labHours.isEmpty && !seminarHours.isEmpty && !independentStudyHours.isEmpty && !semester.isEmpty && !teachers.contains("Викладача не обрано")
                    {
                                                    
                        Task
                        {
                            let listSubjecttNameList = await writeModel.getSubjectNameList(withOut: "")
                                                    
                            if listSubjecttNameList.contains(name)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                isShowForm = false
                                                                
                                statusSave = await writeModel.addNewSubject(name: name, type: type, teacherList: teacherList, departamentSubject: departamentSubject, totalHours: Int(totalHours) ?? 0, lectureHours: Int(lectureHours) ?? 0, labHours: Int(labHours) ?? 0, seminarHours: Int(seminarHours) ?? 0, independentStudyHours: Int(independentStudyHours) ?? 0, semester: semester, semesterControl: semesterControl)
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
                            if totalHours.isEmpty
                            {
                                isWrongTotalHours = true
                            }
                            if lectureHours.isEmpty
                            {
                                isWrongLectureHours = true
                            }
                            if labHours.isEmpty
                            {
                                isWrongLabHours = true
                            }
                            if seminarHours.isEmpty
                            {
                                isWrongSeminarHours = true
                            }
                            if independentStudyHours.isEmpty
                            {
                                isWrongIndependentStudyHours = true
                            }
                            if semester.isEmpty
                            {
                                isWrongSemester = true
                            }
                            if teachers.contains("Викладача не обрано")
                            {
                                for index in teachers.indices
                                {
                                    if teachers[index] == "Викладача не обрано"
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
        }// main Form
        .padding(.top, 8)
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 430, height: 470)
        .onAppear
        {
            Task
            {
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
