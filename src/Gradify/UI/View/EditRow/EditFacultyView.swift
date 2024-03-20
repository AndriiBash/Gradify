//
//  EditFacultyView.swift
//  Gradify
//
//  Created by Андрiй on 20.03.2024.
//

import SwiftUI

struct EditFacultyView: View
{
    @State private var editedName:                      String = ""
    @State private var editedDean:                      String = "Декан відсутній"
    @State private var editedDescription:               String = ""
    @State private var editedSpecialization:            [String] = []
    @State private var editedDepartments:               [String] = []

    @State private var isWrongIdName:                   Bool = false
    @State private var isWrongName:                     Bool = false
    @State private var isWrongDean:                     Bool = false
    @State private var isWrongDescription:              Bool = false
    @State private var isWrongLastDeparments:           Bool = false
    @State private var isWrongLastSpecialization:       Bool = false

    @State private var isWrongDeparments:           [Bool] = []
    @State private var isWrongSpecializations:      [Bool] = []

    @State private var teacherList:                     [String] = []
    @State private var specializationList:              [String] = []
    @State private var departmentsList:                 [String] = []

    @State private var statusSaveString:                String = "Зберегти"

    @State private var maxWidthForButton:               CGFloat = .zero

    @Binding var isShowView:                            Bool
    @Binding var isEditView:                            Bool
    @Binding var isUpdateListFaculty:                   Bool
    @Binding var faculty:                               Faculty
    
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
                                    Text("Назва факультета (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name specialty
                    
                    Picker("Декан", selection: $editedDean)
                    {
                        Text("Декан відсутній")
                                .tag("Декан відсутній")

                        Divider()
                        
                        ForEach(teacherList, id: \.self)
                        { teacher in
                            Text(teacher)
                                .tag(teacher)
                        }
                    }// Picker for select dean faculty
                    .foregroundColor(isWrongDean ? Color.red : Color("PopUpTextColor"))
                }// Main section
                
                Section(header: Text("Опис"))
                {
                    TextField("Опис", text: $editedDescription)
                        .foregroundColor(isWrongDescription ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedDescription.isEmpty
                                {
                                    Text("Опис")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name specialty
                }// Section description
                
                Section(header: Text("Кафедра"))
                {
                    ForEach(editedDepartments.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Кафедра №\(index + 1)", selection: $editedDepartments[index])
                            {
                                Text("Кафедру не обрано")
                                        .tag("Кафедру не обрано")

                                Divider()
                                
                                ForEach(departmentsList, id: \.self)
                                { department in
                                    Text(department)
                                        .tag(department)
                                }
                            }// Picker for select deparment
                            .foregroundColor(isWrongDeparments[index] ? Color.red : Color("PopUpTextColor"))
                            
                            Button
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    editedDepartments.remove(at: index)
                                    isWrongDeparments.remove(at: index)
                                }
                            }
                            label:
                            {
                                Image(systemName: "trash")
                                    .aspectRatio(contentMode: .fit)
                            }// Button for delete department
                            .help("Видалити кафедру зі списку")
                        }
                    }
                    
