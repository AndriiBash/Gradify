//
//  AddDepartmentView.swift
//  Gradify
//
//  Created by Андрiй on 23.03.2024.
//

import SwiftUI

struct AddDepartmentView: View
{
    @State private var name:                        String = ""
    @State private var description:                 String = ""
    @State private var specialization:              String = "Спеціалізація відсутня"
    @State private var departmentLeader:            String = "Завідувач відсутній"
    @State private var viceLeader:                  String = "Зам завідувач відсутній"
    @State private var departemntOffice:            String = ""
    @State private var creationYear:                String = ""
    
    @State private var teachers:                    [String] = []
    
    @State private var isWrongIdName:               Bool = false
    @State private var isWrongName:                 Bool = false
    @State private var isWrongDescription:          Bool = false
    @State private var isWrongSpecialization:       Bool = false
    
    @State private var isWrongDepartmentLeader:     Bool = false
    @State private var isWrongViceLeader:           Bool = false
    @State private var isWrongDepartemntOffice:     Bool = false
    @State private var isWrongCreationYear:         Bool = false
    @State private var isWrongLastTeacher:          Bool = false

    @State private var isWrongTeachers:             [Bool] = []
    
    @State private var teacherList:                 [String] = []
    @State private var specializationList:          [String] = []

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
                
                Text("Додавання кафедри")
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
                                    Text("Назва кафедри (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name specialty
                    
                    Picker("Спеціалізація", selection: $specialization)
                    {
                        Text("Спеціалізація відсутня")
                                .tag("Спеціалізація відсутня")

                        Divider()
                        
                        ForEach(specializationList, id: \.self)
                        { specialization in
                            Text(specialization)
                                .tag(specialization)
                        }
                    }// Picker for select specialiaztion department
                    .foregroundColor(isWrongSpecialization ? Color.red : Color("PopUpTextColor"))

                    Picker("Завідувач кафедри", selection: $departmentLeader)
                    {
                        Text("Завідувач відсутній")
                                .tag("Завідувач відсутній")

                        Divider()
                        
                        ForEach(teacherList, id: \.self)
                        { teacher in
                            Text(teacher)
                                .tag(teacher)
                        }
                    }// Picker for select department leader
                    .foregroundColor(isWrongDepartmentLeader ? Color.red : Color("PopUpTextColor"))

                    Picker("Зам завідувач кафедри", selection: $viceLeader)
                    {
                        Text("Зам завідувач відсутній")
                                .tag("Зам завідувач відсутній")

                        Divider()
                        
                        ForEach(teacherList, id: \.self)
                        { teacher in
                            Text(teacher)
                                .tag(teacher)
                        }
                    }// Picker for select vice department leader
                    .foregroundColor(isWrongViceLeader ? Color.red : Color("PopUpTextColor"))

                    TextField("Аудиторія кафедри", text: $departemntOffice)
                        .foregroundColor(isWrongDepartemntOffice ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if departemntOffice.isEmpty
                                {
                                    Text("Номер кімнати, тощо")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for office department

                    TextField("Рік заснування", text: $creationYear)
                        .foregroundColor(isWrongCreationYear ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if creationYear.isEmpty
                                {
                                    Text("Рік створення кафедри")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for office department
                        .onChange(of: creationYear)
                        { _, newValue in
                            let filteredValue = newValue.filter { "0123456789".contains($0) }
                            creationYear = String(filteredValue.prefix(4))
                        }
                }// main ection
                
                Section(header: Text("Опис"))
                {
                    TextField("Опис кафедри", text: $description)
                        .foregroundColor(isWrongDescription ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if description.isEmpty
                                {
                                    Text("Основа інформація")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for description department
                }// Section description
                
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
                                { department in
                                    Text(department)
                                        .tag(department)
                                }
                            }// Picker for select teacher
                            .foregroundColor(isWrongTeachers[index] ? Color.red : Color("PopUpTextColor"))
                            
                            Button
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    teachers.remove(at: index)
                                    isWrongTeachers.remove(at: index)
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
                                    isWrongTeachers.append(false)
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
                        .help("Додати нового викладача в кафедру")
                    }// HStack with button for add teacher
                }// Section with teachers
            }// main Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)

            if isWrongName || isWrongDescription || isWrongSpecialization || isWrongDepartmentLeader || isWrongViceLeader || isWrongDepartemntOffice || isWrongCreationYear || isWrongTeachers.contains(true)
            {
                Text("Заповніть всі поля коректно")
                    .foregroundColor(Color.red)
            }
            
            if isWrongIdName
            {
                Text("Назва кафедри не повина збігатися з назвами іншими кафедр")
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
                        isWrongIdName = false
                        isWrongName = false
                        isWrongDescription = false
                        isWrongSpecialization = false
                        isWrongDepartmentLeader = false
                        isWrongViceLeader = false
                        isWrongDepartemntOffice = false
                        isWrongCreationYear = false
                        isWrongLastTeacher = false
                        
                        isWrongTeachers = Array(repeating: false, count: teachers.count)
                    }
                                        
                    if !name.isEmpty && !description.isEmpty && specialization != "Спеціалізація відсутня" && departmentLeader != "Завідувач відсутній" && viceLeader != "Зам завідувач відсутній" && !departemntOffice.isEmpty && !creationYear.isEmpty && creationYear.count == 4 && !teachers.contains("Викладача не обрано")
                    {
                                                    
                        Task
                        {
                            let listDepartmentNameList = await writeModel.getDeprmentNameList(withOut: "")
                                                    
                            if listDepartmentNameList.contains(name)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                isShowForm = false
                                                                
                                statusSave = await writeModel.addNewDepartment(name: name, description: description, specialization: specialization, departmentLeader: departmentLeader, viceLeader: viceLeader, teacherList: teacherList, departmentOffice: departemntOffice, creationYear: Int(creationYear) ?? 2000)
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
                            if description.isEmpty
                            {
                                isWrongDescription = true
                            }
                            if specialization == "Спеціалізація відсутня"
                            {
                                isWrongSpecialization = true
                            }
                            if departmentLeader == "Завідувач відсутній"
                            {
                                isWrongDepartmentLeader = true
                            }
                            if viceLeader == "Зам завідувач відсутній"
                            {
                                isWrongViceLeader = true
                            }
                            if departemntOffice.isEmpty
                            {
                                isWrongDepartemntOffice = true
                            }
                            if creationYear.isEmpty || creationYear.count != 4
                            {
                                isWrongCreationYear = true
                            }
                            
                            if teachers.contains("Викладача не обрано")
                            {
                                for index in teachers.indices
                                {
                                    if teachers[index] == "Викладача не обрано"
                                    {
                                        isWrongTeachers[index] = true
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
        }// main VStack
        .padding(.top, 8)
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 430, height: 450)
        .onAppear
        {
            Task
            {
                self.teacherList            = await writeModel.getTeacherList()
                self.specializationList     = await writeModel.getSpecializationNameList()
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
