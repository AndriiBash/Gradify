//
//  EditEducationProgramView.swift
//  Gradify
//
//  Created by Андрiй on 18.03.2024.
//

import SwiftUI

struct EditEducationProgramView: View
{
    @State private var editedName:                      String = ""
    @State private var editedDuration:                  String = ""
    @State private var editedDescription:               String = ""
    @State private var editedLevel:                     String = "Рівень відсутній"
    @State private var editedSpeciality:                String = "Без спеціальності"
    @State private var editedSpecialization:            [String] = []

    @State private var isWrongIdName:               Bool = false
    @State private var isWrongName:                 Bool = false
    @State private var isWrongDuration:             Bool = false
    @State private var isWrongLevel:                Bool = false
    @State private var isWrongSpeciality:           Bool = false
    @State private var isWrongDescription:          Bool = false
    @State private var isWrongLastSpecialiazation:  Bool = false
    @State private var isWrongSpecialiazation:      [Bool] = []

    @State private var specialityList:                  [String] = []
    @State private var specializationList:              [String] = []
    @State private var levelList:                       [String] = []

    @State private var statusSaveString:                String = "Зберегти"

    @State private var maxWidthForButton:               CGFloat = .zero

    @Binding var isShowView:                            Bool
    @Binding var isEditView:                            Bool
    @Binding var isUpdateListSpeciality:                Bool
    @Binding var educationProgram:                      EducationalProgram
    
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
                                    Text("Назва навчальної програми (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name education program

                    Picker("Рівень", selection: $editedLevel)
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
                    
                    TextField("Тривалість", text: $editedDuration)
                        .foregroundColor(isWrongDuration ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedDuration.isEmpty
                                {
                                    Text("Тривалість навчання")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for duration education program

                    Picker("Спеціальність", selection: $editedSpeciality)
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
                    TextField("Опис", text: $editedDescription)
                        .foregroundColor(isWrongDescription ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedDescription.isEmpty
                                {
                                    Text("Опис навчальної програми")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for description education program
                }// Section description eductation program
                
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
                                    editedSpecialization.remove(at: index)
                                    isWrongSpecialiazation.remove(at: index)
                                    isWrongLastSpecialiazation = false
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
                            if !editedSpecialization.contains("Спеціалізацію не обрано")
                            {
                                
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSpecialiazation = false
                                    
                                    editedSpecialization.append("Спеціалізацію не обрано")
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
                        isWrongDuration = false
                        isWrongLevel = false
                        isWrongSpeciality = false
                        isWrongDescription = false
                        isWrongLastSpecialiazation = false
                        isWrongSpecialiazation = Array(repeating: false, count: editedSpecialization.count)
                    }
                    
                    if !editedName.isEmpty && !editedDuration.isEmpty && editedLevel != "Рівень відсутній" && editedSpeciality != "Без спеціальності" && !editedDescription.isEmpty && !isWrongSpecialiazation.contains(true) && !editedSpecialization.contains("Спеціалізацію не обрано") && !writeModel.isLoadingFetchData
                    {
                        Task
                        {
                            let listEducationProgramKeyName = await writeModel.getEducatProgramNameList(withOut: educationProgram.name)
                            
                            if listEducationProgramKeyName.contains(editedName)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                let status = await writeModel.updateEducationProgram(id: educationProgram.id, name: editedName, level: editedLevel, duration: editedDuration, description: editedDescription, specialty: editedSpeciality, specializations: editedSpecialization)
                                
                                isUpdateListSpeciality.toggle()
                                
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
                            if editedDuration.isEmpty
                            {
                                isWrongDuration = true
                            }
                            if editedDescription.isEmpty
                            {
                                isWrongDescription = true
                            }
                            if editedLevel == "Рівень відсутній"
                            {
                                isWrongLevel = true
                            }
                            if editedSpeciality == "Без спеціальності"
                            {
                                isWrongSpeciality = true
                            }
                            
                            if editedSpecialization.contains("Спеціалізацію не обрано")
                            {
                                for index in editedSpecialization.indices
                                {
                                    if editedSpecialization[index] == "Спеціалізацію не обрано"
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
                    Text("\(statusSaveString)")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .help("Зберегти редаговану інформацію про навчальну програму")
                .keyboardShortcut(.defaultAction)
                .padding(.leading, 12)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
            .padding(.horizontal, 22)
        }// Main VStack
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
                self.specialityList         = await writeModel.getSpecialityNameList(withOut: "")
                self.specializationList     = await writeModel.getSpecializationNameList(withOut: "")
                self.levelList              = await writeModel.getLevelList()

                self.editedName = educationProgram.name
                self.editedDuration = educationProgram.duration
                self.editedDescription = educationProgram.description
                self.editedLevel = educationProgram.level
                self.editedSpeciality = educationProgram.specialty
                self.editedSpecialization = educationProgram.specializations
                self.isWrongSpecialiazation = Array(repeating: false, count: educationProgram.specializations.count)
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