                    HStack
                    {
                        if isWrongLastDeparments
                        {
                            Text("Оберіть попередню кафедру!")
                                .foregroundColor(Color.red)
                        }
                        
                        Spacer()
                        
                        Button
                        {
                            if !editedDepartments.contains("Кафедру не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastDeparments = false
                                    
                                    editedDepartments.append("Кафедру не обрано")
                                    isWrongDeparments.append(false)
                                }
                            }
                            else
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastDeparments = true
                                }
                            }
                        }
                        label:
                        {
                            Image(systemName: "plus")
                                .aspectRatio(contentMode: .fit)
                        }// Button for add departments
                        .help("Додати нову кафедру в факультет")
                    }// HStack with button for add deparment
                }// Section department
                
                Section(header: Text("Спеціалізація"))
                {
                    ForEach(editedSpecialization.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Спеціалізація №\(index + 1)", selection: $editedSpecialization[index])
                            {
                                Text("Спеціалізацію не обрано")
                                        .tag("Спеціалізацію не обрано")

                                Divider()
                                
                                ForEach(specializationList, id: \.self)
                                { specialiazation in
                                    Text(specialiazation)
                                        .tag(specialiazation)
                                }
                            }// Picker for select specialiazation
                            .foregroundColor(isWrongSpecializations[index] ? Color.red : Color("PopUpTextColor"))
                            
                            Button
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    editedSpecialization.remove(at: index)
                                    isWrongSpecializations.remove(at: index)
                                }
                            }
                            label:
                            {
                                Image(systemName: "trash")
                                    .aspectRatio(contentMode: .fit)
                            }// Button for delete specialiazation
                            .help("Видалити спеціалізацію зі списку")
                        }
                    }
                    
                    HStack
                    {
                        if isWrongLastSpecialization
                        {
                            Text("Оберіть попередню спеціалізацію!")
                                .foregroundColor(Color.red)
                        }
                        
                        Spacer()
                        
                        Button
                        {
                            if !editedSpecialization.contains("Спеціалізацію не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSpecialization = false
                                    
                                    editedSpecialization.append("Спеціалізацію не обрано")
                                    isWrongSpecializations.append(false)
                                }
                            }
                            else
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSpecialization = true
                                }
                            }
                        }
                        label:
                        {
                            Image(systemName: "plus")
                                .aspectRatio(contentMode: .fit)
                        }// Button for add specialiazation
                        .help("Додати нову спеціалізацію в факультет")
                    }// HStack with button for add specialiazation
                }// Section specialization
            }// Main form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            Spacer()
            
            if isWrongName || isWrongDean || isWrongDescription || isWrongDeparments.contains(true) || isWrongSpecializations.contains(true)
            {
                Text("Заповніть всі поля коректно")
                    .foregroundColor(Color.red)
            }
            
            if isWrongIdName
            {
                Text("Назва факультета не повина збігатися з назвами іншими факультетів")
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
                        isWrongDean = false
                        isWrongDescription = false
                        isWrongLastDeparments = false
                        isWrongLastSpecialization = false
                        
                        isWrongSpecializations = Array(repeating: false, count: editedSpecialization.count)
                        isWrongDeparments = Array(repeating: false, count: editedDepartments.count)
                    }
                    
                    if !editedName.isEmpty && editedDean != "Декан відсутній" && !editedDescription.isEmpty && !editedSpecialization.contains("Спеціалізацію не обрано") && !editedDepartments.contains("Кафедру не обрано") && !isWrongDeparments.contains(true) && !isWrongSpecializations.contains(true) && !writeModel.isLoadingFetchData
                    {
                        Task
                        {
                            let listSpecialityKeyName = await writeModel.getFacultyName(withOut: faculty.name)
                            
                            if listSpecialityKeyName.contains(editedName)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                let status = await writeModel.updateFaculty(id: faculty.id, name: editedName, dean: editedDean, description: editedDescription, deparments: editedDepartments, specialization: editedSpecialization)
                                                                
                                isUpdateListFaculty.toggle()
                                
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
                            if editedDean == "Декан відсутній"
                            {
                                isWrongDean = true
                            }
                            if editedDescription.isEmpty
                            {
                                isWrongDescription = true
                            }
                            if editedSpecialization.contains("Спеціалізацію не обрано")
                            {
                                for index in editedSpecialization.indices
                                {
                                    if editedSpecialization[index] == "Спеціалізацію не обрано"
                                    {
                                        isWrongSpecializations[index] = true
                                    }
                                }
                            }
                            if editedDepartments.contains("Кафедру не обрано")
                            {
                                for index in editedDepartments.indices
                                {
                                    if editedDepartments[index] == "Кафедру не обрано"
                                    {
                                        isWrongDeparments[index] = true
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
                .help("Зберегти редаговану інформацію про спеціальність")
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
                self.editedName = faculty.name
                self.editedDean = faculty.dean
                self.editedDescription = faculty.description
                self.editedSpecialization = faculty.specialiazation
                self.editedDepartments = faculty.departments

                self.isWrongDeparments = Array(repeating: false, count: faculty.departments.count)
                self.isWrongSpecializations = Array(repeating: false, count: faculty.specialiazation.count)

                self.teacherList            = await writeModel.getTeacherList()
                self.specializationList     = await writeModel.getSpecializationNameList()
                self.departmentsList        = await writeModel.getDeprmentList()
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
