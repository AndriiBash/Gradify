//
//  AddEducationProgramView.swift
//  Gradify
//
//  Created by Андрiй on 18.03.2024.
//

import SwiftUI

struct AddEducationProgramView: View
{
    @State private var name:                        String = ""
    @State private var duration:                    String = ""
    @State private var description:                 String = ""
    @State private var level:                       String = "Рівень відсутній"
    @State private var speciality:                  String = "Без спеціальності"
    @State private var specialization:              [String] = []

    @State private var isWrongIdName:               Bool = false
    @State private var isWrongName:                 Bool = false
    @State private var isWrongDuration:             Bool = false
    @State private var isWrongLevel:                Bool = false
    @State private var isWrongSpeciality:           Bool = false
    @State private var isWrongDescription:          Bool = false
    @State private var isWrongLastSpecialiazation:  Bool = false
    @State private var isWrongSpecialiazation:      [Bool] = []
    
    @State private var specialityList:              [String] = []
    @State private var specializationList:          [String] = []
    @State private var levelList:                   [String] = []

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
                
                Text("Додавання освітньої програми")
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
                                    Text("Назва навчальної програми (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name education program

                    Picker("Рівень", selection: $level)
                    {
                        Text("Рівень відсутній")
                                .tag("Рівень відсутній")

                        Divider()
                        
                        ForEach(levelList, id: \.self)
                        { level in
                            Text(level)
                                .tag(level)
                        }
                    }// Picker for select level education program
                    .foregroundColor(isWrongLevel ? Color.red : Color("PopUpTextColor"))
                    
                    TextField("Тривалість", text: $duration)
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
                            })// textField for duration education program

                    Picker("Спеціальність", selection: $speciality)
                    {
                        Text("Без спеціальності")
                                .tag("Без спеціальності")

                        Divider()
                        
                        ForEach(specialityList, id: \.self)
                        { speciality in
                            Text(speciality)
                                .tag(speciality)
                        }
                    }// Picker for select speciality education program
                    .foregroundColor(isWrongSpeciality ? Color.red : Color("PopUpTextColor"))

                    
                }// Section with main info
            
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
                                    Text("Опис навчальної програми")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for description education program
                }// Section description eductation program
                
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
                                { subject in
                                    Text(subject)
                                        .tag(subject)
                                }
                            }// Picker for select subject
                            .foregroundColor(isWrongSpecialiazation[index] ? Color.red : Color("PopUpTextColor"))
                            
                            Button
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    specialization.remove(at: index)
                                    isWrongSpecialiazation.remove(at: index)
                                }
                            }
                            label:
                            {
                                Image(systemName: "trash")
                                    .aspectRatio(contentMode: .fit)
                            }// Button for delete specialization
                            .help("Видалити спеціалізацію")
                        }
                    }
                    
                    HStack
                    {
                        if isWrongLastSpecialiazation
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
                                    isWrongLastSpecialiazation = false
                                    
                                    specialization.append("Спеціалізацію не обрано")
                                    isWrongSpecialiazation.append(false)
                                }
                            }
                            else
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSpecialiazation = true
                                }
                            }
                        }
                        label:
                        {
                            Image(systemName: "plus")
                                .aspectRatio(contentMode: .fit)
                        }// Button for add subject
                        .help("Додати нову спеціалізацію яка присутня в навчальній програми")
                    }// HStack with button for add specialiazation
                }// Section specialiaztion
            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            Spacer()
            
            if isWrongName || isWrongDuration || isWrongLevel || isWrongSpeciality || isWrongDescription || isWrongSpecialiazation.contains(true)
            {
                Text("Заповніть всі поля коректно")
                    .foregroundColor(Color.red)
            }
            
            if isWrongIdName
            {
                Text("Назва навчальної програми не повина збігатися з назвами інших навчальних програм")
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
                        isWrongLevel = false
                        isWrongSpeciality = false
                        isWrongDescription = false
                        isWrongLastSpecialiazation = false
                        isWrongSpecialiazation = Array(repeating: false, count: specialization.count)
                    }
                    
                    if !name.isEmpty && !duration.isEmpty && level != "Рівень відсутній" && speciality != "Без спеціальності" && !description.isEmpty && !isWrongSpecialiazation.contains(true) && !specialization.contains("Спеціалізацію не обрано") && !writeModel.isLoadingFetchData
                    {
                                                
                        Task
                        {
                            let listEducationProgramKeyName = await writeModel.getEducatProgramNameList(withOut: "")
                        
                            if listEducationProgramKeyName.contains(name)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                isShowForm = false
                                              
                                statusSave = await writeModel.addNewEducationProgram(name: name, level: level, duration: duration, description: description, specialty: speciality, specializations: specialization)
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
                            if description.isEmpty
                            {
                                isWrongDescription = true
                            }
                            if level == "Рівень відсутній"
                            {
                                isWrongLevel = true
                            }
                            if speciality == "Без спеціальності"
                            {
                                isWrongSpeciality = true
                            }
                            
                            if specialization.contains("Спеціалізацію не обрано")
                            {
                                for index in specialization.indices
                                {
                                    if specialization[index] == "Спеціалізацію не обрано"
                                    {
                                        isWrongSpecialiazation[index] = true
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
                self.specialityList         = await writeModel.getSpecialityNameList(withOut: "")
                self.specializationList     = await writeModel.getSpecializationNameList(withOut: "")
                self.levelList              = await writeModel.getLevelList()
            }
        }
    }
}
