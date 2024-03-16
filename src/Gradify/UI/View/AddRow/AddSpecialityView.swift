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
    @State private var specialization:          String = ""
    @State private var subjects:                [String] = []

    @State private var isWrongName:             Bool = false
    @State private var isWrongDuration:         Bool = false
    @State private var isWrongTuitionCost:      Bool = false
    @State private var isWrongSpecialization:   Bool = false
    
    @State private var subjectList:             [String] = []
    @State private var specializationList:      [String] = []

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
                    .padding(.top, 10)
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
                }// Section with main info
            
                Section(header: Text("Предмети"))
                {
                    Text("hello!")
                }// Section subject
            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            Spacer()
                        
            if isWrongName || isWrongDuration || isWrongTuitionCost || isWrongSpecialization
            {
                Text("Заповніть всі поля коректно")
                    .foregroundColor(Color.red)
            }
            
            if isWrongIdName
            {
                Text("Назва спеціалізації не повина збігатися з назвами інших спеціалізацій")
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
                        isWrongSpecialization = false
                    }
                                        
                    if !name.isEmpty && !duration.isEmpty && !tuitionCost.isEmpty && !specialization.isEmpty && !writeModel.isLoadingFetchData
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
                                
                                statusSave = await writeModel.addNewSpeciality(name: name, duration: duration, tuitionCost: Int(tuitionCost) ?? 0, specialization: specialization, subjects: subjects)
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
                            if specialization.isEmpty
                            {
                                isWrongSpecialization = true
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
        .frame(width: 400, height: 430)
        .onAppear
        {
            Task
            {
                self.subjectList        = await writeModel.getSubjectNameList(withOut: "")
                self.specializationList = await writeModel.getSpecializationNameList(withOut: "")
            }
        }
    }
    
}
