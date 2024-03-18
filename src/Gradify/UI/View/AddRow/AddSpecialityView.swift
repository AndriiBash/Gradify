//
//  AddSpecialityView.swift
//  Gradify
//
//  Created by Андрiй on 16.03.2024.
//

import SwiftUI

struct AddSpecialityView: View
{
    @State private var name:                    String = ""
    @State private var duration:                String = ""
    @State private var tuitionCost:             String = ""
    @State private var specialization:          String = "Без спеціалізації"
    @State private var branch:                  String = "Без галузі"
    @State private var subjects:                [String] = []

    @State private var isWrongName:             Bool = false
    @State private var isWrongDuration:         Bool = false
    @State private var isWrongTuitionCost:      Bool = false
    @State private var isWrongSpecialization:   Bool = false
    @State private var isWrongBranch:           Bool = false
    @State private var isWrongLastSubject:      Bool = false
    @State private var isWrongSubjects:         [Bool] = []
    
    @State private var subjectList:             [String] = []
    @State private var specializationList:      [String] = []
    @State private var branchList:              [String] = []

    @State private var isWrongIdName:           Bool = false

    @Binding var isShowForm:                    Bool
    @Binding var statusSave:                    Bool
    @ObservedObject var writeModel:             ReadWriteModel

    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("Додавання спеціальності")
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
                                    Text("Назва спеціальності (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name specialty

                    TextField("Тривалість навчання", text: $duration)
                        .foregroundColor(isWrongDuration ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if duration.isEmpty
                                {
                                    Text("Тривалість навчання")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for duration study
                    
                    
                    TextField("Вартість навчання", text: $tuitionCost)
                        .foregroundColor(isWrongTuitionCost ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if tuitionCost.isEmpty
                                {
                                    Text("300 грн")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for tuition coast
                        .onChange(of: tuitionCost)
                        { _, newValue in
                            let filteredValue = newValue.filter { "0123456789".contains($0) }
                            tuitionCost = filteredValue
                        }
                    
                    
                    Picker("Галузь", selection: $branch)
                    {
                        Text("Без галузі")
                                .tag("Без галузі")

                        Divider()
                        
                        ForEach(branchList, id: \.self)
                        { branch in
                            Text(branch)
                                .tag(branch)
                        }
                    }// Picker for select branch speciality
                    .foregroundColor(isWrongBranch ? Color.red : Color("PopUpTextColor"))
                    .onChange(of: branch)
                    { _, newValue in
                        
                        Task
                        {
                            self.specializationList = await writeModel.getSpecializationNameList(branch: newValue)
                            
                            if !specializationList.contains(specialization)
                            {
                                specialization = "Без спеціалізації"
                            }
                        }
                    }
                
                    Picker("Спеціалізація", selection: $specialization)
                    {
                        Text("Без спеціалізації")
                                .tag("Без спеціалізації")

                        Divider()
                        
                        ForEach(specializationList, id: \.self)
                        { specialization in
                            Text(specialization)
                                .tag(specialization)
                        }
                    }// Picker for select specialization speciality
                    .foregroundColor(isWrongSpecialization ? Color.red : Color("PopUpTextColor"))
                }// Section with main info
            
                Section(header: Text("Предмети"))
                {
                    ForEach(subjects.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Предмет №\(index + 1)", selection: $subjects[index])
                            {
                                Text("Предмет не обрано")
                                        .tag("Предмет не обрано")

                                Divider()
                                
                                ForEach(subjectList, id: \.self)
                                { subject in
                                    Text(subject)
                                        .tag(subject)
                                }
                            }// Picker for select subject
                            .foregroundColor(isWrongSubjects[index] ? Color.red : Color("PopUpTextColor"))
                            
                            Button
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    subjects.remove(at: index)
                                    isWrongSubjects.remove(at: index)
                                }
                            }
                            label:
                            {
                                Image(systemName: "trash")
                                    .aspectRatio(contentMode: .fit)
                            }// Button for delete subject
                            .help("Видалити предмет")
                        }
                    }
                    
                    HStack
                    {
                        if isWrongLastSubject
                        {
                            Text("Оберіть попередній предмет!")
                                .foregroundColor(Color.red)
                        }
                        
                        Spacer()
                        
                        Button
                        {
                            if !subjects.contains("Предмет не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSubject = false
                                    
                                    subjects.append("Предмет не обрано")
                                    isWrongSubjects.append(false)
                                }
                            }
                            else
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSubject = true
                                }
                            }
                        }
                        label:
                        {
                            Image(systemName: "plus")
                                .aspectRatio(contentMode: .fit)
                        }// Button for add subject
                        .help("Додати новий предмет який вивчається на даній спеціальності")
                    }// HStack with button for add subject
                }// Section subject
            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            Spacer()
                        
            if isWrongName || isWrongDuration || isWrongTuitionCost || isWrongSpecialization || isWrongBranch || isWrongSubjects.contains(true)
            {
                Text("Заповніть всі поля коректно")
                    .foregroundColor(Color.red)
            }
            
            if isWrongIdName
            {
                Text("Назва спеціальності не повина збігатися з назвами інших спеціальностей")
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
                        isWrongName = false
                        isWrongDuration = false
                        isWrongTuitionCost = false
                        isWrongBranch = false
                        isWrongSpecialization = false
                        isWrongLastSubject = false 
                        isWrongSubjects = Array(repeating: false, count: subjects.count)
                    }
                                        
                    if !name.isEmpty && !duration.isEmpty && !tuitionCost.isEmpty && branch != "Без галузі" && specialization != "Без спеціалізації" && !subjects.contains("Предмет не обрано") && !isWrongSubjects.contains(true) && !writeModel.isLoadingFetchData
                    {
                                                
                        Task
                        {
                            let listSpecialityKeyName = await writeModel.getSpecialityNameList(withOut: "")
                        
                            if listSpecialityKeyName.contains(name)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                isShowForm = false
                                                                
                                statusSave = await writeModel.addNewSpeciality(name: name, duration: duration, tuitionCost: Int(tuitionCost) ?? 0, specialization: specialization, branch: branch, subjects: subjects)
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
                            if duration.isEmpty
                            {
                                isWrongDuration = true
                            }
                            if tuitionCost.isEmpty
                            {
                                isWrongTuitionCost = true
                            }
                            if specialization == "Без спеціалізації"
                            {
                                isWrongSpecialization = true
                            }
                            if branch == "Без галузі"
                            {
                                isWrongBranch = true
                            }
                            if subjects.contains("Предмет не обрано")
                            {
                                for index in subjects.indices
                                {
                                    if subjects[index] == "Предмет не обрано"
                                    {
                                        isWrongSubjects[index] = true
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
        }// VStack main
        .padding(.top, 8)
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 400, height: 450)
        .onAppear
        {
            Task
            {
                self.subjectList        = await writeModel.getSubjectNameList(withOut: "")
                self.branchList         = await writeModel.getBranchName()
            }
        }
    }
    
}
