//
//  RowEducationalProgramView.swift
//  Gradify
//
//  Created by Андрiй on 18.03.2024.
//

import SwiftUI

struct RowEducationalProgramView: View
{
    @State private var hoverOnName:             Bool = false
    @State private var hoverOnSpeciality:       Bool = false
    @State private var hoverOnLavel:            Bool = false
    @State private var hoverOnDuration:         Bool = false
    @State private var hoverOnDescription:      Bool = false
    @State private var hoverOnSupecialization:  [Bool]

    @State private var statusCopyString:        String  = "Скопіювати"
    @State private var maxWidthForButton:       CGFloat = .zero

    @Binding var isShowView:                    Bool
    @Binding var isEditView:                    Bool
    
    var educationProgram:                       EducationalProgram
    
    
    init(isShowView: Binding<Bool>, isEditView: Binding<Bool>, educationProgram: EducationalProgram)
    {
        self._isShowView = isShowView
        self._isEditView = isEditView
        self.educationProgram = educationProgram
        
        self._hoverOnSupecialization = State(initialValue: Array(repeating: false, count: educationProgram.specializations.count))
    }

    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("[\(educationProgram.id)] \(educationProgram.name)")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                
                Spacer()
            }// HStack navigation panel
            .padding(.top, 8)
            
            Form
            {
                Section(header: Text("Головне"))
                {
                    HStack
                    {
                        Text("Назва")
                        
                        Spacer()
                        
                        Text("\(educationProgram.name)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnName ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                        { isHovered in
                            hoverOnName.toggle()
                        }
                        .contextMenu
                        {
                            Button
                            {
                                copyInBuffer(text: educationProgram.name)
                            }
                            label:
                            {
                                Text("Скопіювати назву")
                            }
                        }
                    }// HStack with name educationProgram
                    
                    HStack
                    {
                        Text("Рівень")
                        
                        Spacer()
                        
                        Text("\(educationProgram.level)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnLavel ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnLavel.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: educationProgram.level)
                                }
                                label:
                                {
                                    Text("Скопіювати рівень навчальної програми")
                                }
                            }
                    }// Hstack with level educationProgram
                    
                    HStack
                    {
                        Text("Тривалість")
                        
                        Spacer()
                        
                        Text("\(educationProgram.duration)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnDuration ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnDuration.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: educationProgram.duration)
                                }
                                label:
                                {
                                    Text("Скопіювати тривалість навчальної програми")
                                }
                            }
                    }// Hstack with duration educationProgram
                    
                    HStack
                    {
                        Text("Спеціальність")
                        
                        Spacer()
                        
                        Text("\(educationProgram.specialty)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnSpeciality ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnSpeciality.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: educationProgram.specialty)
                                }
                                label:
                                {
                                    Text("Скопіювати спеціаільність навчальної програми")
                                }
                            }
                    }// Hstack with speciality educationProgram
                }// Main Section
                
                Section(header: Text("Опис"))
                {
                    HStack
                    {
                        Text("Опис")
                        
                        Spacer()
                        
                        Text("\(educationProgram.description)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnDescription ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnDescription.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: educationProgram.description)
                                }
                                label:
                                {
                                    Text("Скопіювати опис навчальної програми")
                                }
                            }
                    }// Hstack with description educationProgram
                }// section with detail

                
                Section(header: Text("Спеціалізації"))
                {
                    if educationProgram.specializations.isEmpty
                    {
                        HStack
                        {
                            Spacer()
                            
                            Text("Спеціалізації відсутні")
                            
                            Spacer()
                        }// HStack with specializations educationProgram
                    }
                    else
                    {
                        ForEach(educationProgram.specializations.indices, id: \.self)
                        { index in
                            HStack
                            {
                                Text("Спеціалізація №\(index + 1)")
                                
                                Spacer()
                                
                                Text("\(educationProgram.specializations[index])")
                                    .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(hoverOnSupecialization.indices.contains(index) && hoverOnSupecialization[index] ? Color.gray.opacity(0.2) : Color.clear)
                                    )
                                    .onHover
                                    { isHovered in
                                        if isHovered
                                        {
                                            if !hoverOnSupecialization.indices.contains(index)
                                            {
                                                hoverOnSupecialization.append(false)
                                            }
                                        }
                                        hoverOnSupecialization[index].toggle()
                                    }
                                    .contextMenu
                                    {
                                        Button
                                        {
                                            copyInBuffer(text: educationProgram.specializations[index])
                                        }
                                        label:
                                        {
                                            Text("Скопіювати назву спеціаліації")
                                        }
                                }
                            }// ForEach with specialization education programm
                        }
                    }
                }// Section with specialization education programm

                
                
                
                
                

            }// Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .formStyle(.grouped)
            
            
            Spacer()
            Divider()
            
            HStack
            {
                Button
                {
                    isShowView = false
                    isEditView = true
                }
                label:
                {
                    Image(systemName: "square.and.pencil")
                }// button for edit row
                .padding(.trailing, 12)
                .help("Редагувати запис")
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }

                Spacer()
                                
                Button
                {
                    var allInfo = """
                            [\(educationProgram.id)] \(educationProgram.name)
                            ===========================================
                            Назва: \(educationProgram.name)
                            Рівень: \(educationProgram.level)
                            Тривалість: \(educationProgram.duration)
                            Спеціальність: \(educationProgram.specialty)
                            ===========================================
                            Опис: \(educationProgram.description)
                            ===========================================\n
                            """
                    
                    if !educationProgram.specializations.isEmpty
                    {
                        for index in educationProgram.specializations.indices
                        {
                            allInfo += "Спеціалізація №\(index) :" + "\(educationProgram.specializations[index])\n"
                        }
                        
                        allInfo += "==========================================="
                    }

                    copyInBuffer(text: allInfo)
                    statusCopyString = "Скопійовано!"
                }
                label:
                {
                    Text("\(statusCopyString)")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .help("Скопіювати усю інформацію навчальної програми")
                .padding(.horizontal, 12)
                
                Button
                {
                    isShowView = false
                    isShowView = false
                }
                label:
                {
                    Text("Готово")
                        .frame(minWidth: maxWidthForButton)
                }
                .onHover
                { isHovered in
                    changePointingHandCursor(shouldChangeCursor: isHovered)
                }// change cursor when hover
                .keyboardShortcut(.defaultAction)
            }// HStack with button's for manipulate form
            .padding(.vertical, 6)
            .padding(.bottom, 8)
            .padding(.horizontal, 22)
        }// Main VStack
        .foregroundColor(Color("MainTextForBlur"))
        .frame(width: 400, height: 565)
        .onAppear
        {
            let buttonWidth = getWidthFromString(for: "Скопіювати")
            let doneButtonWidth = getWidthFromString(for: "Готово")

            maxWidthForButton = max(buttonWidth, doneButtonWidth)
        }

    }
}
