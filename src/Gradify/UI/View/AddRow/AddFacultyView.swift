//
//  AddFacultyView.swift
//  Gradify
//
//  Created by Андрiй on 20.03.2024.
//

import SwiftUI

struct AddFacultyView: View
{
    @State private var name:                        String = ""
    @State private var dean:                        String = "Декан відсутній"
    @State private var description:                 String = ""
    @State private var specialization:              [String] = []
    @State private var departments:                 [String] = []

    @State private var isWrongIdName:               Bool = false
    @State private var isWrongName:                 Bool = false
    @State private var isWrongDean:                 Bool = false
    @State private var isWrongDescription:          Bool = false
    @State private var isWrongLastDeparments:       Bool = false
    @State private var isWrongLastSpecialization:   Bool = false

    @State private var isWrongDeparments:           [Bool] = []
    @State private var isWrongSpecializations:      [Bool] = []

    @State private var teacherList:                 [String] = []
    @State private var specializationList:          [String] = []
    @State private var departmentsList:             [String] = []

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
                
                Text("Додавання факультета")
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
                                    Text("Назва факультета (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name faculty
                    
                    Picker("Декан", selection: $dean)
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
                    TextField("Опис", text: $description)
                        .foregroundColor(isWrongDescription ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if description.isEmpty
                                {
                                    Text("Опис")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name specialty
                }// Section description
                
                Section(header: Text("Кафедра"))
                {
                    ForEach(departments.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Кафедра №\(index + 1)", selection: $departments[index])
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
                                    departments.remove(at: index)
                                    isWrongDeparments.remove(at: index)
                                    isWrongLastDeparments = false
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
                            if !departments.contains("Кафедру не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastDeparments = false
                                    
                                    departments.append("Кафедру не обрано")
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
                    ForEach(specialization.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Спеціалізація №\(index + 1)", selection: $specialization[index])
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
                                    specialization.remove(at: index)
                                    isWrongSpecializations.remove(at: index)
                                    isWrongLastSpecialization = false
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
                            if !specialization.contains("Спеціалізацію не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSpecialization = false
                                    
                                    specialization.append("Спеціалізацію не обрано")
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
                        isWrongDean = false
                        isWrongDescription = false
                        isWrongLastDeparments = false
                        isWrongLastSpecialization = false
                        
                        isWrongSpecializations = Array(repeating: false, count: specialization.count)
                        isWrongDeparments = Array(repeating: false, count: departments.count)
                    }
                                        
                    if !name.isEmpty && dean != "Декан відсутній" && !description.isEmpty && !specialization.contains("Спеціалізацію не обрано") && !departments.contains("Кафедру не обрано") && !isWrongDeparments.contains(true) && !isWrongSpecializations.contains(true) && !writeModel.isLoadingFetchData
                    {
                                                    
                        Task
                        {
                            let listFacultyNameList = await writeModel.getFacultyName(withOut: "")
                        
                            print("list: \(listFacultyNameList)")
                            
                            if listFacultyNameList.contains(name)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                isShowForm = false
                                                                
                                statusSave = await writeModel.addNewFaculty(name: name, dean: dean, description: description, deparments: departments, specialization: specialization)
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
                            if dean == "Декан відсутній"
                            {
                                isWrongDean = true
                            }
                            if description.isEmpty
                            {
                                isWrongDescription = true
                            }
                            if specialization.contains("Спеціалізацію не обрано")
                            {
                                for index in specialization.indices
                                {
                                    if specialization[index] == "Спеціалізацію не обрано"
                                    {
                                        isWrongSpecializations[index] = true
                                    }
                                }
                            }
                            if departments.contains("Кафедру не обрано")
                            {
                                for index in departments.indices
                                {
                                    if departments[index] == "Кафедру не обрано"
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
        }// Main vstack
        .padding(.top, 8)
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 400, height: 450)
        .onAppear
        {
            Task
            {
                self.teacherList            = await writeModel.getTeacherList(withOut: "")
                self.specializationList     = await writeModel.getSpecializationNameList()
                self.departmentsList        = await writeModel.getDeprmentNameList(withOut: "")
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
