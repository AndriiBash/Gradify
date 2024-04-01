//
//  RowSpecialityView.swift
//  Gradify
//
//  Created by Андрiй on 16.03.2024.
//

import SwiftUI

struct RowSpecialityView: View
{
    @State private var hoverOnName:             Bool = false
    @State private var hoverOnDuration:         Bool = false
    @State private var hoverOnTuitionCost:      Bool = false
    @State private var hoverOnSpecialization:   Bool = false
    @State private var hoverOnBranch:           Bool = false

    @State private var hoverOnSubject:          [Bool]

    @State private var statusCopyString:        String  = "Скопіювати"
    @State private var maxWidthForButton:       CGFloat = .zero

    @Binding var isShowView:                    Bool
    @Binding var isEditView:                    Bool
    
    var speciality:                             Specialty
    
    
    init(isShowView: Binding<Bool>, isEditView: Binding<Bool>, speciality: Specialty)
    {
        self._isShowView = isShowView
        self._isEditView = isEditView
        self.speciality = speciality
        
        self._hoverOnSubject = State(initialValue: Array(repeating: false, count: speciality.subjects.count))
    }

    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .center)
            {
                Spacer()
                
                Text("[\(speciality.id)] \(speciality.name)")
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
                        
                        Text("\(speciality.name)")
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
                                copyInBuffer(text: speciality.name)
                            }
                            label:
                            {
                                Text("Скопіювати назву")
                            }
                        }
                    }// HStack with name speciality
                    
                    HStack
                    {
                        Text("Тривалість навчання")
                        
                        Spacer()
                        
                        Text("\(speciality.duration)")
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
                                    copyInBuffer(text: speciality.duration)
                                }
                                label:
                                {
                                    Text("Скопіювати тривалість навчання")
                                }
                            }
                    }// Hstack with duration teach on speciality
                    
                    HStack
                    {
                        Text("Вартість навчання")
                        
                        Spacer()
                        
                        Text("\(speciality.tuitionCost) грн")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnTuitionCost ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnTuitionCost.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: String(speciality.tuitionCost) + " грн")
                                }
                                label:
                                {
                                    Text("Скопіювати вартість навчання")
                                }
                            }
                    }// Hstack with tuition cost speciality
                    
                    HStack
                    {
                        Text("Галузь")
                        
                        Spacer()
                        
                        Text("\(speciality.branch)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnBranch ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnBranch.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: speciality.branch)
                                }
                                label:
                                {
                                    Text("Скопіювати галузь спеціальноті")
                                }
                            }
                    }// Hstack with branch speciality

                    HStack
                    {
                        Text("Спеціалізація")
                        
                        Spacer()
                        
                        Text("\(speciality.specialization)")
                            .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(hoverOnSpecialization ? Color.gray.opacity(0.2) : Color.clear)
                            )
                            .onHover
                            { isHovered in
                                hoverOnSpecialization.toggle()
                            }
                            .contextMenu
                            {
                                Button
                                {
                                    copyInBuffer(text: speciality.specialization)
                                }
                                label:
                                {
                                    Text("Скопіювати спеціалізацію спеціальноті")
                                }
                            }
                    }// Hstack with specialization speciality
                }// Main Section
                
                Section(header: Text("Предмети"))
                {
                    if speciality.subjects.isEmpty
                    {
                        HStack
                        {
                            Spacer()
                            
                            Text("Навчальні предмети відсутні")
                            
                            Spacer()
                        }// HStack with info about none subject learning
                    }
                    else
                    {
                        ForEach(speciality.subjects.indices, id: \.self)
                        { index in
                            HStack
                            {
                                Text("Предмет №\(index + 1)")
                                
                                Spacer()
                                
                                Text("\(speciality.subjects[index])")
                                    .foregroundColor(Color("MainTextForBlur").opacity(0.7))
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(hoverOnSubject.indices.contains(index) && hoverOnSubject[index] ? Color.gray.opacity(0.2) : Color.clear)
                                    )
                                    .onHover
                                    { isHovered in
                                        if isHovered
                                        {
                                            if !hoverOnSubject.indices.contains(index)
                                            {
                                                hoverOnSubject.append(false)
                                            }
                                        }
                                        hoverOnSubject[index].toggle()
                                    }
                                    .contextMenu
                                    {
                                        Button
                                        {
                                            copyInBuffer(text: speciality.subjects[index])
                                        }
                                        label:
                                        {
                                            Text("Скопіювати назву предмету")
                                        }
                                }
                            }// ForEach with learn subject in speciality
                        }
                    }
                }// Section with subject in speciality
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
                            [\(speciality.id)] \(speciality.name)
                            ===========================================
                            Назва: \(speciality.name)
                            Тривалість навчання: \(speciality.duration)
                            Вартість навчання: \(speciality.tuitionCost)
                            Галузь: \(speciality.branch)
                            Спеціалізація: \(speciality.specialization)
                            ===========================================\n
                            """
                    
                    if !speciality.subjects.isEmpty
                    {
                        for index in speciality.subjects.indices
                        {
                            allInfo += "Предмет №\(index + 1) :" + "\(speciality.subjects[index])\n"
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
                .help("Скопіювати усю інформацію спеціальності")
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
