//
//  EditSpecialityView.swift
//  Gradify
//
//  Created by Андрiй on 17.03.2024.
//

import SwiftUI

struct EditSpecialityView: View
{
    @State private var editedName:                      String = ""
    @State private var editedDuration:                  String = ""
    @State private var editedTuitionCost:               String = ""
    @State private var editedSpecialization:            String = "Без спеціалізації"
    @State private var editedBranch:                    String = "Без галузі"
    @State private var editedSubjects:                  [String] = []

    @State private var isWrongIdName:                   Bool = false
    @State private var isWrongName:                     Bool = false
    @State private var isWrongDuration:                 Bool = false
    @State private var isWrongTuitionCost:              Bool = false
    @State private var isWrongSpecialization:           Bool = false
    @State private var isWrongBranch:                   Bool = false
    @State private var isWrongLastSubject:              Bool = false
    @State private var isWrongSubjects:                 [Bool] = []
    
    @State private var subjectList:                     [String] = []
    @State private var specializationList:              [String] = []
    @State private var branchList:                      [String] = []

    @State private var statusSaveString:                String = "Зберегти"

    @State private var maxWidthForButton:               CGFloat = .zero

    @Binding var isShowView:                            Bool
    @Binding var isEditView:                            Bool
    @Binding var isUpdateListSpeciality:                Bool
    @Binding var speciality:                            Specialty
    
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
                                    Text("Назва спеціальності (ID)")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for name specialty

                    TextField("Тривалість навчання", text: $editedDuration)
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
                            })// textField for duration study
                    
                    
                    TextField("Вартість навчання", text: $editedTuitionCost)
                        .foregroundColor(isWrongTuitionCost ? Color.red : Color("MainTextForBlur"))
                        .overlay(
                            HStack
                            {
                                Spacer()
                                
                                if editedTuitionCost.isEmpty
                                {
                                    Text("300 грн")
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 12)
                                }
                            })// textField for tuition coast
                        .onChange(of: editedTuitionCost)
                        { _, newValue in
                            let filteredValue = newValue.filter { "0123456789".contains($0) }
                            editedTuitionCost = filteredValue
                        }
                    
                    
                    Picker("Галузь", selection: $editedBranch)
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
                    .onChange(of: editedBranch)
                    { _, newValue in
                        
                        Task
                        {
                            self.specializationList = await writeModel.getSpecializationNameList(branch: newValue)
                            
                            if !specializationList.contains(editedSpecialization)
                            {
                                editedSpecialization = "Без спеціалізації"
                            }
                        }
                    }
                
                    Picker("Спеціалізація", selection: $editedSpecialization)
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
                    ForEach(editedSubjects.indices, id: \.self)
                    { index in
                        HStack(alignment: .center)
                        {
                            Picker("Предмет №\(index + 1)", selection: $editedSubjects[index])
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
                                    editedSubjects.remove(at: index)
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
                            Text("Заповніть попередній предмет!")
                                .foregroundColor(Color.red)
                        }

                        Spacer()
                        
                        Button
                        {
                            if !editedSubjects.contains("Предмет не обрано")
                            {
                                withAnimation(Animation.easeIn(duration: 0.25))
                                {
                                    isWrongLastSubject = false

                                    editedSubjects.append("Предмет не обрано")
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
                        isWrongTuitionCost = false
                        isWrongBranch = false
                        isWrongSpecialization = false
                        isWrongLastSubject = false
                        isWrongSubjects = Array(repeating: false, count: editedSubjects.count)
                    }
                    
                    if !editedName.isEmpty && !editedDuration.isEmpty && !editedTuitionCost.isEmpty && editedBranch != "Без галузі" && editedSpecialization != "Без спеціалізації" && !editedSubjects.contains("Предмет не обрано") && !isWrongSubjects.contains(true) && !writeModel.isLoadingFetchData
                    {
                        Task
                        {
                            let listSpecialityKeyName = await writeModel.getSpecialityNameList(withOut: speciality.name)
                            
                            if listSpecialityKeyName.contains(editedName)
                            {
                                withAnimation(Animation.easeIn(duration: 0.35))
                                {
                                    isWrongIdName = true
                                }
                            }
                            else
                            {
                                let status = await writeModel.updateSpeciality(id: speciality.id, name: editedName, duration: editedDuration, tuitionCost: Int(editedTuitionCost) ?? 0, specialization: editedSpecialization, branch: editedBranch, subjects: editedSubjects)
                                
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
                            if editedTuitionCost.isEmpty
                            {
                                isWrongTuitionCost = true
                            }
                            if editedSpecialization == "Без спеціалізації"
                            {
                                isWrongSpecialization = true
                            }
                            if editedBranch == "Без галузі"
                            {
                                isWrongBranch = true
                            }
                            if editedSubjects.contains("Предмет не обрано")
                            {
                                for index in editedSubjects.indices
                                {
                                    if editedSubjects[index] == "Предмет не обрано"
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
                    Text("\(statusSaveString)")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .help("Зберегти редаговану інформацію про спеціалізацію")
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
                self.editedName = speciality.name
                self.editedDuration = speciality.duration
                self.editedTuitionCost = String(speciality.tuitionCost)
                self.editedSpecialization = speciality.specialization
                self.editedBranch = speciality.branch
                self.editedSubjects = speciality.subjects
                self.isWrongSubjects = Array(repeating: false, count: speciality.subjects.count)

                self.subjectList        = await writeModel.getSubjectNameList(withOut: "")
                self.branchList         = await writeModel.getBranchName()
            }
        }
    }
}
