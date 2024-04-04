//
//  EditDepartmentView.swift
//  Gradify
//
//  Created by Андрiй on 23.03.2024.
//

import SwiftUI

struct EditDepartmentView: View
{
    @State private var editedName:                      String = ""
    @State private var editedDescription:               String = ""
    @State private var editedSpecialization:            String = "Спеціалізація відсутня"
    @State private var editedDepartmentLeader:          String = "Завідувач відсутній"
    
    @State private var editedViceLeader:                String = "Зам завідувач відсутній"
    @State private var editedDepartemntOffice:          String = ""
    @State private var editedCreationYear:              String = "2000"
    
    @State private var editedTeachers:                  [String] = []

    @State private var isWrongIdName:                   Bool = false
    @State private var isWrongName:                     Bool = false
    @State private var isWrongDescription:              Bool = false
    @State private var isWrongSpecialization:           Bool = false
    
    @State private var isWrongDepartmentLeader:         Bool = false
    @State private var isWrongViceLeader:               Bool = false
    @State private var isWrongDepartemntOffice:         Bool = false
    @State private var isWrongCreationYear:             Bool = false
    @State private var isWrongLastTeacher:              Bool = false

    @State private var isWrongTeachers:                 [Bool] = []
        
    @State private var teacherList:                     [String] = []
    @State private var specializationList:              [String] = []

    @State private var statusSaveString:                String = "Зберегти"

    @State private var maxWidthForButton:               CGFloat = .zero

    @Binding var isShowView:                            Bool
    @Binding var isEditView:                            Bool
    @Binding var isUpdateListDepartment:                Bool
    @Binding var department:                            Department
    
    @ObservedObject var writeModel:                     ReadWriteModel

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
                                    Text("Назва кафедри (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name specialty
                    
                    Picker("Спеціалізація", selection: $editedSpecialization)
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

                    Picker("Завідувач кафедри", selection: $editedDepartmentLeader)
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

                    Picker("Зам завідувач кафедри", selection: $editedViceLeader)
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

                    TextField("Аудиторія кафедри", text: $editedDepartemntOffice)
                        .foregroundColor(isWrongDepartemntOffice ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedDepartemntOffice.isEmpty
                                {
                                    Text("Номер кімнати, тощо")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for office department

                    TextField("Рік заснування", text: $editedCreationYear)
                        .foregroundColor(isWrongCreationYear ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedCreationYear.isEmpty
                                {
                                    Text("Рік створення кафедри")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for office department
                        .onChange(of: editedCreationYear)
                        { _, newValue in
                            let filteredValue = newValue.filter { "0123456789".contains($0) }
                            editedCreationYear = String(filteredValue.prefix(4))
                        }
                }// main ection
                
                Section(header: Text("Опис"))
                {
                    TextField("Опис кафедри", text: $editedDescription)
                        .foregroundColor(isWrongDescription ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedDescription.isEmpty
                                {
                                    Text("Основа інформація")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for description department
                }// Section description
                
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
                                    editedTeachers.remove(at: index)
                                    isWrongTeachers.remove(at: index)
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

            Spacer()
            

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
                        isWrongIdName = false
                        isWrongName = false
                        isWrongDescription = false
                        isWrongSpecialization = false
                        isWrongDepartmentLeader = false
                        isWrongViceLeader = false
                        isWrongDepartemntOffice = false
                        isWrongCreationYear = false
                        isWrongLastTeacher = false
                        
                        isWrongTeachers = Array(repeating: false, count: editedTeachers.count)
                    }
                    
                    if !editedName.isEmpty && !editedDescription.isEmpty && editedSpecialization != "Спеціалізація відсутня" && editedDepartmentLeader != "Завідувач відсутній" && editedViceLeader != "Зам завідувач відсутній" && !editedDepartemntOffice.isEmpty && !editedCreationYear.isEmpty && editedCreationYear.count == 4 && !editedTeachers.contains("Викладача не обрано")
                    {
                        Task
                        {
                            let listDepartmentNameList = await writeModel.getDeprmentNameList(withOut: department.name)
                                                    
                            if listDepartmentNameList.contains(editedName)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                let status = await writeModel.updateDepartment(id: department.id, name: editedName, description: editedDescription, specialization: editedSpecialization, departmentLeader: editedDepartmentLeader, viceLeader: editedViceLeader, teacherList: editedTeachers, departmentOffice: editedDepartemntOffice, creationYear: Int(editedCreationYear) ?? 2000)
                                                                
                                isUpdateListDepartment.toggle()
                                
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
                            if editedDescription.isEmpty
                            {
                                isWrongDescription = true
                            }
                            if editedSpecialization == "Спеціалізація відсутня"
                            {
                                isWrongSpecialization = true
                            }
                            if editedDepartmentLeader == "Завідувач відсутній"
                            {
                                isWrongDepartmentLeader = true
                            }
                            if editedViceLeader == "Зам завідувач відсутній"
                            {
                                isWrongViceLeader = true
                            }
                            if editedDepartemntOffice.isEmpty
                            {
                                isWrongDepartemntOffice = true
                            }
                            if editedCreationYear.isEmpty || editedCreationYear.count != 4
                            {
                                isWrongCreationYear = true
                            }
                            if editedTeachers.contains("Викладача не обрано")
                            {
                                for index in editedTeachers.indices
                                {
                                    if editedTeachers[index] == "Викладача не обрано"
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
        }// Main VStack
        .padding(.top, 8)
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 430, height: 450)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
            
            Task
            {
                self.editedName             = department.name
                self.editedDescription      = department.description
                self.editedSpecialization   = department.specialization
                self.editedDepartmentLeader = department.departmentLeader
                self.editedViceLeader       = department.viceLeader
                self.editedDepartemntOffice = department.departmentOffice
                self.editedCreationYear     = String(department.creationYear)
                self.editedTeachers         = department.teacherList
                
                self.isWrongTeachers        = Array(repeating: false, count: department.teacherList.count)

                self.teacherList            = await writeModel.getTeacherList(withOut: "")
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
